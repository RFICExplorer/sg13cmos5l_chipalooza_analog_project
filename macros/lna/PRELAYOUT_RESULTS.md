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
## Temperature Summary

TT was evaluated at -40 C, 27 C, and 125 C.

- In-band gain: approximately 17.67-19.36 dB
- Minimum in-band K: approximately 1.52
- K remains above unity and Delta magnitude remains below unity at all evaluated temperatures.
- Worst S11: approximately -9.76 dB
- Worst S22: approximately -5.51 dB
- Matching does not remain below -10 dB at every temperature and band edge.

## Wideband Stability Summary

- Wideband minimum K: 1.679 at 2.570 GHz over 100 MHz-10 GHz
## Nominal Linearity Summary

- Preliminary input P1dB at 2.425 GHz: approximately -24.69 dBm
- Preliminary output P1dB at 2.425 GHz: approximately -6.51 dBm
- Preliminary two-tone IIP3 at 2.420 and 2.430 GHz: approximately -11.84 dBm per tone
- Preliminary OIP3: approximately +7.29 dBm
- Low-power fundamental slopes are approximately 0.998-0.999 dB/dB, while IM3 slopes are approximately 3.11-3.19 dB/dB.
- The fundamental-power result agrees with the total-RMS result within 0.024 dB.
- Delta magnitude remains below unity at all evaluated corners.
- Worst S11: approximately -8.82 dB
- Worst S22: approximately -5.35 dB
- Matching does not remain below -10 dB at every corner and band edge.

## Figures

- [Nominal S-parameters](testbenches/xschem/plot_simulations/figures/lna_package_sparameters.png)
- [Process corners](testbenches/xschem/plot_simulations/figures/lna_package_process_corners.png)
- [Noise figure](testbenches/xschem/plot_simulations/figures/lna_package_noise_figure.png)
- [P1dB and IIP3](testbenches/xschem/plot_simulations/figures/lna_package_linearity.png)

## Reproduction

Run from `macros/lna` inside IIC-OSIC-TOOLS:

- `make sim-xschem TB=lna_tb_dc_bias`
- `make sim-xschem TB=lna_tb_sp`
- `make sim-xschem TB=lna_tb_sp_package`
- `make sim-xschem TB=lna_tb_noise_package`
- `make sim-xschem TB=lna_tb_sp_package_corner`
- `make sim-xschem TB=lna_tb_sp_package_temperature`
- `make sim-xschem TB=lna_tb_sp_package_wide_stability`
- `make sim-xschem TB=lna_tb_p1db_package`
- `make sim-xschem TB=lna_tb_iip3_package`
- `python3 testbenches/xschem/plot_simulations/plot_lna_rf.py`
- `python3 testbenches/xschem/plot_simulations/plot_lna_linearity.py`

## Limitations

The matching components are ideal, and the pad and bond-wire values are preliminary assumptions. Process corners were evaluated at 27 C, while temperature and linearity were evaluated at nominal TT; a combined PVT and linearity-corner campaign has not yet been performed. Statistical mismatch, realistic passive-device models, layout, extraction, DRC, LVS, and post-layout verification remain future work. Unconditional stability is established from 100 MHz to 10 GHz at nominal TT and 27 C and must be rechecked after layout and parasitic extraction.
