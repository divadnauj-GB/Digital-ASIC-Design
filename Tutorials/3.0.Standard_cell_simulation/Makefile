all: sim

show_cells:
	klayout  -l standard-cell.lyp $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/gds/sky130_fd_sc_hd.gds

sim: simulation.spice
	# run the simulation
	ngspice $^
