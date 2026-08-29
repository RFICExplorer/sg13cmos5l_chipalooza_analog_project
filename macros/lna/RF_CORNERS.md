# Package-level MOS corner reproduction

From `macros/lna`, run:

```sh
make sim-rf-corners
```

Requirements: Bash, Make, Xschem, ngspice with the required PSP
OSDI model loaded, Python 3 with NumPy, and the configured
IHP SG13CMOS5L PDK. Verification used ngspice 47 in the existing
IIC-OSIC-TOOLS container, not an independently provisioned environment.

The runner regenerates the netlist and runs the baseline TT
testbench, then runs TT, SS, FF, SF and FS separately.
The current testbench uses 27 C and 401 points from 100 MHz to 10 GHz.
Device sizes, matching values and package assumptions are unchanged.

Fresh results and logs are retained in a unique directory:
`testbenches/xschem/simulations/rf-corners-*`.
If execution fails, inspect the corresponding corner log there.

Each dataset is checked for shape, finite values, increasing
frequency and the expected endpoints. After all five pass,
the runner replaces the corresponding files in
`testbenches/xschem/plot_simulations/data`:
`lna_sp_package_mos_{tt,ss,ff,sf,fs}.dat`.
The initial baseline run also rewrites `lna_sp_package.dat`.
Back up any results you wish to preserve before running.

Important: `make sim-xschem TB=lna_tb_sp_package_corner`
alone runs only the selected corner, currently TT.
Use `make sim-rf-corners` to regenerate all five corner datasets.
The plotting script `plot_lna_rf.py` reads saved data;
it does not generate corner simulations.

Verification: all 401 rows in each of the five freshly generated
files matched the existing files numerically, with zero differences
in the saved frequency, S11, S21, S12, S22 and K columns.

PASS means the datasets passed the structural checks, not that
the LNA meets its RF specifications. This procedure does not
validate the preliminary pad model or establish stability across
all conditions. Noise, temperature and linearity tests are separate.
