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
    