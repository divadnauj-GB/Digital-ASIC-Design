
set PDK_ROOT $env(PDK_ROOT)
set PDK $env(PDK)

set std_cells_lib $PDK_ROOT/$PDK/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
set constr_file yosys_abc.constr
set abc_script_file abc-opt.script
set synth_output rgb_mixer_gl.v


yosys read_liberty -lib ${std_cells_lib} 


yosys read_verilog src/debounce.v
yosys read_verilog src/edge_detector.v
yosys read_verilog src/PWM.v
yosys read_verilog src/up_down_counter.v
yosys read_verilog src/rgb_mixer.v

yosys hierarchy -check -top rgb_mixer

yosys flatten

yosys proc

yosys fsm

yosys wreduce

yosys peepopt

yosys share

yosys opt -noff

yosys memory

yosys opt_dff

yosys techmap

set period_ps 10000

yosys dfflibmap -liberty ${std_cells_lib}  

yosys abc -liberty ${std_cells_lib}  -D ${period_ps} -constr yosys/${constr_file} -script yosys/${abc_script_file}

yosys stat -liberty ${std_cells_lib} 

yosys splitnets
yosys setundef -zero
yosys hilomap

yosys write_verilog -noattr -simple-lhs synth/${synth_output}

exit