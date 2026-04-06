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
    