DESIGN_NAME=rgb_mixer

SRC_DIR=../7.3.Routing/results/
TOOL_SCRIPTS=/usr/local/lib/python3.12/dist-packages/librelane/scripts
TOOL_STEP_DIR=$(PWD)/results

export SCRIPTS_DIR=$(TOOL_SCRIPTS)
export STEP_DIR=$(TOOL_STEP_DIR)
export NETGEN_SETUP=/foss/pdks/sky130A/libs.tech/netgen/sky130A_setup.tcl


MAGIC_GDS_ENV=scripts/tcl_env_mgds.tcl
MAGIC_GDS_SCRIPT=$(TOOL_SCRIPTS)/magic/def/mag_gds.tcl

MAGIC_DRC_ENV=scripts/tcl_env_mgds.tcl
MAGIC_DRC_SCRIPT=$(TOOL_SCRIPTS)/magic/drc.tcl

MAGIC_LVS_ENV=scripts/tcl_env_lvs.tcl
MAGIC_LVS_SCRIPT=$(TOOL_SCRIPTS)/magic/extract_spice.tcl

all: mgds mdrc kgds kdrc lvs

res: 
	cp -r $(SRC_DIR)/ .
	mkdir -p results/reports

mgds: res
	@echo "Starting Magic DRC and LVS..."
	export _TCL_ENV_IN=$(MAGIC_GDS_ENV); export _MAGIC_SCRIPT=$(MAGIC_GDS_SCRIPT); exec magic -dnull -noconsole \
	-rcfile /foss/pdks/sky130A/libs.tech/magic/sky130A.magicrc \
	$(TOOL_SCRIPTS)/magic/wrapper.tcl


mdrc: mgds
	@echo "Starting Magic DRC and LVS..."
	export _TCL_ENV_IN=$(MAGIC_DRC_ENV); export _MAGIC_SCRIPT=$(MAGIC_DRC_SCRIPT); exec magic -dnull -noconsole \
	-rcfile /foss/pdks/sky130A/libs.tech/magic/sky130A.magicrc \
	$(TOOL_SCRIPTS)/magic/wrapper.tcl


kgds: res
	/usr/bin/python3 $(TOOL_SCRIPTS)/klayout/stream_out.py \
	results/rgb_mixer_sky130hd-tcl.def \
	--output results/rgb_mixer.klayout.gds \
	--top $(DESIGN_NAME) \
	--lyp /foss/pdks/sky130A/libs.tech/klayout/tech/sky130A.lyp \
	--lyt /foss/pdks/sky130A/libs.tech/klayout/tech/sky130A.lyt \
	--lym /foss/pdks/sky130A/libs.tech/klayout/tech/sky130A.map \
	--input-lef /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef \
	--input-lef /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef \
	--input-lef /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_ef_sc_hd.lef \
	--with-gds-file /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/gds/sky130_fd_sc_hd.gds


kdrc: kgds
	klayout -b -zz -r /foss/pdks/sky130A/libs.tech/klayout/drc/sky130A_mr.drc \
	-rd input=results/rgb_mixer.klayout.gds \
	-rd topcell=$(DESIGN_NAME) \
	-rd report=reports/drc_violations.klayout.xml \
	-rd feol=true -rd beol=true -rd floating_metal=false -rd offgrid=true -rd seal=true -rd threads=12

	python3 $(TOOL_SCRIPTS)/klayout/xml_drc_report_to_json.py \
	--xml-file=results/reports/drc_violations.klayout.xml \
	--json-file=results/reports/drc_violations.klayout.json


lvs: mgds
	export _TCL_ENV_IN=$(MAGIC_LVS_ENV); export _MAGIC_SCRIPT=$(MAGIC_LVS_SCRIPT); magic -dnull -noconsole \
	-rcfile /foss/pdks/sky130A/libs.tech/magic/sky130A.magicrc \
	$(TOOL_SCRIPTS)/magic/wrapper.tcl

	netgen -batch source scripts/lvs_script.lvs

clean:
	@echo "Cleaning up DRC and LVS results..."
	rm -rf results *.log