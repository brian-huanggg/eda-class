# Yosys 合成腳本（Tcl 格式）：RTL -> sky130 標準元件 netlist
# 在 Tcl 模式下，每個 Yosys 指令都要加上前綴 "yosys"
# 用法（容器內）：make synth W=16
set lib $::env(LIB)                  ;# 標準元件庫（.lib），由 Makefile 傳入
set w   $::env(W)                    ;# 位寬，由 Makefile 傳入

yosys read_verilog adder.v
yosys chparam -set W $w adder        ;# 覆寫 parameter W，不用改 Verilog
yosys hierarchy -check -top adder    ;# 指定頂層模組
yosys synth -top adder -flatten      ;# 通用合成：RTL -> 通用邏輯閘
yosys dfflibmap -liberty $lib        ;# 正反器對應到工藝庫（本例沒有，之後計數器會用到）
yosys abc -liberty $lib              ;# 組合邏輯對應到 sky130 實際 cell（technology mapping）
yosys opt_clean -purge               ;# 清掉沒用到的線
yosys tee -o synth_stat_w$w.rpt stat -liberty $lib   ;# 報告：cell 種類、數量、面積
yosys write_verilog -noattr adder_netlist_w$w.v
