# IHP SG13CMOS5L 2.4 GHz Cascode LNA

## Overview

This directory contains the pre-layout implementation and verification environment for a 2.40-2.45 GHz cascode low-noise amplifier using the IHP SG13CMOS5L open-source PDK, Xschem, and ngspice.

The current design is a review-stage schematic, not a tapeout-ready implementation. It includes nominal, package-assumption, process-corner, temperature, wideband-stability, noise, compression, and two-tone linearity simulations.

## Core Design

- Topology: inductively degenerated cascode LNA
- Supply voltage: 1.2 V
- Supply current: approximately 3.67 mA
- DC power: approximately 4.4 mW
- Frequency band: 2.40-2.45 GHz
- RF NMOS devices: IHP `sg13_lv_rf_nmos`
- Input gate inductance: 12.1 nH
- Source-degeneration inductance: 2.00 nH
- Drain-load inductance: 5 nH

Both RF NMOS devices operate in saturation at the nominal bias point.

## Preliminary Package Assumptions

The package-level testbenches presently use:

- 2.5 nH bond-wire inductance per RF port
- 0.15 ohm bond-wire resistance per RF port
- 200 fF pad capacitance per RF port

These values are preliminary assumptions and must be replaced or refined using the final package and pad information.

## Nominal TT Results at 27 C

| Frequency | S11 | S21 | S22 | K | Noise Figure |
| --- | ---: | ---: | ---: | ---: | ---: |
| 2.400 GHz | -9.88 dB | 18.36 dB | -6.27 dB | 1.719 | 0.831 dB |
| 2.425 GHz | -12.14 dB | 19.13 dB | -10.85 dB | 1.708 | 0.834 dB |
| 2.450 GHz | -13.30 dB | 19.42 dB | -21.46 dB | 1.699 | 0.837 dB |

Additional preliminary results:

- Input P1dB at 2.425 GHz: approximately -24.69 dBm
- Output P1dB at 2.425 GHz: approximately -6.51 dBm
- Two-tone IIP3 at 2.420 and 2.430 GHz: approximately -11.84 dBm per tone
- OIP3: approximately +7.29 dBm
- Wideband minimum K: 1.679 from 100 MHz to 10 GHz at nominal TT and 27 C

## Verification Coverage

The tracked testbenches cover:

- DC bias and DC sweep
- AC gain
- Nominal two-port S-parameters
- Package-level S-parameters and noise figure
- TT, SS, FF, SF, and FS process corners at 27 C
- TT temperature checks at -40 C, 27 C, and 125 C
- Wideband stability from 100 MHz to 10 GHz
- Package-level P1dB
- Package-level two-tone IIP3

See [PRELAYOUT_RESULTS.md](PRELAYOUT_RESULTS.md) for the detailed summary, reproduction commands, figures, and limitations.

## Main Files

- `schematic/xschem/lna.sch`: LNA core schematic
- `schematic/xschem/lna.sym`: LNA symbol
- `testbenches/xschem/`: simulation testbenches
- `testbenches/xschem/plot_simulations/data/`: tracked simulation data
- `testbenches/xschem/plot_simulations/figures/`: review plots
- `testbenches/xschem/plot_simulations/plot_lna_rf.py`: RF and noise plotting script
- `testbenches/xschem/plot_simulations/plot_lna_linearity.py`: linearity plotting script

## Current Limitations

- Matching elements are ideal.
- Pad and bond-wire models are preliminary.
- Matching does not remain better than -10 dB at every process corner, temperature, and band edge.
- A combined PVT and linearity-corner campaign has not been completed.
- Statistical mismatch has not been evaluated.
- Layout, realistic passive implementation, extraction, DRC, LVS, and post-layout verification remain future work.
- Stability and matching must be rechecked after layout and parasitic extraction.
