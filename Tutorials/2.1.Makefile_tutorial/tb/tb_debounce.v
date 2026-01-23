`timescale 1ns / 1ps

module tb_debounce;

task automatic assert_equal(input [31:0] actual, input [31:0] expected);
    if(actual == expected) $display("Assertion passed: Expected %d, Actual %d.", expected, actual);
    else $error("Assertion failed: Expected %d, Actual %d.", expected, actual);
endtask

reg clk;
reg rst_n;
reg input_signal;
wire clean_signal;

debounce #(.CLK_FREQ(500))  uut (
    .clk(clk),
    .rst_n(rst_n),
    .input_signal(input_signal),
    .clean_signal(clean_signal)
);

always #10 clk = ~clk; // 50MHz clock

initial begin
    $dumpfile("tb_debounce.vcd");
    $dumpvars(0, tb_debounce);
end

initial begin
    // Initialize signals
    clk = 0;
    rst_n = 0;
    input_signal = 0;

    // Apply reset
    #20;
    rst_n = 1;

    repeat(10) @(negedge clk);
    input_signal = 1; // Simulate button press
    #30;
    input_signal = 0; // Simulate bounce
    #20;
    input_signal = 1; // Simulate stable press
    #2000;
    assert_equal(clean_signal, 1); // Expect clean signal to be high
    input_signal = 0; // Simulate button release
    #30;
    input_signal = 1; // Simulate bounce
    #20;
    input_signal = 0; // Simulate stable release
    #2000;
    assert_equal(clean_signal, 0); // Expect clean signal to be low
    $finish;
end



endmodule