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

    
