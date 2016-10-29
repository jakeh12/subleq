top ?= ram_tb
time ?= 3000

all:
	ghdl --clean
	ghdl --remove
	rm -rf work *.o $(top)
	mkdir work
	ghdl -i --ieee=synopsys --workdir=work *.vhd
	ghdl -m --ieee=synopsys --workdir=work $(top)
	ghdl -r --ieee=synopsys --workdir=work $(top) --stop-time=$(time)ns --vcd=$(top).vcd
	ghdl --clean
	ghdl --remove
	rm -rf work *.o $(top)

clean:
	ghdl --clean
	ghdl --remove
	rm -rf work
	rm -f *.o

note:
	ghdl --clean
	ghdl --remove
	rm -rf work *.o $(top)
	mkdir work
	ghdl -i --ieee=synopsys --workdir=work *.vhd
	ghdl -m --ieee=synopsys --workdir=work $(top)
	ghdl -r --ieee=synopsys --workdir=work $(top) --assert-level=note --vcd=$(top).vcd
	ghdl --clean
	ghdl --remove
	rm -rf work *.o $(top)
