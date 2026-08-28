# IHP SG13CMOS5L LNA - Pre-Layout Results

## Operating Point

- Frequency band: 2.40-2.45 GHz
- Supply voltage: 1.2 V
- Supply current: approximately 3.67 mA
- DC power: approximately 4.4 mW
- Both RF NMOS devices operate in saturation.

## Preliminary Package Assumptions

- Bond-wire inductance: 2.5 nH per RF port
- Bond-wire resistance: 0.15 ohm per RF port
- Pad capacitance: 200 fF per RF port
- Pad capacitance was swept from 0 to 500 fF.
- The PDK bondpad subcircuit is currently an electrically empty placeholder.

## Nominal TT Results at 27 C

| Frequency | S11 | S21 | S22 | K | Noise Figure |
| --- | ---: | ---: | ---: | ---: | ---: |
| 2.400 GHz | -9.88 dB | 18.36 dB | -6.27 dB | 1.719 | 0.831 dB |
| 2.425 GHz | -12.14 dB | 19.13 dB | -10.85 dB | 1.708 | 0.834 dB |
| 2.450 GHz | -13.30 dB | 19.42 dB | -21.46 dB | 1.699 | 0.837 dB |

## Process-Corner Summary

TT, SS, FF, SF, and FS were evaluated at 27 C.

- In-band gain: approximately 16.64-20.40 dB
- Minimum in-band K: approximately 1.49
- Wideband minimum K: 1.679 at 2.570 GHz over 100 MHz-10 GHz
- Preliminary input P1dB at 2.425 GHz: approximately -24.69 dBm
- Preliminary output P1dB at 2.425 GHz: approximately -6.51 dBm
- The fundamental-power result agrees with the total-RMS result within 0.024 dB.
- Delta magnitude remains below unity at all evaluated corners.
- Worst S11: approximately -8.82 dB
- Worst S22: approximately -5.35 dB
- Matching does not remain below -10 dB at every corner and band edge.

## Figures

- [Nominal S-parameters](testbenches/xschem/plot_simulations/figures/lna_package_sparameters.png)
- [Process corners](testbenches/xschem/plot_simulations/figures/lna_package_process_corners.png)
- [Noise figure](testbenches/xschem/plot_simulations/figures/lna_package_noise_figure.png)

## Reproduction

Run from `macros/lna` inside IIC-OSIC-TOOLS:

- `make sim-xschem TB=lna_tb_dc_bias`
- `make sim-xschem TB=lna_tb_sp`
- `make sim-xschem TB=lna_tb_sp_package`
- `make sim-xschem TB=lna_tb_noise_package`
- `python3 testbenches/xschem/plot_simulations/plot_lna_rf.py`

## Limitations

The matching components are ideal. Pad and bond-wire values are preliminary assumptions. Temperature, statistical mismatch, linearity, compression, layout, extraction, DRC, LVS, and post-layout verification remain future work. Unconditional stability is established from 100 MHz to 10 GHz at nominal TT and 27 C. This must be rechecked after layout and parasitic extraction.
