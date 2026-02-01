# Copyright (c) 2025 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# OpenSTA script template 
#
# Last Modification: 19.02.2025    

# Read library files
set PDK_ROOT $env(PDK_ROOT)
set PDK $env(PDK)

set lib_dir ${PDK_ROOT}/${PDK}/libs.ref/sky130_fd_sc_hd
read_liberty ${lib_dir}/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

# Load netlist
# Student Task 12: Modify the path to the output netlist
read_verilog "./synth/rgb_mixer_gl.v"
link_design rgb_mixer

# Set constraints
create_clock -name clk_sys -period 10 [get_ports clk]

# Generate timing report
report_checks -path_group clk_sys -path_delay max > "./sta.rpt"

exit

