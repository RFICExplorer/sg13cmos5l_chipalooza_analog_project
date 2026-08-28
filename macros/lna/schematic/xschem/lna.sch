v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}

T {2.4 GHz Cascode LNA - Initial IHP Schematic} 500 -1100 0 0 0.6 0.6 {}

N 820 -980 820 -950 {lab=VDD}
N 820 -890 820 -850 {lab=Vout}
N 820 -850 940 -850 {lab=Vout}

N 820 -790 820 -730 {lab=cascode_node}

N 700 -700 710 -700 {lab=Vin}
N 770 -700 780 -700 {lab=gate_in}
N 700 -820 780 -820 {lab=Vbias}

N 820 -610 820 -580 {lab=GND}

N 820 -700 880 -700 {lab=GND}
N 820 -820 880 -820 {lab=GND}

C {devices/iopin.sym} 820 -980 3 0 {name=p1 lab=VDD}
C {devices/ipin.sym} 700 -700 0 0 {name=p2 lab=Vin}
C {devices/ipin.sym} 700 -820 0 0 {name=p3 lab=Vbias}
C {devices/iopin.sym} 940 -850 0 0 {name=p4 lab=Vout}
C {devices/iopin.sym} 820 -580 1 0 {name=p5 lab=GND}

C {devices/ind.sym} 820 -920 0 0 {
name=Lload
m=1
value=5n
footprint=1206
device=inductor
}

C {devices/ind.sym} 740 -700 1 0 {
name=Lg
m=1
value=12.1n
footprint=1206
device=inductor
}

C {devices/ind.sym} 820 -640 0 0 {
name=Ls
m=1
value=2.00n
footprint=1206
device=inductor
}

C {sg13_lv_rf_nmos.sym} 800 -700 0 0 {
name=M0
l=0.13u
w=20u
ng=10
m=10
rfmode=1
mm_ok=1
model=sg13_lv_nmos
spiceprefix=X
}

C {sg13_lv_rf_nmos.sym} 800 -820 0 0 {
name=M1
l=0.13u
w=20u
ng=10
m=10
rfmode=1
mm_ok=1
model=sg13_lv_nmos
spiceprefix=X
}

C {lab_pin.sym} 880 -700 0 1 {name=p6 sig_type=std_logic lab=GND}
C {lab_pin.sym} 880 -820 0 1 {name=p7 sig_type=std_logic lab=GND}

C {annotate_fet_params.sym} 1040 -700 0 0 {name=annot0 ref=M0}
C {annotate_fet_params.sym} 1040 -820 0 0 {name=annot1 ref=M1}
