---
title: "Yosys Tutorial "
author: "Juan David Guerrero Balaguera, Ph.D"
date: "January 25, 2026"
output: beamer_presentation
---

# Introduction

<div style="text-align: center;">
    <img src="./doc/Yosys-logo.png" width="40%" >
</div>

- **`Yosys`** is a framework for **`Verilog`** RTL synthesis. The following are the typicall features and application:
    - Process almost any synthesizable Verilog-2005 design
    - Converting Verilog to BLIF / EDIF/ BTOR / SMT-LIB / simple RTL Verilog / etc.
    - Built-in formal methods for checking properties and equivalence
    - Mapping to ASIC standard cell libraries (in Liberty File Format)
    - Mapping to Xilinx 7-Series and Lattice iCE40 and ECP5 FPGAs
    - Foundation and/or front-end for custom flows
    - VHDL supported trough GHDL


## Synthesis Flow

::: {.columns}

::: {.column width="45%"}

<div style="text-align: center;">
    <img src="./doc/Synth-Flow.png" width="100%" >
</div>

\tiny Source: [https://vlsi.ethz.ch/wiki/Exercise_-_Synthesis](https://vlsi.ethz.ch/wiki/Exercise_-_Synthesis)

:::

::: {.column width="55%"}

- In Yosys, synthesis is a multi-stage process, typically consisting of the following four main steps:

    - **Front-end Preprocessing:** This is the initial stage where Yosys reads the RTL code. It parses the code and generates an internal representation using an abstract syntax tree (AST). 

:::

:::

- 
    - **Elaboration:** Yosys expands all module instantiations, resolves parameters, and, if necessary, flattens the hierarchy. The elaborated netlist represents a fully resolved version of the original RTL, ready for further processing.

    - **Coarse-grain Synthesis:** Translates the RTL into a gate-level netlist. The combinational and sequential logic is mapped to basic gates like AND, OR, XOR, and registers (flip-flops). 

    - **Technology Mapping:** Uses ABC to map the optimized netlist to a specific target technology, such as an FPGA or ASIC standard cell library. 

# Yosys synthesis example

## Introduction

- This example illustrates the Synthesis flow using Yosys, from RTL to Gate Level.

- The sysnthesis process combines Yosys and ABC to transform an RTL description into logic cells and flip-flops. 

- The example uses the SKY130 PDK technology; However, the flow is pretty similar whe having another PDK technology (e.g., IHP130)


## Front-End preprocessing 

- The full synthesis process is automatized by usinag a TCL script for Yosys. The full script is available in [Tutorials/3.3.Yosys_tutorial/yosys/synthesis_yosys.tcl](./yosys/synthesis_yosys.tcl)

### Load Technology Libraries

```tcl
set PDK_ROOT $env(PDK_ROOT)
set PDK $env(PDK)

set std_cells_lib $PDK_ROOT/$PDK/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

yosys read_liberty -lib ${std_cells_lib} 
```

- The technology library provides information about the fundamental aspects for ASIC manufacturing, during the synthesis steps the RTL design is tranformed into Standard-Cells defined for the target tecnology. 
- The tech linraries are defined in something called **`liberty`** format.
    - Standard-cells
    - I/o pads
    - Memory macros


---


### Read Source Files

```tcl
yosys read_verilog src/debounce.v
yosys read_verilog src/edge_detector.v
yosys read_verilog src/PWM.v
yosys read_verilog src/up_down_counter.v
yosys read_verilog src/rgb_mixer.v
```

- The **`read_verilog`** command in **`yosys`** loads and parses the verilog source files.


## Elaboration

### Elaborate design

```tcl
yosys hierarchy -check -top rgb_mixer
yosys flatten 
```

- Selection of the top module and flattening of the entire designs. Here the subcomponents of the original designs desapear.


## Coarse-Grain synthesis

### Synthesis and design optimizations

```tcl
yosys proc ; # simplifly the always blocks into pure FF and logic
yosys fsm ; # identify and optimize FSM
yosys wreduce ; # Reduce word sizes
yosys peepopt ; # logic optimizations
yosys share ; # merges shareable resources
yosys opt -noff ; #optimize the desing except ff
yosys memory ; # Handle memoery structures
yosys opt_dff ; # optimize ffs only
yosys techmap ; # generic technology mapper
```

- The sequence of commmands apply different processes and optimization stages in order to simplify and design complexity, converting it into basic comonents (e.g., MUX, FA, MUL, AND, NAN, FF, SRAM, etc)


## Tecnology mapping

```tcl
set abc_script_file abc-opt.script ; # set the techmap script for abc
set synth_output rgb_mixer_gl.v ; # set the output file
set period_ps 10000 ; # set the timing constraint
yosys dfflibmap -liberty ${std_cells_lib}  ; # map flip-flops to tech. std-cells
# map logic to tech. std-cells
yosys abc -liberty ${std_cells_lib}  -D ${period_ps} -constr yosys/${constr_file} -script yosys/${abc_script_file} 
```

- The technology mapping ocurs in two steps:
    - Mapping flip-flops to tech. std-cell flip flops
    - Mapping Logic to tech. std-cells using **`abc`**.
        - For simplicity, this example provides an `abc` optimization script (`abc-opt.script`). If you want to know more about `abc` please refer to the documentation of the tool [https://people.eecs.berkeley.edu/~alanmi/abc/](https://people.eecs.berkeley.edu/~alanmi/abc/)
- Inputs and Outputs are not ideal, requiring special buffering using a contraints script (**`yosys_abc.constr`**)
    - ```set_driving_cell sky130_fd_sc_hd__buf_4```
    - ```set_load sky130_fd_sc_hd__buf_16```


## Preparation for Place an Routing

### Netlist preparation

```tcl
yosys splitnets ; # Split multi-bit nets into single-bit nets.
yosys setundef -zero ; #Replace undefined (x) constants with defined (0/1) constants.
yosys hilomap ; Map constants to 'tielo' and 'tiehi' driver cells.
# Creates the synthesized verilog netlist 
yosys write_verilog -noattr -simple-lhs synth/${synth_output}
```

- This commands prepare the netlist for the physical design step using **`OpenROAD`**

### Example synthesis {.example}
```verilog
...
  sky130_fd_sc_hd__o2bb2ai_1 _22546_ (
    .A1_N(_00540_),
    .A2_N(_00040_),
    .B1(_00794_),
    .B2(_00800_),
    .Y(_00203_)
  );
  sky130_fd_sc_hd__dfrtp_1 _22547_ (
    .CLK(clk),
    .D(_01690_),
    .Q(\PWM1_inst.pwm_reg ),
    .RESET_B(rst_n)
  );
...
```


# Gate level verification

- The synthesis and simulation flows have been automatized using the [Makefile](./Makefile)

### Run the Synthesis

```bash
make yosys_synth
```
- This command automatically executes yosys in TCL scripting mode and generates the output verilog netlist in the **`synth`** directory. 

### Run the Gate-Level simulation

```bash
make test_rgb_mixer
make show_tb_rgb_mixer
```

- This step reuses the TestBench previously created for the `rgb_mixer` and runs the simulation using the final Gate Level Netlist. 



