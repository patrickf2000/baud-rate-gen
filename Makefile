# The files
FILES		= src/transmitter.vhdl \
                src/baud_rate.vhdl \
                src/fifo.vhdl
SIMDIR		= sim
SIMFILES	= test/transmitter_tb.vhdl \
                test/baud_rate_tb.vhdl \
                test/fifo_tb.vhdl

# GHDL
GHDL_CMD	= ghdl
GHDL_FLAGS	= --ieee=synopsys --warn-no-vital-generic
GHDL_WORKDIR = --workdir=sim --work=work
GHDL_STOP	= --stop-time=5000ns

# For visualization
VIEW_CMD        = /usr/bin/gtkwave

# The commands
all:
	make compile
	make run

compile:
	mkdir -p sim
	ghdl -a $(GHDL_FLAGS) $(GHDL_WORKDIR) $(FILES)
	ghdl -a $(GHDL_FLAGS) $(GHDL_WORKDIR) $(SIMFILES)
	ghdl -e -o sim/transmitter_tb $(GHDL_FLAGS) $(GHDL_WORKDIR) transmitter_tb
	ghdl -e -o sim/baud_rate_tb $(GHDL_FLAGS) $(GHDL_WORKDIR) baud_rate_tb
	ghdl -e -o sim/fifo_tb $(GHDL_FLAGS) $(GHDL_WORKDIR) fifo_tb

run:
	cd sim; \
	ghdl -r $(GHDL_FLAGS) transmitter_tb $(GHDL_STOP) --wave=wave.ghw; \
	ghdl -r $(GHDL_FLAGS) baud_rate_tb $(GHDL_STOP) --wave=wave2.ghw; \
	ghdl -r $(GHDL_FLAGS) fifo_tb --stop-time=500ns --wave=wave3.ghw; \
	cd ..

view:
	gtkwave sim/wave3.ghw

clean:
	$(GHDL_CMD) --clean --workdir=sim
