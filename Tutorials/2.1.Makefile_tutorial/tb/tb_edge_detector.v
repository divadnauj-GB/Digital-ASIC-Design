`timescale 1ns / 1ps

module tb_edge_detector;

task automatic assert_equal(input [31:0] actual, input [31:0] expected);
    if(actual == expected) $display("Assertion passed: Expected %d, Actual %d.", expected, actual);
    else $error("Assertion failed: Expected %d, Actual %d.", expected, actual);
endtask

reg s_clk, s_rst_n;
reg s_input_signal;
wire s_edge_pulse;

edge_detector dut(
.clk(s_clk),
.rst_n(s_rst_n),
.input_signal(s_input_signal),
.edge_pulse(s_edge_pulse)
);

always begin
    #10 s_clk = ~s_clk;
end

initial
  begin
    $dumpfile("tb_edge_detector.vcd");
    $dumpvars;
  end

initial begin
s_clk=0;
s_rst_n=0;
s_input_signal=0;
#80 s_rst_n=1;

repeat(10) begin
    repeat(100) @(posedge s_clk);
    #1 s_input_signal = 1; // small delay to avoid race condition with clk edge 
    @(negedge s_clk);
    assert_equal(s_edge_pulse, 0);

    repeat(100) @(posedge s_clk);
    #1 s_input_signal = 0; // small delay to avoid race condition with clk edge 
    @(negedge s_clk);
    assert_equal(s_edge_pulse, 1);
end
$finish;
end

endmodule