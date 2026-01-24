# defines bash as the default shell
SHELL := /bin/bash
# enables shell conditionals under the Make targets
.ONESHELL:

# Define the default simulator (e.g., icarus, ghdl, xcelium, etc.)
SIM ?= icarus
WAVES=1
# Define the top-level language (verilog or vhdl)
TOPLEVEL_LANG ?= verilog

ifeq ($(SIM),verilator)
EXTRA_ARGS+=--trace --trace-depth 0  --timing -Wno-moddup -Wno-fatal 
else
COMPILE_ARGS+=
endif
VERILOG_SOURCES := $(filter-out $(SIM_BUILD)/cocotb_iverilog_dump.v, $(VERILOG_SOURCES))
# Include the main cocotb Makefile that drives the simulation flow
include $(shell cocotb-config --makefiles)/Makefile.sim

all: test_my_design tes_pwm test_up_down_counter test_edge_detector test_debounce test_rgb_mixer

test_my_design: 
	rm -rf sim_build; mkdir -p sim_build
	TOPLEVEL=my_design VERILOG_SOURCES=src/my_design.v MODULE=tb.test_my_design $(MAKE) sim 
	if [ "$(SIM)" == "verilator" ]; then
		mv dump.vcd my_design.vcd
	else
		fst2vcd -f sim_build/my_design.fst -o my_design.vcd
	fi	

test_pwm: 
	rm -rf sim_build; mkdir -p sim_build
	TOPLEVEL=PWM VERILOG_SOURCES=src/PWM.v MODULE=tb.tb_PWM $(MAKE) sim	
	if [ "$(SIM)" == "verilator" ]; then
		mv dump.vcd PWM.vcd
	else
		fst2vcd -f sim_build/PWM.fst -o PWM.vcd
	fi	

test_up_down_counter: 
	rm -rf sim_build; mkdir -p sim_build
	TOPLEVEL=up_down_counter VERILOG_SOURCES=src/up_down_counter.v MODULE=tb.tb_up_down_counter $(MAKE) sim	
	if [ "$(SIM)" == "verilator" ]; then
		mv dump.vcd up_down_counter.vcd
	else
		fst2vcd -f sim_build/up_down_counter.fst -o up_down_counter.vcd
	fi	

test_edge_detector:
	rm -rf sim_build; mkdir -p sim_build
	TOPLEVEL=edge_detector VERILOG_SOURCES=src/edge_detector.v MODULE=tb.tb_edge_detector $(MAKE) sim
	if [ "$(SIM)" == "verilator" ]; then
		mv dump.vcd edge_detector.vcd
	else
		fst2vcd -f sim_build/edge_detector.fst -o edge_detector.vcd
	fi	

test_debounce:
	rm -rf sim_build; mkdir -p sim_build
	if [ "$(SIM)" == "verilator" ]; then
		TOPLEVEL=debounce VERILOG_SOURCES=src/debounce.v MODULE=tb.tb_debounce COMPILE_ARGS+="-GCLK_FREQ=500" \
		$(MAKE) sim	
		mv dump.vcd debounce.vcd
	else
		TOPLEVEL=debounce VERILOG_SOURCES=src/debounce.v MODULE=tb.tb_debounce COMPILE_ARGS+="-Pdebounce.CLK_FREQ=500" \
		$(MAKE) sim	
		fst2vcd -f sim_build/debounce.fst -o debounce.vcd
	fi


test_rgb_mixer:
	rm -rf sim_build; mkdir -p sim_build
	if [ "$(SIM)" == "verilator" ]; then
		TOPLEVEL=rgb_mixer VERILOG_SOURCES="src/rgb_mixer.v src/debounce.v src/up_down_counter.v src/PWM.v src/edge_detector.v" \
		MODULE=tb.tb_rgb_mixer COMPILE_ARGS+="-GDEBOUNCE_FREQ=1000000" \
		$(MAKE) sim	
		mv dump.vcd rgb_mixer.vcd
	else
		TOPLEVEL=rgb_mixer VERILOG_SOURCES="src/rgb_mixer.v src/debounce.v src/up_down_counter.v src/PWM.v src/edge_detector.v" \
		MODULE=tb.tb_rgb_mixer COMPILE_ARGS+="-Prgb_mixer.DEBOUNCE_FREQ=1000000" $(MAKE) sim	
		fst2vcd -f sim_build/rgb_mixer.fst -o rgb_mixer.vcd
	fi

show_%: %.vcd tb/%.gtkw
	gtkwave $^


clean::
	rm *vcd -rf sim_build *.xml