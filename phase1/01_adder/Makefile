TOP = adder
SRC = $(TOP).v
TB  = $(TOP)_tb.v

all: sim

sim: $(TOP).vvp
	vvp $(TOP).vvp

$(TOP).vvp: $(SRC) $(TB)
	iverilog -g2012 -Wall -o $@ $(TB) $(SRC)

wave: sim
	gtkwave $(TOP).vcd &

clean:
	rm -f *.vvp *.vcd
