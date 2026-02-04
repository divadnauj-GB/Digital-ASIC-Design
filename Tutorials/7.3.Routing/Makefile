
export RESULTS_DIR=$(PWD)/results

run: 
	@echo "Running routing..."
	openroad scripts/rgb_mixer_sky130hd.tcl

clean:
	@echo "Cleaning up routing results..."
	rm -rf results *.log