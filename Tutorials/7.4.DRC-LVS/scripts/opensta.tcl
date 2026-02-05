# Read library files
set PDK_ROOT $env(PDK_ROOT)
set PDK $env(PDK)

set lib_dir ${PDK_ROOT}/${PDK}/libs.ref/sky130_fd_sc_hd
read_liberty ${lib_dir}/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

# Load netlist
read_verilog "./results/rgb_mixer_sky130hd-tcl.v"
link_design rgb_mixer

source "./results/rgb_mixer_sky130hd-tcl.sdc"

report_checks -sort_by_slack -path_delay max -fields {slew cap input net fanout} -format full_clock_expanded -group_path_count 1000 > "./max_sta.rpt"
report_checks -sort_by_slack -path_delay min -fields {slew cap input net fanout} -format full_clock_expanded -group_path_count 1000 > "./min_sta.rpt"
report_checks -unconstrained -fields {slew cap input net fanout} -format full_clock_expanded > "./unc_sta.rpt"
report_checks -slack_max -0.01 -fields {slew cap input net fanout} -format full_clock_expanded > "./slack_sta.rpt"
report_check_types -max_slew -max_capacitance -max_fanout -violators > "./vio_sta.rpt"
report_parasitic_annotation -report_unannotated > "./para_sta.rpt"
check_setup -verbose -unconstrained_endpoints -multiple_clock -no_clock -no_input_delay -loops -generated_clocks > "./setup_sta.rpt"

exit
