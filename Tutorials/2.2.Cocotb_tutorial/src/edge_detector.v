`timescale 1ns / 1ps

module edge_detector (
    clk,
    rst_n,
    input_signal,
    edge_pulse
);

input clk;
input rst_n;
input input_signal;
output edge_pulse;

reg input_signal_dly;
wire edge_pulse;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        input_signal_dly <= 1'b0;
    end else begin
        input_signal_dly <= input_signal;
    end
end

assign edge_pulse = (~input_signal & input_signal_dly);

/**
`ifdef COCOTB_SIM
    initial begin
        $dumpfile("tb_edge_detector.vcd");
        $dumpvars(0, edge_detector); // Dumps all variables in the module
        #1; // Wait a little time for initial values to propagate
    end
`endif
**/
endmodule