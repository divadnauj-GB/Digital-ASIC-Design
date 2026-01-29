---
title: "Cocotb Tutorial "
author: "Juan David Guerrero Balaguera, Ph.D"
date: "January 25, 2026"
output: beamer_presentation
---

# TestBench using Cocotb

## What is cocotb

**Cocotb** (Coroutine-based Co-simulation TestBench) is a free, open-source framework that allows hardware engineers to verify VHDL/Verilog Register Transfer Level (RTL) designs using **Python**, rather than traditional hardware verification languages like SystemVerilog.

<div style="text-align: center;">
    <img src="./doc/cocotb_logo.png" width="20%" >
</div>


## Cocotb usage
The core of a cocotb testbench is a Python function that uses the **@cocotb.test()** decorator and interacts with the hardware design using await for timing control.

In order to learn the basics of cocotb let's walk trough a counter excercise. 

::: {.columns}

::: {.column width="45%" }

```Verilog
  `timescale 1ns / 1ps
  module my_design (
      clk,
      reset,
      count
  );
      input clk;
      input reset;
      output reg [7:0] count;
      
    always @(posedge clk or negedge reset) begin
      if (!reset) begin
        count <= 8'd0;
      end else begin
        count <= count + 1'b1;
      end
    end
  endmodule
```

:::

::: {.column width="45%" }

- The verilog code describes an 8-bit counter using a single always block.

- The name of the counter is **my_design**.
- The modules has three ports:
  - **clk**: The input clock.
  - **reset**: An asynchronous active low reset signal.
  - **count**: the output port where the counter will be visible.

:::

:::

---

- The testbench using cocotb can be implemented by the following code example

  ```python
  import cocotb
  from cocotb.triggers import Timer, FallingEdge
  from cocotb.clock import Clock

  @cocotb.test()
  async def my_first_test(dut):
      """Try accessing the design."""
      clock = Clock(dut.clk, 20, units="ns")
      cocotb.start_soon(clock.start())

      dut.reset.value = 0
      await Timer(50, units="ns") # Hold reset for 20ns
      dut.reset.value = 1
      
      dut._log.info("Reset complete, starting counting") # Log a message
      
      await FallingEdge(dut.clk)
      assert dut.count.value == 0, f"Count is not 0 after reset, got {dut.count.value}"

      for _ in range(5):
          await FallingEdge(dut.clk)
          dut._log.info(f"Count is currently {dut.count.value}")

      assert dut.count.value == 5, f"Count did not reach 5, got {dut.count.value}"
  ```

