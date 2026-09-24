# LNA Review Status — 2026-09-25

This folder separates reproducible/approved repository results from newer exploratory studies prepared for design review.

## Established repository results

The existing `lna-development` branch contains the current Xschem LNA schematic, package-level testbenches, reproducible P1dB and IIP3 sweep scripts, approved data, and plots for package-level S-parameters, noise figure, linearity, and process-corner behavior.

## Exploratory current-stabilized PVT study

The local current-stabilized PVT sweep adjusts the input-device gate voltage at each MOS corner and temperature to target approximately 2 mA. Across the 15 simulated cases:

- Required gate-bias range: 0.4525 V to 0.6350 V.
- Drain-current range after adjustment: 1.9739 mA to 2.0294 mA.
- Power range: 2.3687 mW to 2.4352 mW at 1.2 V.
- Minimum simulated in-band gain: 15.6368 dB.
- Minimum simulated in-band stability factor: 2.2946.

These results demonstrate the potential benefit of adjustable bias, but they do not yet include a verified harness `ibias`/`vbias` implementation.

## Exploratory finite-Q sensitivity study

Inductor loss was approximated by adding series resistance calculated at 2.425 GHz. This is a sensitivity model, not an EM-extracted inductor model.

- With Q = 15 applied to all three inductors, S21 decreased from approximately 16.19 dB to 11.50 dB.
- With Q = 10 applied to all three inductors, S21 decreased to approximately 9.59 dB.
- Q = 15 one-at-a-time tests identify the 5 nH load inductor as the dominant contributor: its loss alone reduced S21 to approximately 12.37 dB.
- Loss in the 12.1 nH gate inductor alone produced approximately 15.93 dB gain.
- Loss in the 2 nH source inductor alone produced approximately 16.34 dB gain.

The results should be repeated using the applicable SG13CMOS5L EM flow or characterized models before final component or layout decisions.

## Physical-layout status

The complete LNA physical layout is not yet available. Current physical-integration material is limited to the slot #12 wrapper, pin/boundary information, and preliminary inductor-area estimates. Device placement, RF routing, DRC, LVS, parasitic extraction, EM verification, and post-layout simulation remain open.

The file `scripts/sizing/figures/lna_circuit.pdf` is a sizing/inverter diagram and must not be presented as the current LNA schematic. The authoritative current circuit source is `schematic/xschem/lna.sch`.

## Information still requested from Tim

- Recommended SG13CMOS5L inductor EM procedure and applicable stackup/technology files.
- Recommended QFN and approximately 3 mm bond-wire electrical model.
- Required separation beyond the Magic-generated inductor keep-out, if any.
- Whether part of the RF matching network may be implemented off chip.
- `ibias` compliance voltage, accuracy, and expected PVT variation.
- Usable `vbias` voltage range and documented drive capability.
- Confirmation that the reset-related slot-wrapper revision has been pushed before final integration.

## Next objectives

1. Confirm the current harness/wrapper revision and freeze the interface.
2. Select a bias architecture compatible with the available `ibias`/`vbias` resources.
3. Obtain or establish the SG13CMOS5L EM and package/bond-wire modeling flow.
4. Re-optimize matching with realistic inductor, pad, bond-wire, and package parasitics.
5. Complete placement and routing, followed by DRC, LVS, PEX, EM verification, and post-layout simulations.
