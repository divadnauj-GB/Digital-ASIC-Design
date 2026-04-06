// PWM core description
`timescale 1ns / 1ps

module PWM #(parameter CLK_FREQ=50000000, parameter PWM_FREQ=10000, parameter PERIOD_VAL=CLK_FREQ/PWM_FREQ)
(clk, rst_n, pwm_ref, pwm);
input clk;
input rst_n;
input [$clog2(PERIOD_VAL)-1:0] pwm_ref;
output pwm;


reg [$clog2(PERIOD_VAL)-1:0] counter;
reg pwm_reg;
reg [$clog2(PERIOD_VAL)-1:0] pwm_ref_reg;


always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
    end else begin
        if ((counter==PERIOD_VAL)) begin
            counter <= 0;
            pwm_ref_reg <= pwm_ref;
        end else begin
            counter <= counter + 1;
        end 
    end 
end

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        pwm_reg <= 0;
    end else begin
        if (counter<pwm_ref_reg) begin
            pwm_reg <= 1'b1;
        end else begin
            pwm_reg <= 1'b0;
        end 
    end 
end 

assign pwm = pwm_reg;
endmodule