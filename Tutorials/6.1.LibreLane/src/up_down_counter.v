// Up/Down counter core description
`timescale 1ns / 1ps

module up_down_counter(clk, rst_n, enable, inc, dec, pwm_ref);
input clk;
input rst_n;
input enable;
input inc;
input dec;
output [7:0] pwm_ref;


wire up_ndown;
wire en;

reg [7:0] counter;

assign en=enable&(inc|dec);
assign up_ndown=inc;

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        counter<=0;
    end else begin
        if (en==1'b1) begin
            if (up_ndown==1'b1) begin
                counter<=counter+1;
            end else begin
                counter<=counter-1;
            end
        end
    end 
end

assign pwm_ref=counter;

endmodule