PDK_DIR = /foss/pdks/sky130A
STD_CELLS_LIB = $(PDK_DIR)/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v \
				$(PDK_DIR)/libs.ref/sky130_fd_sc_hd/verilog/primitives.v


all: clean yosys_synth test_rgb_mixer show_tb_rgb_mixer

yosys_synth: 
	rm -rf synth/; mkdir synth/
	yosys -c yosys/synthesis_yosys.tcl

test_rgb_mixer: 
	rm -rf sim_build/; mkdir sim_build/
	iverilog -o sim_build/tb_rgb_mixer.vvp -s tb_rgb_mixer synth/rgb_mixer_gl.v tb/tb_rgb_mixer.v $(STD_CELLS_LIB)
	./sim_build/tb_rgb_mixer.vvp

show_%: %.vcd %.gtkw
	gtkwave $^

clean: 
	rm *vcd -rf sim_build synth