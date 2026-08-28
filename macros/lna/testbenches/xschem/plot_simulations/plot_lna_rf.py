# -*- coding: utf-8 -*-
"""Generate review plots for the IHP SG13CMOS5L 2.4 GHz LNA."""

from pathlib import Path

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np


SCRIPT_DIR = Path(__file__).resolve().parent
DATA_DIR = SCRIPT_DIR / "data"
FIGURES_DIR = SCRIPT_DIR / "figures"
FIGURES_DIR.mkdir(parents=True, exist_ok=True)

CORNERS = {
    "TT": "mos_tt",
    "SS": "mos_ss",
    "FF": "mos_ff",
    "SF": "mos_sf",
    "FS": "mos_fs",
}

COLORS = {
    "TT": "#0c5da5",
    "SS": "#ff9500",
    "FF": "#00a651",
    "SF": "#845ec2",
    "FS": "#d62728",
}


def load_sp(path):
    data = np.loadtxt(path, skiprows=1)
    return {
        "frequency": data[:, 0] / 1e9,
        "s11": data[:, 3],
        "s21": data[:, 4],
        "s12": data[:, 5],
        "s22": data[:, 6],
        "k": data[:, 7],
    }


def load_noise(path):
    data = np.loadtxt(path, skiprows=1)
    return {
        "frequency": data[:, 0] / 1e9,
        "nf": data[:, 2],
    }


def format_axis(axis, ylabel, threshold=None):
    axis.axvspan(2.40, 2.45, color="#d9edf7", alpha=0.45)
    axis.axvline(2.40, color="#555555", linestyle=":", linewidth=1)
    axis.axvline(2.45, color="#555555", linestyle=":", linewidth=1)
    if threshold is not None:
        axis.axhline(threshold, color="#333333", linestyle="--", linewidth=1.2)
    axis.set_xlim(2.30, 2.55)
    axis.set_xlabel("Frequency (GHz)")
    axis.set_ylabel(ylabel)
    axis.grid(True, linestyle="--", alpha=0.4)


plt.rcParams.update({
    "font.family": "serif",
    "font.size": 11,
    "figure.dpi": 140,
    "savefig.dpi": 220,
    "savefig.bbox": "tight",
})

nominal = load_sp(DATA_DIR / "lna_sp_package.dat")

figure, axes = plt.subplots(2, 1, figsize=(9, 8), sharex=True)

axes[0].plot(
    nominal["frequency"], nominal["s21"],
    label="$S_{21}$", linewidth=2.2, color="#0c5da5"
)
axes[0].plot(
    nominal["frequency"], nominal["s12"],
    label="$S_{12}$", linewidth=2.0, color="#d62728"
)
format_axis(axes[0], "Transmission (dB)")
axes[0].legend()

axes[1].plot(
    nominal["frequency"], nominal["s11"],
    label="$S_{11}$", linewidth=2.2, color="#00a651"
)
axes[1].plot(
    nominal["frequency"], nominal["s22"],
    label="$S_{22}$", linewidth=2.2, color="#ff9500"
)
format_axis(axes[1], "Return loss (dB)", threshold=-10)
axes[1].legend()

figure.suptitle(
    "Nominal Package-Level LNA S-Parameters\n"
    "TT, 27 °C, 2.5 nH Bond Wires, 200 fF Pad Capacitance"
)
figure.tight_layout()
figure.savefig(FIGURES_DIR / "lna_package_sparameters.png")
plt.close(figure)

corner_data = {
    label: load_sp(DATA_DIR / f"lna_sp_package_{name}.dat")
    for label, name in CORNERS.items()
}

figure, axes = plt.subplots(2, 2, figsize=(12, 8), sharex=True)

for label, data in corner_data.items():
    color = COLORS[label]
    axes[0, 0].plot(data["frequency"], data["s11"], label=label, color=color)
    axes[0, 1].plot(data["frequency"], data["s21"], label=label, color=color)
    axes[1, 0].plot(data["frequency"], data["s22"], label=label, color=color)
    axes[1, 1].plot(data["frequency"], data["k"], label=label, color=color)

format_axis(axes[0, 0], "$S_{11}$ (dB)", threshold=-10)
format_axis(axes[0, 1], "$S_{21}$ (dB)")
format_axis(axes[1, 0], "$S_{22}$ (dB)", threshold=-10)
format_axis(axes[1, 1], "Rollet stability factor K", threshold=1)

axes[0, 0].legend(ncol=3, fontsize=9)
figure.suptitle(
    "Package-Level Process Corners at 27 °C\n"
    "2.5 nH Bond Wires and 200 fF Pad Capacitance"
)
figure.tight_layout()
figure.savefig(FIGURES_DIR / "lna_package_process_corners.png")
plt.close(figure)

noise = load_noise(DATA_DIR / "lna_noise_package.dat")

figure, axis = plt.subplots(figsize=(9, 5))
axis.plot(
    noise["frequency"], noise["nf"],
    linewidth=2.3, color="#845ec2", label="Noise figure"
)
format_axis(axis, "Noise figure (dB)")
axis.set_ylim(0, max(2.0, np.max(noise["nf"][
    (noise["frequency"] >= 2.30) & (noise["frequency"] <= 2.55)
]) * 1.25))
axis.legend()
axis.set_title(
    "Preliminary Package-Level LNA Noise Figure\n"
    "TT, 27 °C, 50 Ω Source"
)
figure.tight_layout()
figure.savefig(FIGURES_DIR / "lna_package_noise_figure.png")
plt.close(figure)

for figure_name in (
    "lna_package_sparameters.png",
    "lna_package_process_corners.png",
    "lna_package_noise_figure.png",
):
    print(FIGURES_DIR / figure_name)
