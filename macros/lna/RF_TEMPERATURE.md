# Package-level TT temperature reproduction

From `macros/lna`, run:

```sh
make sim-rf-temperature
```

Requirements: Bash, Make, Xschem, ngspice with the required PSP
OSDI model loaded, Python 3 with NumPy, and the configured
IHP SG13CMOS5L PDK. Testing used ngspice 47 in the existing container.

The runner regenerates the temperature testbench netlist and runs
the baseline at 27 C, then runs -40, 27 and 125 C at MOS corner TT.
TNOM remains the model reference temperature; only TEMP is varied.
Device sizes, matching values and package assumptions are unchanged.
This is not a combined process, voltage and temperature sweep.

Each dataset is checked for 401 rows, eight columns, finite values,
increasing frequency and endpoints of 100 MHz and 10 GHz.
Fresh data and logs are retained in a unique directory:
`testbenches/xschem/simulations/rf-temperature-*`.
Inspect the corresponding temperature log if a run fails.

After all three datasets pass validation, they replace
`lna_sp_package_temp_{m40C,27C,125C}.dat` in
`testbenches/xschem/plot_simulations/data`.
The baseline run also rewrites `lna_sp_package.dat`.
Back up results you wish to preserve before running.

The old command `make sim-xschem TB=lna_tb_sp_package_temperature`
alone runs only the configured temperature, currently 27 C.

The three manually regenerated temperature datasets matched all
401 rows of the saved datasets numerically, with zero differences
in frequency, S11, S21, S12, S22 and K. The automated runner also
completed successfully in the temporary project copy.
These checks do not establish reproducibility in a clean environment.

PASS indicates complete datasets, not compliance with RF specifications.
The pad and bond-wire models remain preliminary assumptions.
