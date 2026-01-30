// Up/Down counter core description
`timescale 1ns / 1ps
`define CLK_FREQ 50000000
`define CLK_PWM 10000
`define PERIOD_VAL  `CLK_FREQ/`CLK_PWM

module tb_up_down_counter;

task automatic assert_equal(input [31:0] actual, input [31:0] expected);
    if(actual == expected) $display("Assertion passed: Expected %d, Actual %d.", expected, actual);
    else $error("Assertion failed: Expected %d, Actual %d.", expected, actual);
endtask
    

reg s_clk;
reg s_rst_n;
reg s_enable;
reg s_inc;
reg s_dec;
wire [$clog2(`PERIOD_VAL)-1:0] pwm_ref;

reg up;
reg down;

up_down_counter UUT (
    .clk(s_clk),
    .rst_n(s_rst_n),
    .enable(s_enable),
    .inc(s_inc),
    .dec(s_dec),
    .pwm_ref(pwm_ref)
);

// Clock generation
always #10 s_clk = ~s_clk;

always begin
    if (down==1'b1) begin
        s_dec = 1; // Start decrementing
        @(negedge s_clk);
        s_dec = 0; 
        repeat(20) @(negedge s_clk);
    end else begin
        s_dec = 0; // Start decrementing
        @(negedge s_clk);
        s_dec = 0; 
        repeat(20) @(negedge s_clk);
    end

end

always begin
    if (up==1'b1)begin
        s_inc = 1; // Start incrementing
        @(negedge s_clk);
        s_inc = 0; 
        repeat(20) @(negedge s_clk);
    end else begin
        s_inc = 0;
        @(negedge s_clk);
        s_inc = 0; 
        repeat(20) @(negedge s_clk);
    end

end

initial begin
    $dumpfile("tb_up_down_counter.vcd");
    $dumpvars;
end

initial begin
    // Initialize signals
    up=0;
    down=0;
    s_clk = 0;
    s_rst_n = 0;
    s_enable = 0;
    s_inc = 0;
    s_dec = 0;

    // Release reset
    #25;
    s_rst_n = 1;
    up=1;
    down=0;
    s_enable = 1;

    repeat(256) begin
        wait(s_inc==1'b1 || s_dec==1'b1);
        @(posedge s_clk);
        wait(s_inc==1'b0 && s_dec==1'b0);
    end
    assert_equal(pwm_ref, 256);
    
    s_enable = 0;
    repeat(256) begin
        wait(s_inc==1'b1 || s_dec==1'b1);
        @(posedge s_clk);
        wait(s_inc==1'b0 && s_dec==1'b0);
    end
    assert_equal(pwm_ref, 256);
    up=0;
    down=1;
    s_enable = 1;
    repeat(256) begin
        wait(s_inc==1'b1 || s_dec==1'b1);
        @(posedge s_clk);
        wait(s_inc==1'b0 && s_dec==1'b0);
    end
    assert_equal(pwm_ref, 0);
    s_enable = 0;
    repeat(256) begin
        wait(s_inc==1'b1 || s_dec==1'b1);
        @(posedge s_clk);
        wait(s_inc==1'b0 && s_dec==1'b0);
    end
    assert_equal(pwm_ref, 0);
    up=1;
    down=1;
    s_enable = 1;
    repeat(256) begin
        wait(s_inc==1'b1 || s_dec==1'b1);
        @(posedge s_clk);
        wait(s_inc==1'b0 && s_dec==1'b0);
    end
    assert_equal(pwm_ref, 256);
    s_enable = 0;
    repeat(256) begin
        wait(s_inc==1'b1 || s_dec==1'b1);
        @(posedge s_clk);
        wait(s_inc==1'b0 && s_dec==1'b0);
    end
    assert_equal(pwm_ref, 256);
    up=0;
    down=0;
    s_enable = 1;
    repeat(1000) @(negedge s_clk);
    assert_equal(pwm_ref, 256);
    s_enable = 0;
    repeat(1000) @(negedge s_clk);
    assert_equal(pwm_ref, 256);
    s_enable = 1;
    repeat(1000) @(negedge s_clk);
    assert_equal(pwm_ref, 256);
    s_enable = 0;
    repeat(1000) @(negedge s_clk);
    assert_equal(pwm_ref, 256);
    $finish; // End simulation
end 

endmodule