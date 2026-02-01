---
title: "Static Timing Analisys Tutorial"
author: "Juan David Guerrero Balaguera, Ph.D"
date: "January 25, 2026"
output: beamer_presentation
---

# Introduction to OpenSTA

- OpenSTA is a gate level static timing verifier. As a stand-alone executable it can be used to verify the timing of a design using standard file formats.
    - Verilog netlist
    - Liberty library
    - SDC timing constraints
    - SDF delay annotation
    - SPEF parasitics
    - VCD power acitivies
    - SAIF power acitivies
- OpenSTA uses a TCL command interpreter to read the design, specify timing constraints and print timing reports.

# STA for RGB Mixer

### Read library files

```tcl
set PDK_ROOT $env(PDK_ROOT)
set PDK $env(PDK)

set lib_dir ${PDK_ROOT}/${PDK}/libs.ref/sky130_fd_sc_hd
read_liberty ${lib_dir}/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
```

- Load the liberty files, used to make timing analysis 

### Load netlist

```tcl
read_verilog "./synth/rgb_mixer_gl.v"
link_design rgb_mixer
```

- Load and link the rgb_mixer design

---

### Set constraints

```tcl
create_clock -name clk_sys -period 10 [get_ports clk]
```

- Set the design contraint for the clock input. 

### Generate timing report

```tcl
report_checks -path_group clk_sys -path_delay max > "./sta.rpt"
```

- This makes the timing analysisn on the netlist design and report the maximum timing for the critical paths in the design. The report also indicates whether the timing meets the constraints or not.

### Run OpenSTA

```bash
sta opensta.tcl
```

---

### STA report {.example}
```rpt
Startpoint: _22606_ (rising edge-triggered flip-flop clocked by clk_sys)
Endpoint: _22637_ (rising edge-triggered flip-flop clocked by clk_sys)
Path Group: clk_sys
Path Type: max

  Delay    Time   Description
---------------------------------------------------------
   0.00    0.00   clock clk_sys (rise edge)
   0.00    0.00   clock network delay (ideal)
   0.00    0.00 ^ _22606_/CLK (sky130_fd_sc_hd__dfrtp_1)
   0.38    0.38 ^ _22606_/Q (sky130_fd_sc_hd__dfrtp_1)
   0.25    0.63 ^ _22060_/X (sky130_fd_sc_hd__and3_1)
   0.16    0.79 v _22061_/Y (sky130_fd_sc_hd__nand4_1)
...
   0.12    2.27 ^ _22432_/Y (sky130_fd_sc_hd__a21oi_1)
   0.00    2.27 ^ _22637_/D (sky130_fd_sc_hd__dfrtp_1)
           2.27   data arrival time

  10.00   10.00   clock clk_sys (rise edge)
   0.00   10.00   clock network delay (ideal)
   0.00   10.00   clock reconvergence pessimism
          10.00 ^ _22637_/CLK (sky130_fd_sc_hd__dfrtp_1)
  -0.08    9.92   library setup time
           9.92   data required time
---------------------------------------------------------
           9.92   data required time
          -2.27   data arrival time
---------------------------------------------------------
           7.65   slack (MET)
```