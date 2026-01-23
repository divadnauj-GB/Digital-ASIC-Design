`timescale 1ns / 1ps

`define CLK_FREQ 50000000
`define CLK_PWM 10000
`define PERIOD_VAL  `CLK_FREQ/`CLK_PWM
`define N_PUSH 10
`define P_PUSH 400
`define HP_PUSH `P_PUSH/2

module tb_rgb_mixer;
task automatic assert_equal(input [31:0] actual, input [31:0] expected);
    if(actual == expected) $display("Time %d: Assertion passed: Expected %d, Actual %d.",$time, expected, actual);
    else $error("Time: %d: Assertion failed: Expected %d, Actual %d.", $time, expected, actual);
endtask

reg clk;
reg rst_n;
reg inc;
reg dec;
reg [1:0] led;
wire PWM0, PWM1, PWM2;


reg up, down;

rgb_mixer #(.DEBOUNCE_FREQ(1000000)) dut(.clk(clk), .rst_n(rst_n), .inc(inc), .dec(dec), .led(led), .PWM0(PWM0), .PWM1(PWM1), .PWM2(PWM2));

always #10 clk=~clk;

task automatic push_inc_button;
input integer num_pushes;
  begin
    repeat(num_pushes) begin
        inc=1;
        repeat(3) @(negedge clk);
        inc=0;
        repeat(6) @(negedge clk);
        inc=1;
        repeat(5) @(negedge clk);
        inc=0;
        repeat(10) @(negedge clk);
        inc=1;
        repeat((`HP_PUSH)-24) @(negedge clk);
        inc=0;
        repeat(3) @(negedge clk);
        inc=1;
        repeat(6) @(negedge clk);
        inc=0;
        repeat(5) @(negedge clk);
        inc=1;
        repeat(10) @(negedge clk);
        inc=0;
        repeat((`HP_PUSH)-24) @(negedge clk);
    end
  end
endtask

task automatic push_dec_button;
input integer num_pushes;
  begin
    repeat(num_pushes) begin
        dec=1;
        repeat(3) @(negedge clk);
        dec=0;
        repeat(6) @(negedge clk);
        dec=1;
        repeat(5) @(negedge clk);
        dec=0;
        repeat(10) @(negedge clk);
        dec=1;
        repeat((`HP_PUSH)-24) @(negedge clk);
        dec=0;
        repeat(3) @(negedge clk);
        dec=1;
        repeat(6) @(negedge clk);
        dec=0;
        repeat(5) @(negedge clk);
        dec=1;
        repeat(10) @(negedge clk);
        dec=0;
        repeat((`HP_PUSH)-24) @(negedge clk);
    end
  end
endtask

task automatic assert_PWM0(input integer N);
begin
    repeat(N*32) @(negedge clk);
    assert_equal(PWM0,1);
    repeat(`PERIOD_VAL-N*32+1) @(negedge clk);
    assert_equal(PWM0,0);
end
endtask

task automatic assert_PWM1(input integer N);
begin
    repeat(N*32) @(negedge clk);
    assert_equal(PWM1,1);
    repeat(`PERIOD_VAL-N*32+1) @(negedge clk);
    assert_equal(PWM1,0);
end
endtask

task automatic assert_PWM2(input integer N);
begin
    repeat(N*32) @(negedge clk);
    assert_equal(PWM2,1);
    repeat(`PERIOD_VAL-N*32+1) @(negedge clk);
    assert_equal(PWM2,0);
end
endtask

integer i,j;
initial begin
    inc=0;
    dec=0;
    clk=0;
    rst_n=0;
    up=0;
    down=0;
    led=0;
    #100;
    rst_n=1;
    for (i=0; i<=14; i=i+1) begin
        push_inc_button(`N_PUSH);
        repeat(`PERIOD_VAL-(`P_PUSH*`N_PUSH)+1) @(negedge clk);
    end

    for (i=0; i<14; i=i+1) begin
        push_dec_button(`N_PUSH);
        repeat(`PERIOD_VAL-`P_PUSH*`N_PUSH+1) @(negedge clk);
    end

    led=1;
    for (i=0; i<=14; i=i+1) begin
        push_inc_button(`N_PUSH);
        repeat(`PERIOD_VAL-`P_PUSH*`N_PUSH+1) @(negedge clk);
    end

    for (i=0; i<14; i=i+1) begin
        push_dec_button(`N_PUSH);
        repeat(`PERIOD_VAL-`P_PUSH*`N_PUSH+1) @(negedge clk);
    end

    led=2;
    for (i=0; i<=14; i=i+1) begin
        push_inc_button(`N_PUSH);
        repeat(`PERIOD_VAL-`P_PUSH*`N_PUSH+1) @(negedge clk);
    end

    for (i=0; i<14; i=i+1) begin
        push_dec_button(`N_PUSH);
        repeat(`PERIOD_VAL-`P_PUSH*`N_PUSH+1) @(negedge clk);
    end
    
    $finish;
end 

initial begin
    #130;
    #100000;
    for (j=1;j<=15;j=j+1) begin
        assert_PWM0(`N_PUSH*j);
    end

    for (j=14;j>0;j=j-1) begin
        assert_PWM0(`N_PUSH*j);
    end   
    for (j=1;j<=15;j=j+1) begin
        assert_PWM1(`N_PUSH*j);
    end

    for (j=14;j>0;j=j-1) begin
        assert_PWM1(`N_PUSH*j);
    end   

    for (j=1;j<=15;j=j+1) begin
        assert_PWM2(`N_PUSH*j);
    end

    for (j=14;j>0;j=j-1) begin
        assert_PWM2(`N_PUSH*j);
    end   
    
end

initial
begin
    $dumpfile("tb_rgb_mixer.vcd");
    $dumpvars;
end


endmodule