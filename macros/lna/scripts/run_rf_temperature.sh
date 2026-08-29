#!/usr/bin/env bash
# Run package-level temperature checks at the TT process corner.
set -euo pipefail
cd "$(dirname "$0")/.."
make sim-xschem TB=lna_tb_sp_package_temperature
cd testbenches/xschem/simulations
netlist=lna_tb_sp_package_temperature.spice

test "$(grep -Ec '^[[:space:]]*\.temp[[:space:]]+27[[:space:]]*$' "$netlist")" -eq 1
test "$(grep -Ec '^[[:space:]]*\.lib[[:space:]].*cornerMOSlv\.lib[[:space:]]+mos_tt[[:space:]]*$' "$netlist")" -eq 1
test "$(grep -Fc 'wrdata ../plot_simulations/data/lna_sp_package.dat ' "$netlist")" -eq 1

results_dir=$(mktemp -d "$PWD/rf-temperature-XXXXXX")
printf "Logs and fresh results: %s\n" "$results_dir"
for temperature in -40 27 125; do
  label="${temperature}C"
  if [ "$temperature" = "-40" ]; then label=m40C; fi
  printf "Running TT at %s C\n" "$temperature"
  sed \
    -e "s/^[[:space:]]*\.temp[[:space:]]*27[[:space:]]*$/.temp $temperature/" \
    -e "s|../plot_simulations/data/lna_sp_package.dat|$results_dir/lna_sp_package_temp_${label}.dat|" \
    "$netlist" |
    ngspice -b > "$results_dir/${label}.log" 2>&1
  python3 -c '
import sys
import numpy as np
data = np.loadtxt(sys.argv[1], skiprows=1, ndmin=2)
if data.shape != (401, 8) or not np.isfinite(data).all():
    raise SystemExit("Invalid or incomplete temperature data")
if not np.all(np.diff(data[:, 0]) > 0):
    raise SystemExit("Frequency must increase")
if not np.allclose(data[[0, -1], 0], [1e8, 1e10]):
    raise SystemExit("Unexpected frequency range")
' "$results_dir/lna_sp_package_temp_${label}.dat"
done

# Replace published datasets only after all three pass validation.
for label in m40C 27C 125C; do
  cp "$results_dir/lna_sp_package_temp_${label}.dat" ../plot_simulations/data/
done
printf "PASS: three fresh temperature datasets saved; logs in %s\n" "$results_dir"
