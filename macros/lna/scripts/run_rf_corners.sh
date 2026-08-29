#!/usr/bin/env bash
# Run package-level MOS corners using the current schematic.
set -euo pipefail
cd "$(dirname "$0")/.."

# Regenerate the baseline netlist using the existing project flow.
make sim-xschem TB=lna_tb_sp_package_corner
cd testbenches/xschem/simulations
netlist=lna_tb_sp_package_corner.spice

# Stop if the expected template has changed.
test "$(grep -Ec '^[[:space:]]*\.lib[[:space:]].*cornerMOSlv\.lib[[:space:]]+mos_tt[[:space:]]*$' "$netlist")" -eq 1
test "$(grep -Fc 'wrdata ../plot_simulations/data/lna_sp_package.dat ' "$netlist")" -eq 1

# Fresh staging prevents old data from being mistaken for new results.
results_dir=$(mktemp -d "$PWD/rf-corners-XXXXXX")
printf "Logs and fresh results: %s\n" "$results_dir"
for corner in tt ss ff sf fs; do
  printf "Running MOS corner: %s\n" "$corner"
  sed \
    -e "s/cornerMOSlv.lib mos_tt/cornerMOSlv.lib mos_${corner}/" \
    -e "s|../plot_simulations/data/lna_sp_package.dat|$results_dir/lna_sp_package_mos_${corner}.dat|" \
    "$netlist" |
    ngspice -b > "$results_dir/${corner}.log" 2>&1
  python3 -c '
import sys
import numpy as np
data = np.loadtxt(sys.argv[1], skiprows=1, ndmin=2)
if data.shape != (401, 8) or not np.isfinite(data).all():
    raise SystemExit("Invalid or incomplete corner data")
if not np.all(np.diff(data[:, 0]) > 0):
    raise SystemExit("Frequency must increase")
if not np.allclose(data[[0, -1], 0], [1e8, 1e10]):
    raise SystemExit("Unexpected frequency range")
' "$results_dir/lna_sp_package_mos_${corner}.dat"
done

# Publish only after every corner has completed and passed validation.
for corner in tt ss ff sf fs; do
  cp "$results_dir/lna_sp_package_mos_${corner}.dat" ../plot_simulations/data/
done
printf "PASS: five fresh corner datasets saved; logs in %s\n" "$results_dir"
