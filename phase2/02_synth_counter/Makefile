# 需在 IIC-OSIC-TOOLS 容器內執行
LIB = $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
W  ?= 4
export LIB W

all: synth

synth: counter.v synth.tcl
	yosys -q -c synth.tcl
	cat synth_stat_w$(W).rpt

clean:
	rm -f counter_netlist*.v synth_stat*.rpt
