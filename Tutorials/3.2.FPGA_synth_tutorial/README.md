---
title: "FPGA Tutorial "
author: "Juan David Guerrero Balaguera, Ph.D"
date: "January 25, 2026"
output: beamer_presentation
---

# Introduction

This example shows how to create and compile asimple project using quartus II using TCL scripts and CLI, this is very usefule when using servers or linux based frameworks.

# Basic Example on DE1 Board

## Basic files for project creation

- The basic example is composed of a set of directories and TCL scripts as depicted in this figure.

    ```bash
    |- basic_example
       |-- scripts
       |   |-- de1-pinmap.tcl
       |   |-- de1.sdc
       |   |-- options.tcl
       |-- de1_basic_project.tcl
       |-- de1_basic_project.v
       |-- Makefile
    ```

- The **`de1_basic_project.tcl`** script is the main file for creating the project on Quartus II. 

- The **`de1_basic_project.v`** file corresponds to the Verilog example design

- Inside the **`scripts`** directory there are pin assignemt scripts, SDC files and other additional configuration when needed. 
- The **`Makefile`** contains the compilation rules to compile the FPGA project.

---

### Detailed scripts {.example}
- **`de1-pinmap.tcl`**: This script contain the pin assignemts according to the design and the FPGA device.
- **`de1.sdc`**: This script contain timing constraints mainly.
- **`options.tcl`**: In case of additional configuration, they can be inserted in this script.
    - The default TCL commands can be found in the **`assignment_defaults.qdf`** file in your quartus installation directory (e.g., **`/home/ubuntu/altera/13.0sp1/quartus/linux/assignment_defaults.qdf`**). 


### Note {.alert}

- For additional configuration entries using TCL scripting you can check the Quartus II documentation either consulting online the [quartus settings file reference](https://www.intel.com/content/www/us/en/content-details/653795/quartus-ii-handbook-version-13-0.html) or the built in help menu in the quartus software.

## FPGA Flow

::: {.columns}

::: {.column width="20%"}

### FPGA flow design

<div style="text-align: center;">
    <img src="./doc/FPGA-flow.png" width="100%" >
</div>

:::

::: {.column width="75%"}

### Quartus II shell flow


```bash
export PATH:$PATH:/path/to/quartus/bin #export the quartus bin directory to the path
quartus_sh -t de1_basic_project.tcl #create the project using tcl scripts
quartus_map de1_basic_project # synthesize and map to LUTS
quartus_fit de1_basic_project # Place and routing
quartus_asm de1_basic_project # assemble bitstring generation
quartus_sta de1_basic_project # static timing analysis

```

:::

:::

### Makefile automation

The previous sequence of commands can be issued automatically via the Makefile

```bash
export PATH:$PATH:/path/to/quartus/bin #export the quartus bin directory to the path
make all
```

## FPGA device programming using USB blaster on Linux devices

- check that the device is connected properly
```bash
./jtagconfig
1) USB-Blaster [1-2]
031050DD 10M50DA(.|ES)/10M50DC
```

- Program the device using the `*.sof` file
```bash
quartus_pgm  -m jtag -o "p;output_files/de1_basic_project.sof" 
```

# RGB Mixer on FPGA

- Let's see the FPGA implementation of the RGB mixer trough the following steps:

    0. Create the project tree directory.
    1. Be sure all files are in a reachable directory (e.g., /rgb_mixer/src). 
    2. Modify or create the main TCL file, setting the project name, and include all source Verilog files.
    3. Modify the `de1-pinmap.tcl` with the pin assignments, and set the CLK frequency on the `de1.sdc` file. 
    4. Modify the makefile to match the project name. 


## Create a project structure

- The project directory contains all source files (*.v) and the necesary scripts to create and compile de project

```bash
    |- rgb_mixer
       |-- scripts
       |   |-- de1-pinmap.tcl
       |   |-- de1.sdc
       |   |-- options.tcl
       |-- src
       |   |-- debounce.v
       |   |-- edge_detector.v
       |   |-- PWM.v
       |   |-- rgb_mixer.v
       |   |-- up_down_counter.v
       |-- rgb_mixer.tcl
       |-- Makefile
```

## Edit the TCL main file

- The main TCL script configures the project and includes all configurations and source files.

```tcl
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
```

## Make pin assignments

- The pin assignments are made on the [./rgb_mixer/scripts/de1-pinmap.tcl](./rgb_mixer/scripts/de1-pinmap.tcl) as follows:
    - check the DE1 user manual to verify the connections

```tcl
set_location_assignment PIN_R22 -to rst_n
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to rst_n
set_location_assignment PIN_R21 -to inc
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to inc
set_location_assignment PIN_T22 -to dec
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to dec

set_location_assignment PIN_L1 -to clk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to clk

set_location_assignment PIN_L22 -to led[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to led[0]
set_location_assignment PIN_L21 -to led[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to led[1]

set_location_assignment PIN_U22 -to PWM0
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to PWM0
set_location_assignment PIN_U21 -to PWM1
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to PWM1
set_location_assignment PIN_V22 -to PWM2
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to PWM2
```

## Add SDC constraints

- The RGB mixer uses a clock input, we need to specify the desired operative frequency in the [./rgb_mixer/scripts/de1.sdc](./rgb_mixer/scripts/de1.sdc). 

    ```tcl
    # Main system clock (50 MHz)
    create_clock -name "clk" -period 20.000ns [get_ports {clk}]
    # Automatically calculate clock uncertainty to jitter and other effects.
    derive_clock_uncertainty
    ```

## Makefile and compilation

```Makefile
# Auto generated by Edalize
NAME := rgb_mixer
OPTIONS := 
DSE_OPTIONS := 

all: sta
project: $(NAME).tcl
	quartus_sh $(OPTIONS) -t $(NAME).tcl
qsys: project
syn: qsys
	quartus_map $(OPTIONS) $(NAME)
fit: syn
	quartus_fit $(OPTIONS) $(NAME)
asm: fit
	quartus_asm $(OPTIONS) $(NAME)
sta: asm
	quartus_sta $(OPTIONS) $(NAME)
clean:
	rm -rf *.qpf *.qsf db incremental_db output_files
.PHONY: all project qsys syn fit asm sta dse clean
```

### Create and compile the project

```bash
export PATH:$PATH:/path/to/quartus/bin #export the quartus bin directory to the path
make all
```


## Program the FPGA device

- Check that the device is connected properly

    ```bash
    ./jtagconfig
    1) USB-Blaster [1-2]
    031050DD 10M50DA(.|ES)/10M50DC
    ```

- Program the device using the `*.sof` file

    ```bash
    quartus_pgm  -m jtag -o "p;output_files/rgb_mixer.sof" 
    ```

