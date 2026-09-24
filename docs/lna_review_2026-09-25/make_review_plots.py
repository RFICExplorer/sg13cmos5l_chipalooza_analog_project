#!/usr/bin/env python3
from pathlib import Path
import csv
import matplotlib.pyplot as plt

HERE = Path(__file__).resolve().parent
DATA = HERE / "data"
FIG = HERE / "figures"
FIG.mkdir(exist_ok=True)

with (DATA / "current_stabilized_pvt.csv").open() as f:
    pvt = list(csv.DictReader(f))

corners = ["mos_tt", "mos_ss", "mos_ff", "mos_sf", "mos_fs"]
temps = [-20, 27, 85]
colors = {"mos_tt": "#1f77b4", "mos_ss": "#ff7f0e", "mos_ff": "#2ca02c", "mos_sf": "#d62728", "mos_fs": "#9467bd"}

fig, axes = plt.subplots(1, 2, figsize=(11, 4.4), constrained_layout=True)
for corner in corners:
    rows = sorted((r for r in pvt if r["corner"] == corner), key=lambda r: float(r["temp_c"]))
    axes[0].plot([float(r["temp_c"]) for r in rows], [float(r["target_vgin_v"]) for r in rows], marker="o", label=corner.replace("mos_", "").upper(), color=colors[corner])
    axes[1].plot([float(r["temp_c"]) for r in rows], [float(r["min_s21_ism_db"]) for r in rows], marker="o", label=corner.replace("mos_", "").upper(), color=colors[corner])

axes[0].set(title="Gate Bias Required for ~2 mA", xlabel="Temperature (°C)", ylabel="Adjusted gate bias (V)")
axes[1].set(title="Minimum In-Band Gain After Bias Adjustment", xlabel="Temperature (°C)", ylabel="Minimum S21 (dB)")
for ax in axes:
    ax.grid(True, alpha=0.3)
axes[1].legend(ncol=3, fontsize=8)
fig.suptitle("Exploratory Current-Stabilized PVT Study")
fig.savefig(FIG / "current_stabilized_pvt_summary.png", dpi=200)
plt.close(fig)

with (DATA / "finite_q_sensitivity_summary.csv").open() as f:
    fq = list(csv.DictReader(f))

labels = ["Ideal ref.", "Q15 Lg only", "Q15 Lload only", "Q15 Ls only", "Q15 all", "Q10 all"]
gain = [float(r["S21_2p425_db"]) for r in fq]
colors_bar = ["#4c78a8", "#72b7b2", "#f58518", "#54a24b", "#e45756", "#b279a2"]
fig, ax = plt.subplots(figsize=(10.5, 4.8), constrained_layout=True)
bars = ax.bar(labels, gain, color=colors_bar)
ax.bar_label(bars, fmt="%.2f dB", padding=3, fontsize=9)
ax.set(title="Exploratory Inductor-Loss Sensitivity at 2.425 GHz", ylabel="S21 (dB)", ylim=(0, max(gain) + 2.5))
ax.grid(axis="y", alpha=0.3)
ax.tick_params(axis="x", rotation=20)
ax.text(0.01, 0.98, "Series-R model only; not EM-extracted", transform=ax.transAxes, va="top", fontsize=9)
fig.savefig(FIG / "finite_q_gain_sensitivity.png", dpi=200)
plt.close(fig)
