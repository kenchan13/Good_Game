vlib work
vlib activehdl

vlib activehdl/xil_defaultlib

vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work xil_defaultlib  -v2k5 \
"../../../../Good_Game.srcs/sources_1/ip/KeyboardCtrl_0/src/Ps2Interface.v" \
"../../../../Good_Game.srcs/sources_1/ip/KeyboardCtrl_0/src/KeyboardCtrl.v" \
"../../../../Good_Game.srcs/sources_1/ip/KeyboardCtrl_0/sim/KeyboardCtrl_0.v" \


vlog -work xil_defaultlib \
"glbl.v"

