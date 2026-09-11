#!/usr/bin/env bash
# Reproduce the package-level two-tone IIP3 sweep.
set -euo pipefail

cd "$(dirname "$0")/.."

make sim-xschem TB=lna_tb_iip3_package

sim_dir=testbenches/xschem/simulations
base_netlist="$sim_dir/lna_tb_iip3_package.spice"

test -f "$base_netlist"
test "$(grep -o '6.324555320e-03' "$base_netlist" | wc -l)" -eq 2
test "$(grep -Ec '^let IIP3_DBM=-40[+]' "$base_netlist")" -eq 1
test "$(grep -Ec '^echo PIN_PER_TONE_DBM = -40$' "$base_netlist")" -eq 1

results_dir=$(mktemp -d "$sim_dir/iip3-sweep-XXXXXX")
broad_csv="$results_dir/lna_iip3_package.csv"
low_csv="$results_dir/lna_iip3_package_low_power.csv"

header='pin_per_tone_dbm,fund_avg_dbm,im3_avg_dbm,iip3_dbm,oip3_dbm'
printf '%s\n' "$header" > "$broad_csv"
printf '%s\n' "$header" > "$low_csv"

run_point() {
    pin_dbm=$1
    amplitude=$(
        awk -v pin="$pin_dbm" 'BEGIN {
            printf "%.12e", sqrt(400 * (10 ^ ((pin - 30) / 10)))
        }'
    )

    tag=$(printf '%s' "$pin_dbm" | sed 's/-/m/; s/[.]/p/')
    point_netlist="$results_dir/iip3_${tag}.spice"
    point_log="$results_dir/iip3_${tag}.log"
    point_row="$results_dir/iip3_${tag}.row"

    printf 'Running Pin per tone = %s dBm\n' "$pin_dbm"

    sed \
        -e "s/6[.]324555320e-03/$amplitude/g" \
        -e "s/IIP3_DBM=-40+/IIP3_DBM=${pin_dbm}+/" \
        -e "s/PIN_PER_TONE_DBM = -40/PIN_PER_TONE_DBM = ${pin_dbm}/" \
        "$base_netlist" > "$point_netlist"

    ngspice -b "$point_netlist" > "$point_log" 2>&1

    fund_avg_dbm=$(
        awk '$1 == "fund_avg_dbm" && $2 == "=" {print $3; exit}' "$point_log"
    )
    im3_avg_dbm=$(
        awk '$1 == "im3_avg_dbm" && $2 == "=" {print $3; exit}' "$point_log"
    )
    iip3_dbm=$(
        awk '$1 == "iip3_dbm" && $2 == "=" {print $3; exit}' "$point_log"
    )
    oip3_dbm=$(
        awk '$1 == "oip3_dbm" && $2 == "=" {print $3; exit}' "$point_log"
    )

    test -n "$fund_avg_dbm"
    test -n "$im3_avg_dbm"
    test -n "$iip3_dbm"
    test -n "$oip3_dbm"

    printf '%s,%.8f,%.8f,%.8f,%.8f\n' \
        "$pin_dbm" \
        "$fund_avg_dbm" \
        "$im3_avg_dbm" \
        "$iip3_dbm" \
        "$oip3_dbm" > "$point_row"
}

for pin_dbm in -45 -42.5 -40 -37.5 -35 -32.5; do
    run_point "$pin_dbm"
done

for pin_dbm in -40 -37.5 -35 -32.5; do
    tag=$(printf '%s' "$pin_dbm" | sed 's/-/m/; s/[.]/p/')
    cat "$results_dir/iip3_${tag}.row" >> "$broad_csv"
done

for pin_dbm in -45 -42.5 -40; do
    tag=$(printf '%s' "$pin_dbm" | sed 's/-/m/; s/[.]/p/')
    cat "$results_dir/iip3_${tag}.row" >> "$low_csv"
done

python3 - "$low_csv" "$results_dir/iip3_summary.txt" <<'PY'
import csv
import sys
from pathlib import Path

csv_path = Path(sys.argv[1])
summary_path = Path(sys.argv[2])

with csv_path.open(newline="") as stream:
    rows = list(csv.DictReader(stream))

pin = [float(row["pin_per_tone_dbm"]) for row in rows]
fund = [float(row["fund_avg_dbm"]) for row in rows]
im3 = [float(row["im3_avg_dbm"]) for row in rows]

fund_intercept = sum(y - x for x, y in zip(pin, fund)) / len(pin)
im3_intercept = sum(y - 3.0 * x for x, y in zip(pin, im3)) / len(pin)

input_iip3 = (fund_intercept - im3_intercept) / 2.0
output_iip3 = input_iip3 + fund_intercept

summary = (
    f"Input IIP3 = {input_iip3:.6f} dBm\n"
    f"Output OIP3 = {output_iip3:.6f} dBm\n"
)

summary_path.write_text(summary)
print(summary, end="")
PY

printf 'PASS: IIP3 sweep completed\n'
printf 'Results retained for review in: %s\n' "$results_dir"
