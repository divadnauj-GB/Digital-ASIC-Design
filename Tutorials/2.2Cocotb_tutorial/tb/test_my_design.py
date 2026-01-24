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