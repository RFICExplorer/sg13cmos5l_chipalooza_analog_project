v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}

T {Cascode LNA Two-Port S-Parameters} 450 -1200 0 0 0.6 0.6 {}

C {lna.sym} 1000 -800 0 0 {name=x1}
C {lab_pin.sym} 1000 -880 1 0 {name=p1 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 940 -820 2 0 {name=p2 sig_type=std_logic lab=Vin}
C {lab_pin.sym} 940 -780 2 0 {name=p3 sig_type=std_logic lab=Vbias}
C {lab_pin.sym} 1060 -800 0 0 {name=p4 sig_type=std_logic lab=Vout}
C {devices/gnd.sym} 1000 -720 0 0 {name=g1 lab=GND}

C {devices/vsource.sym} 650 -700 0 0 {
name=VDD_SRC
value=1.2
}
C {lab_pin.sym} 650 -730 1 0 {name=p5 sig_type=std_logic lab=VDD}
C {devices/gnd.sym} 650 -670 0 0 {name=g2 lab=GND}

C {devices/vsource.sym} 750 -700 0 0 {
name=VBIAS_SRC
value=1.00
}
C {lab_pin.sym} 750 -730 1 0 {name=p6 sig_type=std_logic lab=Vbias}
C {devices/gnd.sym} 750 -670 0 0 {name=g3 lab=GND}

C {devices/vsource.sym} 850 -700 0 0 {
name=VGIN_SRC
value=0.60
}
C {lab_pin.sym} 850 -730 1 0 {name=p7 sig_type=std_logic lab=VGIN}
C {devices/gnd.sym} 850 -670 0 0 {name=g4 lab=GND}

C {res.sym} 850 -820 0 0 {
name=RBIAS_IN
value=100k
footprint=1206
device=resistor
m=1
}
C {lab_pin.sym} 850 -850 1 0 {name=p8 sig_type=std_logic lab=VGIN}
C {lab_pin.sym} 850 -790 3 0 {name=p9 sig_type=std_logic lab=Vin}

C {capa.sym} 700 -950 0 0 {
name=CIN
m=1
value=10p
footprint=1206
device="ceramic capacitor"
}
C {lab_pin.sym} 700 -980 1 0 {name=p10 sig_type=std_logic lab=PORT1}
C {lab_pin.sym} 700 -920 3 0 {name=p11 sig_type=std_logic lab=Vin}

C {devices/ind.sym} 620 -1050 1 0 {
name=LMATCH_IN
m=1
value=0.91n
footprint=1206
device=inductor
}
C {lab_pin.sym} 590 -1050 2 0 {name=p17 sig_type=std_logic lab=PAD_IN}
C {lab_pin.sym} 650 -1050 0 0 {name=p18 sig_type=std_logic lab=PORT1}

C {capa.sym} 620 -850 0 0 {
name=CMATCH_IN
m=1
value=1.00p
footprint=1206
device="ceramic capacitor"
}
C {lab_pin.sym} 620 -880 1 0 {name=p19 sig_type=std_logic lab=PORT1}
C {devices/gnd.sym} 620 -820 0 0 {name=g8 lab=GND}

C {res.sym} 480 -1120 1 0 {
name=RBW_IN
value=0.15
footprint=1206
device=resistor
m=1
}
C {lab_pin.sym} 450 -1120 2 0 {name=p23 sig_type=std_logic lab=PKG_IN}
C {lab_pin.sym} 510 -1120 0 0 {name=p24 sig_type=std_logic lab=BW_IN_NODE}
C {devices/ind.sym} 580 -1120 1 0 {
name=LBW_IN
m=1
value=2.5n
footprint=1206
device=inductor
}
C {lab_pin.sym} 550 -1120 2 0 {name=p25 sig_type=std_logic lab=BW_IN_NODE}
C {lab_pin.sym} 610 -1120 0 0 {name=p26 sig_type=std_logic lab=PAD_IN}
C {capa.sym} 720 -850 0 0 {
name=CPAD_IN
m=1
value=200f
footprint=1206
device="pad capacitance"
}
C {lab_pin.sym} 720 -880 1 0 {name=p27 sig_type=std_logic lab=PAD_IN}
C {devices/gnd.sym} 720 -820 0 0 {name=g10 lab=GND}

C {res.sym} 430 -950 1 0 {
name=RSOURCE
value=50
footprint=1206
device=resistor
m=1
}
C {lab_pin.sym} 400 -950 2 0 {name=p33 sig_type=std_logic lab=SOURCE_NODE}
C {lab_pin.sym} 460 -950 0 0 {name=p34 sig_type=std_logic lab=PKG_IN}

C {devices/bsource.sym} 550 -950 0 0 {
name=BTWO_TONE
VAR=V
FUNC="'6.324555320e-03*sin(2*pi*2.420G*time)+6.324555320e-03*sin(2*pi*2.430G*time)'"
m=1
}
C {lab_pin.sym} 550 -980 1 0 {name=p12 sig_type=std_logic lab=SOURCE_NODE}
C {devices/gnd.sym} 550 -920 0 0 {name=g5 lab=GND}

C {capa.sym} 1200 -950 0 0 {
name=COUT
m=1
value=0.835p
footprint=1206
device="ceramic capacitor"
}
C {lab_pin.sym} 1200 -980 1 0 {name=p13 sig_type=std_logic lab=Vout}
C {lab_pin.sym} 1200 -920 3 0 {name=p14 sig_type=std_logic lab=OUT_MATCH_NODE}



C {capa.sym} 1250 -800 0 0 {
name=CMATCH_OUT
m=1
value=3.84p
footprint=1206
device="ceramic capacitor"
}
C {lab_pin.sym} 1250 -830 1 0 {name=p20 sig_type=std_logic lab=PAD_OUT}
C {devices/gnd.sym} 1250 -770 0 0 {name=g9 lab=GND}

C {res.sym} 1250 -1050 1 0 {
name=RMATCH_OUT
value=2.5
footprint=1206
device=resistor
m=1
}
C {lab_pin.sym} 1220 -1050 2 0 {name=p21 sig_type=std_logic lab=OUT_MATCH_NODE}
C {lab_pin.sym} 1280 -1050 0 0 {name=p22 sig_type=std_logic lab=PAD_OUT}

C {devices/ind.sym} 1390 -1120 1 0 {
name=LBW_OUT
m=1
value=2.5n
footprint=1206
device=inductor
}
C {lab_pin.sym} 1360 -1120 2 0 {name=p28 sig_type=std_logic lab=PAD_OUT}
C {lab_pin.sym} 1420 -1120 0 0 {name=p29 sig_type=std_logic lab=BW_OUT_NODE}
C {res.sym} 1490 -1120 1 0 {
name=RBW_OUT
value=0.15
footprint=1206
device=resistor
m=1
}
C {lab_pin.sym} 1460 -1120 2 0 {name=p30 sig_type=std_logic lab=BW_OUT_NODE}
C {lab_pin.sym} 1520 -1120 0 0 {name=p31 sig_type=std_logic lab=PKG_OUT}
C {capa.sym} 1320 -800 0 0 {
name=CPAD_OUT
m=1
value=200f
footprint=1206
device="pad capacitance"
}
C {lab_pin.sym} 1320 -830 1 0 {name=p32 sig_type=std_logic lab=PAD_OUT}
C {devices/gnd.sym} 1320 -770 0 0 {name=g11 lab=GND}

C {res.sym} 1350 -950 0 0 {
name=RLOAD
value="50 noisy=0"
}
C {lab_pin.sym} 1350 -980 1 0 {name=p15 sig_type=std_logic lab=PKG_OUT}
C {devices/gnd.sym} 1350 -920 0 0 {name=g6 lab=GND}

C {devices/code_shown.sym} 1550 -1050 0 0 {
name=MODEL
only_toplevel=true
format="tcleval( @value )"
value="
.lib $::MODELS_NGSPICE/cornerMOSlv.lib mos_tt
"}

C {devices/code_shown.sym} 1550 -750 0 0 {
name=NGSPICE
only_toplevel=true
value="
.temp 27
.options savecurrents klu reltol=1e-5 abstol=1e-15 gmin=1e-15

.control
save all
tran 5p 200n 100n 2p

let F1_I=v(PKG_OUT)*sin(2*pi*2.420G*time)
let F1_Q=v(PKG_OUT)*cos(2*pi*2.420G*time)
let F2_I=v(PKG_OUT)*sin(2*pi*2.430G*time)
let F2_Q=v(PKG_OUT)*cos(2*pi*2.430G*time)
let IM3L_I=v(PKG_OUT)*sin(2*pi*2.410G*time)
let IM3L_Q=v(PKG_OUT)*cos(2*pi*2.410G*time)
let IM3H_I=v(PKG_OUT)*sin(2*pi*2.440G*time)
let IM3H_Q=v(PKG_OUT)*cos(2*pi*2.440G*time)

meas tran F1_I_AVG avg F1_I from=100n to=200n
meas tran F1_Q_AVG avg F1_Q from=100n to=200n
meas tran F2_I_AVG avg F2_I from=100n to=200n
meas tran F2_Q_AVG avg F2_Q from=100n to=200n
meas tran IM3L_I_AVG avg IM3L_I from=100n to=200n
meas tran IM3L_Q_AVG avg IM3L_Q from=100n to=200n
meas tran IM3H_I_AVG avg IM3H_I from=100n to=200n
meas tran IM3H_Q_AVG avg IM3H_Q from=100n to=200n

let VF1_RMS=sqrt(2)*sqrt(F1_I_AVG^2+F1_Q_AVG^2)
let VF2_RMS=sqrt(2)*sqrt(F2_I_AVG^2+F2_Q_AVG^2)
let VIM3L_RMS=sqrt(2)*sqrt(IM3L_I_AVG^2+IM3L_Q_AVG^2)
let VIM3H_RMS=sqrt(2)*sqrt(IM3H_I_AVG^2+IM3H_Q_AVG^2)

let PF1_W=(VF1_RMS^2)/50
let PF2_W=(VF2_RMS^2)/50
let PIM3L_W=(VIM3L_RMS^2)/50
let PIM3H_W=(VIM3H_RMS^2)/50
let FUND_AVG_W=(PF1_W+PF2_W)/2
let IM3_AVG_W=(PIM3L_W+PIM3H_W)/2

let PF1_DBM=10*log10(PF1_W/1m)
let PF2_DBM=10*log10(PF2_W/1m)
let PIM3L_DBM=10*log10(PIM3L_W/1m)
let PIM3H_DBM=10*log10(PIM3H_W/1m)
let FUND_AVG_DBM=10*log10(FUND_AVG_W/1m)
let IM3_AVG_DBM=10*log10(IM3_AVG_W/1m)
let IIP3_DBM=-40+(FUND_AVG_DBM-IM3_AVG_DBM)/2
let OIP3_DBM=FUND_AVG_DBM+(FUND_AVG_DBM-IM3_AVG_DBM)/2

echo ===== PACKAGE_LNA_IIP3_SINGLE_POINT =====
echo PIN_PER_TONE_DBM = -40
print PF1_DBM PF2_DBM
print PIM3L_DBM PIM3H_DBM
print FUND_AVG_DBM IM3_AVG_DBM
print IIP3_DBM OIP3_DBM

quit
.endc
"}
