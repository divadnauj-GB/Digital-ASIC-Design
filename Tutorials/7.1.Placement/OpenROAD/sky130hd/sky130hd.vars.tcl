# sky130 hd

set PDK_ROOT $env(PDK_ROOT)
set PDK_NAME $env(PDK)

set platform "sky130hd"
set tech_lef "${PDK_ROOT}/${PDK_NAME}/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef"
set std_cell_lef "${PDK_ROOT}/${PDK_NAME}/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef"
set extra_lef {}
set liberty_file "${PDK_ROOT}/${PDK_NAME}/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib"
# corner/filename
set liberty_files {
  "fast" "${PDK_ROOT}/${PDK_NAME}/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__ff_n40C_1v95.lib"
  "slow" "${PDK_ROOT}/${PDK_NAME}/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__ss_n40C_1v40.lib"
}
set extra_liberty {}
set site "unithd"
set pdn_cfg "OpenROAD/sky130hd/sky130hd.pdn.tcl"
set tracks_file "OpenROAD/sky130hd/sky130hd.tracks.tcl"
set io_placer_hor_layer met3
set io_placer_ver_layer met2
set tapcell_args "-distance 14 \
    -tapcell_master sky130_fd_sc_hd__tapvpwrvgnd_1"
set global_place_density 0.80
set utilization 50
# default value
set global_place_density_penalty 8e-5
# placement padding in SITE widths applied to both sides
set global_place_pad 4
set detail_place_pad 2

set pre_placed_macros_file ""
set macro_place_halo {1 1}

set layer_rc_file "OpenROAD/sky130hd/sky130hd.rc"
set wire_rc_layer met1
set wire_rc_layer_clk met3
set tielo_port "sky130_fd_sc_hd__conb_1/LO"
set tiehi_port "sky130_fd_sc_hd__conb_1/HI"
# tie hi/low instance to load separation (microns)
set tie_separation 2
set cts_buffer "sky130_fd_sc_hd__clkbuf_4"
set cts_cluster_diameter 100
set filler_cells "sky130_fd_sc_hd__fill_*"

# no access points for these cells
set dont_use {sky130_fd_sc_hd__probe_p_* sky130_fd_sc_hd__probec_p_* sky130_fd_sc_hd__tap* sky130_fd_sc_hd__decap* sky130_ef_sc_hd__decap* sky130_fd_sc_hd__fill*}

# global route
set global_routing_layers met1-met4
set global_routing_clock_layers met1-met4
set global_routing_layer_adjustments {{met1 0.05} {met2 0.05} {met3 0.05} {met4 0.05} {met5 0.05}}

# detail route
set min_routing_layer met1
set max_routing_layer met4

set rcx_rules_file "OpenROAD/sky130hd/sky130hd.rcx_rules"

# Local Variables:
# mode:tcl
# End: