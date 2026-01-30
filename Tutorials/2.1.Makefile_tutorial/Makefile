
all: test_pwm test_debounce  test_edge_detector test_up_down_counter test_rgb_mixer

test_pwm: 
	rm -rf sim_build/; mkdir sim_build/
	iverilog -o sim_build/tb_PWM.vvp -s tb_PWM src/PWM.v tb/tb_PWM.v 
	./sim_build/tb_PWM.vvp
	! grep failure results.xml

test_debounce: 
	rm -rf sim_build/; mkdir sim_build/
	iverilog -o sim_build/tb_debounce.vvp -s tb_debounce src/debounce.v tb/tb_debounce.v 
	./sim_build/tb_debounce.vvp
	! grep failure results.xml

test_edge_detector: 
	rm -rf sim_build/; mkdir sim_build/
	iverilog -o sim_build/tb_edge_detector.vvp -s tb_edge_detector src/edge_detector.v tb/tb_edge_detector.v 
	./sim_build/tb_edge_detector.vvp
	! grep failure results.xml

test_up_down_counter: 
	rm -rf sim_build/; mkdir sim_build/
	iverilog -o sim_build/tb_up_down_counter.vvp -s tb_up_down_counter src/up_down_counter.v tb/tb_up_down_counter.v 
	./sim_build/tb_up_down_counter.vvp
	! grep failure results.xml

test_rgb_mixer: 
	rm -rf sim_build/; mkdir sim_build/
	iverilog -o sim_build/tb_rgb_mixer.vvp -s tb_rgb_mixer src/*.v tb/tb_rgb_mixer.v 
	./sim_build/tb_rgb_mixer.vvp
	! grep failure results.xml


test_pwm_: 
	rm -rf obj_dir/
	verilator --trace --timing --binary -Wno-moddup -Wno-fatal src/PWM.v tb/tb_PWM.v -top-module tb_PWM
	./obj_dir/Vtb_PWM
	! grep failure results.xml

test_debounce_: 
	rm -rf obj_dir/
	verilator --trace --timing --binary -Wno-moddup -Wno-fatal src/debounce.v tb/tb_debounce.v -top-module tb_debounce
	./obj_dir/Vtb_debounce
	! grep failure results.xml

test_edge_detector_: 
	rm -rf obj_dir/
	verilator --trace --timing --binary -Wno-moddup -Wno-fatal  src/edge_detector.v tb/tb_edge_detector.v -top-module tb_edge_detector
	./obj_dir/Vtb_edge_detector
	! grep failure results.xml

test_up_down_counter_: 
	rm -rf obj_dir/
	verilator --trace --timing --binary -Wno-moddup -Wno-fatal  src/up_down_counter.v tb/tb_up_down_counter.v -top-module tb_up_down_counter
	./obj_dir/Vtb_up_down_counter
	! grep failure results.xml


test_rgb_mixer_: 
	rm -rf obj_dir/
	verilator --trace --timing --binary -Wno-moddup -Wno-fatal  src/*.v tb/tb_rgb_mixer.v -top-module tb_rgb_mixer
	./obj_dir/Vtb_rgb_mixer
	! grep failure results.xml

show_%: %.vcd tb/%.gtkw
	gtkwave $^

clean: 
	rm *vcd -rf sim_build