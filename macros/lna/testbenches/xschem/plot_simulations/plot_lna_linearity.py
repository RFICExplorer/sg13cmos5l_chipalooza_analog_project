# -*- coding: utf-8 -*-
"""Generate package-level P1dB and IIP3 review plots."""

from pathlib import Path

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np

ROOT = Path(__file__).resolve().parent
DATA = ROOT / "data"
FIGURES = ROOT / "figures"
FIGURES.mkdir(parents=True, exist_ok=True)

p1 = np.genfromtxt(DATA / "lna_p1db_package.csv", delimiter=",", names=True)
iip3 = np.genfromtxt(DATA / "lna_iip3_package_low_power.csv", delimiter=",", names=True)

input_p1db = -24.6884
output_p1db = -6.5108
small_signal_gain = 19.1540
input_iip3 = -11.8412
output_iip3 = 7.2880

fig, axes = plt.subplots(1, 2, figsize=(13.2, 5.4))

ax = axes[0]
ax.plot(p1["pin_dbm"], p1["pout_dbm"], "o-", lw=2, ms=4, label="Simulated output")
ax.plot(p1["pin_dbm"], p1["pin_dbm"] + small_signal_gain, "--", lw=1.8, label="Linear extrapolation")
ax.scatter([input_p1db], [output_p1db], s=70, marker="*", zorder=5, label="P1dB")
ax.axvline(input_p1db, color="0.5", ls=":", lw=1)
ax.axhline(output_p1db, color="0.5", ls=":", lw=1)
ax.set_title("Package-Level 1 dB Compression")
ax.set_xlabel("Input power (dBm)")
ax.set_ylabel("Output power (dBm)")
ax.grid(True, alpha=0.3)
ax.legend()
ax.annotate(
    f"Input P1dB = {input_p1db:.2f} dBm\nOutput P1dB = {output_p1db:.2f} dBm",
    xy=(input_p1db, output_p1db), xytext=(-37, -2),
    arrowprops={"arrowstyle": "->"}, fontsize=9,
)

ax = axes[1]
pin = iip3["pin_per_tone_dbm"]
fund = iip3["fund_avg_dbm"]
im3 = iip3["im3_avg_dbm"]
fund_fit = np.array([1.0, np.mean(fund - pin)])
im3_fit = np.array([3.0, np.mean(im3 - 3.0 * pin)])
x = np.linspace(pin.min() - 1, input_iip3 + 2, 200)
ax.plot(pin, fund, "o", ms=6, label="Fundamental data")
ax.plot(pin, im3, "s", ms=6, label="IM3 data")
ax.plot(x, np.polyval(fund_fit, x), "-", lw=2, label="Fundamental extrapolation (1 dB/dB)")
ax.plot(x, np.polyval(im3_fit, x), "-", lw=2, label="IM3 extrapolation (3 dB/dB)")
ax.scatter([input_iip3], [output_iip3], s=70, marker="*", zorder=5, label="IP3 estimate")
ax.set_title("Package-Level Two-Tone Intermodulation")
ax.set_xlabel("Input power per tone (dBm)")
ax.set_ylabel("Output power (dBm)")
ax.grid(True, alpha=0.3)
ax.legend(fontsize=8)
ax.annotate(
    f"IIP3 = {input_iip3:.2f} dBm\nOIP3 = {output_iip3:.2f} dBm",
    xy=(input_iip3, output_iip3), xytext=(-31, -4),
    arrowprops={"arrowstyle": "->"}, fontsize=9,
)

fig.suptitle("IHP SG13CMOS5L LNA Preliminary Linearity at 2.425 GHz", fontsize=14)
fig.tight_layout()
out = FIGURES / "lna_package_linearity.png"
fig.savefig(out, dpi=180, bbox_inches="tight")
print(out)
