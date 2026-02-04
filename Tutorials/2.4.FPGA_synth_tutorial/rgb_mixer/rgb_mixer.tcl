project_new rgb_mixer -overwrite
set_global_assignment -name FAMILY "Cyclone II"
set_global_assignment -name DEVICE EP2C20F484C7
set_global_assignment -name TOP_LEVEL_ENTITY rgb_mixer
set_global_assignment -name VERILOG_FILE src/rgb_mixer.v
set_global_assignment -name VERILOG_FILE src/debounce.v
set_global_assignment -name VERILOG_FILE src/edge_detector.v
set_global_assignment -name VERILOG_FILE src/PWM.v
set_global_assignment -name VERILOG_FILE src/up_down_counter.v


source scripts/de1-pinmap.tcl
source scripts/options.tcl
set_global_assignment -name SDC_FILE scripts/de1.sdc