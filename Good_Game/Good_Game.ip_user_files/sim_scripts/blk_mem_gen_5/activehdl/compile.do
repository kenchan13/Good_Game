vlib work
vlib activehdl

vlib activehdl/blk_mem_gen_v8_3_6
vlib activehdl/xil_defaultlib

vmap blk_mem_gen_v8_3_6 activehdl/blk_mem_gen_v8_3_6
vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work blk_mem_gen_v8_3_6  -v2k5 \
"../../../ipstatic/simulation/blk_mem_gen_v8_3.v" \

vlog -work xil_defaultlib  -v2k5 \
"../../../../Good_Game.srcs/sources_1/ip/blk_mem_gen_5/sim/blk_mem_gen_5.v" \


vlog -work xil_defaultlib \
"glbl.v"

