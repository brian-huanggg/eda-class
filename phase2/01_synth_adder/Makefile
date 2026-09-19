# 需在 IIC-OSIC-TOOLS 容器內執行
LIB = $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
W  ?= 8
export LIB W

all: synth

synth: adder.v synth.tcl
	yosys -q -c synth.tcl
	cat synth_stat_w$(W).rpt

# 一次比較多種位寬，只印總 cell 數與面積
sweep:
	@for w in 4 8 16 32; do \
	  $(MAKE) -s synth W=$$w >/dev/null; \
	  echo "W=$$w: $$(grep -E ' cells$$' synth_stat_w$$w.rpt)"; \
	done

clean:
	rm -f adder_netlist*.v synth_stat*.rpt
