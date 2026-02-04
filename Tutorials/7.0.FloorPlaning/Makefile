export RESULTS_DIR=$(PWD)/results


run: 
	@echo "Running floorplanning..."
	openroad scripts/rgb_mixer_sky130hd.tcl

clean:
	@echo "Cleaning up floorplanning results..."
	rm -rf results *.log