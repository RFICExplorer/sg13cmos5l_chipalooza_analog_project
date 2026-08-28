v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}

T {Cascode LNA DC Operating Point} 500 -1150 0 0 0.6 0.6 {}

C {lna.sym} 1000 -800 0 0 {name=x1}

C {lab_pin.sym} 1000 -880 1 0 {name=p1 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 940 -820 2 0 {name=p2 sig_type=std_logic lab=Vin}
C {lab_pin.sym} 940 -780 2 0 {name=p3 sig_type=std_logic lab=Vbias}
C {lab_pin.sym} 1060 -800 0 0 {name=p4 sig_type=std_logic lab=Vout}
C {devices/gnd.sym} 1000 -720 0 0 {name=g1 lab=GND}

C {devices/vsource.sym} 700 -900 0 0 {
name=VDD_SRC
value=1.2
}
C {lab_pin.sym} 700 -930 1 0 {name=p5 sig_type=std_logic lab=VDD}
C {devices/gnd.sym} 700 -870 0 0 {name=g2 lab=GND}

C {devices/vsource.sym} 700 -800 0 0 {
name=VIN_SRC
value=0.55
}
C {lab_pin.sym} 700 -830 1 0 {name=p6 sig_type=std_logic lab=Vin}
C {devices/gnd.sym} 700 -770 0 0 {name=g3 lab=GND}

C {devices/vsource.sym} 700 -700 0 0 {
name=VBIAS_SRC
value=0.85
}
C {lab_pin.sym} 700 -730 1 0 {name=p7 sig_type=std_logic lab=Vbias}
C {devices/gnd.sym} 700 -670 0 0 {name=g4 lab=GND}

C {devices/code_shown.sym} 1250 -1000 0 0 {
name=MODEL
only_toplevel=true
value="
.lib cornerMOSlv.lib mos_tt
.include lna_tb_dc_bias.save
"}

C {devices/code_shown.sym} 1250 -750 0 0 {
name=NGSPICE
only_toplevel=true
value="
.temp 27
.options savecurrents klu reltol=1e-5 abstol=1e-15 gmin=1e-15

.control
save all
dc VIN_SRC 0.45 0.75 0.025 VBIAS_SRC 0.70 1.05 0.05
let idd = -i(VDD_SRC)
let gm0 = @n.x1.xm0.nsg13_lv_nmos[gm]
let gm1 = @n.x1.xm1.nsg13_lv_nmos[gm]
let vds0 = @n.x1.xm0.nsg13_lv_nmos[vds]
let vds1 = @n.x1.xm1.nsg13_lv_nmos[vds]
set wr_singlescale
set wr_vecnames

echo

wrdata ../plot_simulations/data/lna_dc_sweep.dat v(Vin) v(Vbias) v(x1.net1) idd gm0 gm1 vds0 vds1
quit
.endc
"}
