`timescale 1ns / 1ps
module my_design (
    clk,
    reset,
    count
);
    input clk;
    input reset;
    output reg [7:0] count;

  always @(posedge clk or negedge reset) begin
    if (!reset) begin
      count <= 8'd0;
    end else begin
      count <= count + 1'b1;
    end
  end

  /**
  `ifdef COCOTB_SIM
    initial begin
        $dumpfile("my_design.vcd");
        $dumpvars(0, my_design); // Dumps all variables in the module
        #1; // Wait a little time for initial values to propagate
    end
  `endif
  **/
endmodule