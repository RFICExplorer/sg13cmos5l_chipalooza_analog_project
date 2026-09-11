#!/usr/bin/env bash
# Reproduce the package-level P1dB sweep from the current Xschem schematic.
set -euo pipefail

cd "$(dirname "$0")/.."

make sim-xschem TB=lna_tb_p1db_package

cd testbenches/xschem/simulations
netlist=lna_tb_p1db_package.spice

source_line='VNOISE_IN SOURCE_NODE GND sin(0 6.324555e-3 2.425G)'
echo_line='echo PIN_DBM = -40'

test "$(grep -Fxc "$source_line" "$netlist")" -eq 1
test "$(grep -Fxc "$echo_line" "$netlist")" -eq 1

results_dir=$(mktemp -d "$PWD/p1db-sweep-XXXXXX")
broad_csv="$results_dir/lna_p1db_package.csv"
refined_csv="$results_dir/lna_p1db_package_refined.csv"

printf '%s\n' \
'pin_dbm,pout_fund_dbm,pout_dbm,gain_fund_db' \
> "$broad_csv"

printf '%s\n' \
'pin_dbm,pout_fund_dbm,pout_dbm,gain_fund_db' \
> "$refined_csv"

run_point() {
    local pin_dbm=$1
    local output_csv=$2
    local label amplitude run_netlist log_file
    local pout_fund_dbm pout_dbm gain_fund_db

    label=${pin_dbm//-/m}
    label=${label//./p}

    amplitude=$(python3 -c '
import math
import sys

pin_dbm = float(sys.argv[1])
vpeak = math.sqrt(8.0 * 50.0 * 1e-3 * 10.0 ** (pin_dbm / 10.0))
print(f"{vpeak:.12e}")
' "$pin_dbm")

    run_netlist="$results_dir/p1db_${label}.spice"
    log_file="$results_dir/p1db_${label}.log"

    sed \
        -e "s|$source_line|VNOISE_IN SOURCE_NODE GND sin(0 $amplitude 2.425G)|" \
        -e "s|$echo_line|echo PIN_DBM = $pin_dbm|" \
        "$netlist" > "$run_netlist"

    printf 'Running Pin = %s dBm\n' "$pin_dbm"

    ngspice -b "$run_netlist" > "$log_file" 2>&1

    pout_fund_dbm=$(awk '
tolower($1) == "pout_fund_dbm" && $2 == "=" {
    value = $3
}
END {
    if (value == "") exit 1
    print value
}
' "$log_file")

    pout_dbm=$(awk '
tolower($1) == "pout_dbm" && $2 == "=" {
    value = $3
}
END {
    if (value == "") exit 1
    print value
}
' "$log_file")

    gain_fund_db=$(python3 -c '
import sys
print(f"{float(sys.argv[1]) - float(sys.argv[2]):.8f}")
' "$pout_fund_dbm" "$pin_dbm")

    printf '%s,%.8f,%.8f,%s\n' \
        "$pin_dbm" "$pout_fund_dbm" "$pout_dbm" "$gain_fund_db" \
        >> "$output_csv"
}

for pin_dbm in $(seq -40 2 -4); do
    run_point "$pin_dbm" "$broad_csv"
done

for pin_dbm in $(seq -26 0.25 -23); do
    run_point "$pin_dbm" "$refined_csv"
done

python3 - "$broad_csv" "$refined_csv" "$results_dir/p1db_summary.txt" <<'PY'
import sys
from pathlib import Path

import numpy as np

broad_path = Path(sys.argv[1])
refined_path = Path(sys.argv[2])
summary_path = Path(sys.argv[3])

broad = np.genfromtxt(broad_path, delimiter=",", names=True)
refined = np.genfromtxt(refined_path, delimiter=",", names=True)

small_signal_mask = broad["pin_dbm"] <= -36.0
small_signal_gain = float(np.mean(broad["gain_fund_db"][small_signal_mask]))

compression = small_signal_gain - refined["gain_fund_db"]

crossing = None
for index in range(len(compression) - 1):
    if compression[index] <= 1.0 <= compression[index + 1]:
        crossing = index
        break

if crossing is None:
    raise SystemExit("P1dB crossing was not found")

i = crossing
fraction = (
    (1.0 - compression[i])
    / (compression[i + 1] - compression[i])
)

input_p1db = float(
    refined["pin_dbm"][i]
    + fraction
    * (refined["pin_dbm"][i + 1] - refined["pin_dbm"][i])
)

output_p1db = float(
    refined["pout_fund_dbm"][i]
    + fraction
    * (
        refined["pout_fund_dbm"][i + 1]
        - refined["pout_fund_dbm"][i]
    )
)

refined_with_compression = np.column_stack(
    (
        refined["pin_dbm"],
        refined["pout_fund_dbm"],
        refined["pout_dbm"],
        refined["gain_fund_db"],
        compression,
    )
)

np.savetxt(
    refined_path,
    refined_with_compression,
    delimiter=",",
    header=(
        "pin_dbm,pout_fund_dbm,pout_dbm,"
        "gain_fund_db,compression_db"
    ),
    comments="",
    fmt="%.8f",
)

summary = (
    f"Small-signal gain = {small_signal_gain:.6f} dB\n"
    f"Input P1dB = {input_p1db:.6f} dBm\n"
    f"Output P1dB = {output_p1db:.6f} dBm\n"
)

summary_path.write_text(summary)
print(summary, end="")
PY

printf 'PASS: P1dB sweep completed\n'
printf 'Results retained for review in: %s\n' "$results_dir"
