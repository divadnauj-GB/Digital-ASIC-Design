NAME=mosfet

all: sim

magic:
	# for rcfile to work PDK_ROOT must be set correctly
	magic -rcfile $(PDK_ROOT)/sky130A/libs.tech/magic/sky130A.magicrc $(NAME).mag

mosfet.spice: $(NAME).mag
	magic -noconsole -dnull extract.tcl mosfet

sim: $(NAME).spice
	# run the simulation
	ngspice simulation.spice

clean:
	rm -f $(NAME).spice $(NAME).ext

phony: clean
