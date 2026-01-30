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

- This require to revisit python programmin using OOP (classes, methods), it is important to undertand the basics of multithreading or multiprocessing in python.

# Cocotb applied to the RGB mixer

## CocoTB on PWM module

The full code is available in [./tb/tb_PWM.py](./tb/tb_PWM.py)

```python
import cocotb
from cocotb.triggers import Timer, FallingEdge, ClockCycles
from cocotb.clock import Clock


@cocotb.test()
async def my_first_test(dut):
    """Try accessing the design."""
    clock = Clock(dut.clk, 20, units="ns")
    cocotb.start_soon(clock.start())

    dut.rst_n.value = 0
    dut.pwm_ref.value=0
    await Timer(70, units="ns") # Hold reset for 20ns
    dut.rst_n.value = 1
    
    dut._log.info("Reset complete, starting counting") # Log a message
    
    await ClockCycles(dut.clk, 2000, False)
    dut.pwm_ref.value=500
    await ClockCycles(dut.clk, 2000, False)
    dut.pwm_ref.value=1000
    await ClockCycles(dut.clk, 2000, False)
    dut.pwm_ref.value=1500
    await ClockCycles(dut.clk, 2000, False)
    dut.pwm_ref.value=2000
    await ClockCycles(dut.clk, 2000, False)
    dut.pwm_ref.value=2500
    await ClockCycles(dut.clk, 2000, False)
    dut.pwm_ref.value=3000
    await ClockCycles(dut.clk, 2000, False)
    dut.pwm_ref.value=2500
    await ClockCycles(dut.clk, 2000, False)
    dut.pwm_ref.value=2000
    await ClockCycles(dut.clk, 2000, False)
    dut.pwm_ref.value=1500
    await ClockCycles(dut.clk, 2000, False)
    dut.pwm_ref.value=1000
    await ClockCycles(dut.clk, 2000, False)
    dut.pwm_ref.value=100
```

## CocoTB on Up_down_counter module

The full code is available in [./tb/tb_up_down_counter.py](./tb/tb_up_down_counter.py)


```python
import cocotb
from cocotb.triggers import Timer, FallingEdge, ClockCycles, Join
from cocotb.clock import Clock

class push_button():
    """This class emulates the pulses generated externally by a push button"""
    def __init__(self, clk, pulse ):
        # inputs
        self.clk = clk
        self.pulse = pulse
        self.pulse.value=0

    async def update(self,en,repeat):
        for _ in range(repeat):
            if en:
                self.pulse.value=1
                await ClockCycles(self.clk, 1, False)
                self.pulse.value=0
                await ClockCycles(self.clk, 20, False)
            else:
                self.pulse.value=0
                await ClockCycles(self.clk, 1, False)
                self.pulse.value=0
                await ClockCycles(self.clk, 20, False)

@cocotb.test()
async def my_first_test(dut):
    """Main test bench sequence"""
    clock = Clock(dut.clk, 20, units="ns")
    cocotb.start_soon(clock.start())
    dut.inc.value=0
    dut.dec.value=0
    dut.rst_n.value = 0
    dut.enable.value=0

    inc_button_task = push_button(dut.clk, dut.inc)
    dec_button_task = push_button(dut.clk, dut.dec)

    await Timer(70, units="ns") # Hold reset for 20ns
    dut.rst_n.value = 1
    dut.enable.value=1
    await inc_button_task.update(1,256)
    assert (dut.pwm_ref==255) 
    dut.enable.value=0
    await inc_button_task.update(1,256)
    assert (dut.pwm_ref==255) 
    dut.enable.value=1
    await dec_button_task.update(1,255)
    assert (dut.pwm_ref==0) 
    dut.enable.value=0
    await dec_button_task.update(1,255)
    assert (dut.pwm_ref==0) 

    dut.enable.value=1
    start1 = cocotb.start_soon(inc_button_task.update(1,255))
    start2 = cocotb.start_soon(dec_button_task.update(1,255))
    
    await start1
    await start2
    assert (dut.pwm_ref==255) 

    dut.enable.value=0
    start1 = cocotb.start_soon(inc_button_task.update(1,255))
    start2 = cocotb.start_soon(dec_button_task.update(1,255))
    await start1
    await start2
    assert (dut.pwm_ref==255) 

    dut.enable.value=1
    await ClockCycles(dut.clk,1000,False)
    assert (dut.pwm_ref==255)
    dut.enable.value=0
    await ClockCycles(dut.clk,1000,False)
    assert (dut.pwm_ref==255)
    dut.enable.value=1
    await ClockCycles(dut.clk,1000,False)
    assert (dut.pwm_ref==255)
    dut.enable.value=0
    await ClockCycles(dut.clk,1000,False)
    assert (dut.pwm_ref==255)
```

## CocoTB on Edge_detector module

The full code is available in [./tb/tb_edge_detector.py](./tb/tb_edge_detector.py)

```python
import cocotb
from cocotb.triggers import Timer, FallingEdge, ClockCycles, Join
from cocotb.clock import Clock

class pulse_gen():
    """This class emulates the pulses generated externally by a push button"""
    def __init__(self, clk, pulse ):
        # inputs
        self.clk = clk
        self.pulse = pulse
        self.pulse.value=0

    async def update(self,val):
        await ClockCycles(self.clk,100)
        await Timer(1,units="ns")
        self.pulse.value=val
        await FallingEdge(self.clk)


@cocotb.test()
async def my_first_test(dut):
    """Main test bench sequence"""
    clock = Clock(dut.clk, 20, units="ns")
    cocotb.start_soon(clock.start())
    dut.input_signal.value=0
    dut.rst_n.value = 0
    await Timer(70, units="ns") # Hold reset for 20ns
    dut.rst_n.value = 1
    pulse_gen_task = pulse_gen(dut.clk,dut.input_signal)
    for _ in range(10):
        await pulse_gen_task.update(1)
        assert (dut.edge_pulse.value==0)
        await pulse_gen_task.update(0)
        assert (dut.edge_pulse.value==1)

```

## CocoTB on Debounce module

The full code is available in [./tb/tb_debounce.py](./tb/tb_debounce.py)

```python
import cocotb
from cocotb.triggers import Timer, FallingEdge, ClockCycles, Join
from cocotb.clock import Clock

class button_sim():
    """This class emulates the pulses generated externally by a push button"""
    def __init__(self, clk, pulse ):
        # inputs
        self.clk = clk
        self.pulse = pulse
        self.pulse.value=0

    async def update(self,edge):
        for _ in range(10):
            await FallingEdge(self.clk)
        self.pulse.value=edge
        await Timer(30,units="ns")
        self.pulse.value=(~edge)&1
        await Timer(20,units="ns")
        self.pulse.value=edge
        await Timer(2000, units="ns")

@cocotb.test()
async def my_first_test(dut):
    """Main test bench sequence"""
    clock = Clock(dut.clk, 20, units="ns")
    cocotb.start_soon(clock.start())
    dut.input_signal.value=0
    dut.rst_n.value = 0
    await Timer(70, units="ns") # Hold reset for 20ns
    dut.rst_n.value = 1

    button_sim_task = button_sim(dut.clk,dut.input_signal)
    for _ in range(10):
        await button_sim_task.update(1)
        assert (dut.clean_signal.value==1)
        await button_sim_task.update(0)
        assert (dut.clean_signal.value==0)
```

## CocoTB on RGB_mixer module

The full code is available in [./tb/tb_rgb_mixer.py](./tb/tb_rgb_mixer.py)

```python
import cocotb
from cocotb.triggers import Timer, FallingEdge, RisingEdge, ClockCycles, Join
from cocotb.clock import Clock

class button_sim():
    """This class emulates the pulses generated externally by a push button"""
    def __init__(self, clk, pulse ):
        # inputs
        self.clk = clk
        self.pulse = pulse
        self.pulse.value=0

    async def update(self,num_pushes):
        for _ in range(num_pushes):
            self.pulse.value=1
            for _ in range(3):
                await FallingEdge(self.clk)
            self.pulse.value=0
            for _ in range(6):
                await FallingEdge(self.clk)
            self.pulse.value=1
            for _ in range(5):
                await FallingEdge(self.clk)
            self.pulse.value=0
            for _ in range(10):
                await FallingEdge(self.clk)
            self.pulse.value=1
            for _ in range(200-24):
                await FallingEdge(self.clk)
            self.pulse.value=0
            for _ in range(3):
                await FallingEdge(self.clk)
            self.pulse.value=1
            for _ in range(6):
                await FallingEdge(self.clk)
            self.pulse.value=0
            for _ in range(5):
                await FallingEdge(self.clk)
            self.pulse.value=1
            for _ in range(10):
                await FallingEdge(self.clk)
            self.pulse.value=0
            for _ in range(200-24):
                await FallingEdge(self.clk)

class monitor():
    """This class emulates the pulses generated externally by a push button"""
    def __init__(self, clk, PWM0, PWM1, PWM2):
        # inputs
        self.clk = clk
        self.PWM0 = PWM0
        self.PWM1 = PWM1
        self.PWM2 = PWM2

    async def check_PWM0(self,N):
        await RisingEdge(self.PWM0)
        for _ in range(N*32):
            await FallingEdge(self.clk)
        assert (self.PWM0.value==1)
        for _ in range(5000-N*32+1):
            await FallingEdge(self.clk)
        assert (self.PWM0.value==0)

    async def check_PWM1(self,N):
        await RisingEdge(self.PWM1)
        for _ in range(N*32):
            await FallingEdge(self.clk)
        assert (self.PWM1.value==1)
        for _ in range(5000-N*32+1):
            await FallingEdge(self.clk)
        assert (self.PWM1.value==0)

    async def check_PWM2(self,N):
        await RisingEdge(self.PWM2)
        for _ in range(N*32):
            await FallingEdge(self.clk)
        assert (self.PWM2.value==1)
        for _ in range(5000-N*32+1):
            await FallingEdge(self.clk)
        assert (self.PWM2.value==0)

    async def start(self):

        for i in range(1,13):
            await self.check_PWM0(10*i)

        for i in range(12,0,-1):
            await self.check_PWM0(10*i)

        for i in range(1,13):
            await self.check_PWM1(10*i)

        for i in range(12,0,-1):
            await self.check_PWM1(10*i)

        for i in range(1,13):
            await self.check_PWM2(10*i)

        for i in range(12,0,-1):
            await self.check_PWM2(10*i)

@cocotb.test()
async def my_first_test(dut):
    """Main test bench sequence"""
    clock = Clock(dut.clk, 20, units="ns")
    cocotb.start_soon(clock.start())
    monitor_task=monitor(dut.clk,dut.PWM0,dut.PWM1,dut.PWM2)
    cocotb.start_soon(monitor_task.start())
    dut.inc.value=0
    dut.dec.value=0
    dut.rst_n.value = 0
    dut.led.value=0
    await Timer(100, units="ns") # Hold reset for 20ns
    dut.rst_n.value = 1

    inc_button_task = button_sim(dut.clk,dut.inc)
    dec_button_task = button_sim(dut.clk,dut.dec)

    for _ in range(15):
        await inc_button_task.update(10)
        for i in range(5000-400*10+1):
            await FallingEdge(dut.clk)

    for _ in range(14):
        await dec_button_task.update(10)
        for i in range(5000-400*10+1):
            await FallingEdge(dut.clk)

    dut.led.value=1

    for _ in range(15):
        await inc_button_task.update(10)
        for i in range(5000-400*10+1):
            await FallingEdge(dut.clk)

    for _ in range(14):
        await dec_button_task.update(10)
        for i in range(5000-400*10+1):
            await FallingEdge(dut.clk)
    
    dut.led.value=2

    for _ in range(15):
        await inc_button_task.update(10)
        for i in range(5000-400*10+1):
            await FallingEdge(dut.clk)

    for _ in range(14):
        await dec_button_task.update(10)
        for i in range(5000-400*10+1):
            await FallingEdge(dut.clk)  
```

## Cocotb Makefile

- The Makefile used for compiling and running the cocotb simulations is available in [./Makefile](./Makefile). 