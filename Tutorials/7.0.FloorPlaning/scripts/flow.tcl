#############################################################
#############################################################
#############################################################

read_libraries

read_verilog $synth_verilog
link_design $top_module
read_sdc $sdc_file

set_thread_count [cpu_count]
# Temporarily disable sta's threading due to random failures
sta::set_thread_count 1

utl::metric "IFP::ord_version" [ord::openroad_git_describe]
# Note that sta::network_instance_count is not valid after tapcells are added.
utl::metric "IFP::instance_count" [sta::network_instance_count]

initialize_floorplan -site $site \
  -die_area $die_area \
  -core_area $core_area

#initialize_floorplan -utilization ${utilization} -aspect_ratio 1.0 -core_space 10.0 -site $site

source $tracks_file


# remove buffers inserted by synthesis
remove_buffers

if { $pre_placed_macros_file != "" } {
  source $pre_placed_macros_file
}

################################################################
# Macro Placement
if { [have_macros] } {
  lassign $macro_place_halo halo_x halo_y
  set report_dir [make_result_file ${design}_${platform}_rtlmp]
  rtl_macro_placer -halo_width $halo_x -halo_height $halo_y \
    -report_directory $report_dir
}

################################################################
# Tapcell insertion
eval tapcell $tapcell_args ;# tclint-disable command-args

################################################################
# Power distribution network insertion
source $pdn_cfg
pdngen

################################################################

set global_place_pad_db [make_result_file ${design}_${platform}.db]
write_db $global_place_pad_db

set routed_def [make_result_file ${design}_${platform}.def]
write_def $routed_def

set verilog_file [make_result_file ${design}_${platform}.v]
write_verilog $verilog_file

set verilog_file_pdn [make_result_file ${design}_${platform}_pdn.v]
write_verilog -include_pwr_gnd $verilog_file_pdn

set sdc_file [make_result_file ${design}_${platform}.sdc]
write_sdc  $sdc_file



# exec openroad -exit -no_splash \
# -python /usr/local/lib/python3.12/dist-packages/librelane/scripts/odbpy/io_place.py \
# --input-lef /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef \
# --input-lef /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef \
# --input-lef /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_ef_sc_hd.lef \
# --config pin_order.cfg \
# --hor-layer met3 \
# --ver-layer met2 \
# --hor-width-mult 2 \
# --ver-width-mult 2 \
# --hor-extension 0 \
# --ver-extension 0 \
# --unmatched-error unmatched_design \
# --ver-length 2 --hor-length 2 \
# --output-def results/rgb_mixer_sky130hd_io-tcl.def \
# --output-odb results/rgb_mixer_sky130hd_io-tcl.db \
# results/rgb_mixer_sky130hd_global_place_pad-tcl.db
