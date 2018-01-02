onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L blk_mem_gen_v8_3_6 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -lib xil_defaultlib xil_defaultlib.blk_mem_gen_0_blank xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {blk_mem_gen_0_blank.udo}

run -all

quit -force
