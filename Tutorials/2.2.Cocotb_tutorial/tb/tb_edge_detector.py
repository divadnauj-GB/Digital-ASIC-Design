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



    
