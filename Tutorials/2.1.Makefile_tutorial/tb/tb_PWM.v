// PWM TestBench description
`timescale 1ns / 1ps
`define CLK_FREQ 50000000
`define CLK_PWM 10000
`define PERIOD_VAL  `CLK_FREQ/`CLK_PWM

module tb_PWM;

reg s_clk, s_rst_n;
reg [$clog2(`PERIOD_VAL)-1:0] s_pwm_ref;
wire s_pwm;

PWM dut(
.clk(s_clk),
.rst_n(s_rst_n),
.pwm_ref(s_pwm_ref),
.pwm(s_pwm)
);


always begin
    #10 s_clk = ~s_clk;
end


initial
  begin
    $dumpfile("tb_PWM.vcd");
    $dumpvars;
  end

initial begin
s_clk=0;
s_rst_n=0;
s_pwm_ref=100;
#80 s_rst_n=1;
repeat (20000) @(negedge s_clk);
s_pwm_ref=500;
repeat (20000) @(negedge s_clk);
s_pwm_ref=1000;
repeat (20000) @(negedge s_clk);
s_pwm_ref=1500;
repeat (20000) @(negedge s_clk);
s_pwm_ref=2000;
repeat (20000) @(negedge s_clk);
s_pwm_ref=2500;
repeat (20000) @(negedge s_clk);
s_pwm_ref=3000;
repeat (20000) @(negedge s_clk);
s_pwm_ref=4000;
repeat (20000) @(negedge s_clk);
s_pwm_ref=3000;
repeat (20000) @(negedge s_clk);
s_pwm_ref=2500;
repeat (20000) @(negedge s_clk);
s_pwm_ref=2000;
repeat (20000) @(negedge s_clk);
s_pwm_ref=1000;
repeat (20000) @(negedge s_clk);
s_pwm_ref=100;
repeat (20000) @(negedge s_clk);
$finish;
end

endmodule