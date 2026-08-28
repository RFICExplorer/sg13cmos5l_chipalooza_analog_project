v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}

T {Cascode LNA AC Gain - Initial RF Test} 480 -1150 0 0 0.6 0.6 {}

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
value="dc 0.60 ac 1"
}
C {lab_pin.sym} 700 -830 1 0 {name=p6 sig_type=std_logic lab=Vin}
C {devices/gnd.sym} 700 -770 0 0 {name=g3 lab=GND}

C {devices/vsource.sym} 700 -700 0 0 {
name=VBIAS_SRC
value=1.00
}
C {lab_pin.sym} 700 -730 1 0 {name=p7 sig_type=std_logic lab=Vbias}
C {devices/gnd.sym} 700 -670 0 0 {name=g4 lab=GND}

C {capa.sym} 1200 -850 0 0 {
name=COUT
m=1
value=10p
footprint=1206
device="ceramic capacitor"
}
C {lab_pin.sym} 1200 -880 1 0 {name=p8 sig_type=std_logic lab=Vout}
C {lab_pin.sym} 1200 -820 3 0 {name=p9 sig_type=std_logic lab=Vload}

C {res.sym} 1200 -730 0 0 {
name=RLOAD
value=50
footprint=1206
device=resistor
m=1
}
C {lab_pin.sym} 1200 -760 1 0 {name=p10 sig_type=std_logic lab=Vload}
C {devices/gnd.sym} 1200 -700 0 0 {name=g5 lab=GND}

C {devices/code_shown.sym} 1450 -1000 0 0 {
name=MODEL
only_toplevel=true
value="
.lib cornerMOSlv.lib mos_tt
.include lna_tb_ac_gain.save
"}

C {devices/code_shown.sym} 1450 -750 0 0 {
name=NGSPICE
only_toplevel=true
value="
.temp 27
.options savecurrents klu reltol=1e-5 abstol=1e-15 gmin=1e-15

.control
save all
op
ac dec 200 100Meg 10G

echo ===== INITIAL_RF_GAIN =====
meas ac gain_db_2p40G find vdb(Vload) at=2.40G
meas ac gain_db_2p45G find vdb(Vload) at=2.45G
meas ac gain_peak_db max vdb(Vload)
meas ac gain_peak_freq when vdb(Vload)=gain_peak_db

set wr_singlescale
set wr_vecnames
wrdata ../plot_simulations/data/lna_ac_gain.dat frequency vdb(Vload) vp(Vload)

write lna_tb_ac_gain.raw
quit
.endc
"}
