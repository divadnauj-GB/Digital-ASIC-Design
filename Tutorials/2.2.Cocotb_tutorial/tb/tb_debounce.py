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




    
