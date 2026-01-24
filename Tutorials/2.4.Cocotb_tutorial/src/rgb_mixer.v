`timescale 1ns / 1ps

module rgb_mixer #(
parameter CLK_FREQ=50000000,
parameter PWM_FREQ=10000,
parameter DEBOUNCE_FREQ=100000
)(clk, rst_n, inc, dec, led, PWM0, PWM1, PWM2);
input clk;
input rst_n;
input inc;
input dec;
input [1:0] led;
output PWM0;
output PWM1;
output PWM2;

localparam PERIOD_VAL=CLK_FREQ/PWM_FREQ;
localparam N_FILL=$clog2(PERIOD_VAL)-8;

wire clean_inc;
wire clean_dec;
wire pulse_inc;
wire pulse_dec;

reg PWM0_enable;
reg PWM1_enable;
reg PWM2_enable;

wire [7:0] pwm_ref_0;
wire [7:0] pwm_ref_1;
wire [7:0] pwm_ref_2;

wire [$clog2(PERIOD_VAL)-1:0] pwm_ref_0_ext;
wire [$clog2(PERIOD_VAL)-1:0] pwm_ref_1_ext;
wire [$clog2(PERIOD_VAL)-1:0] pwm_ref_2_ext;


//assign pwm_ref_0_ext=

debounce #(.DEBOUNCE_FREQ(DEBOUNCE_FREQ))
    inc_debounce(
    .clk(clk),
    .rst_n(rst_n),
    .input_signal(inc),
    .clean_signal(clean_inc)
);

debounce #(.DEBOUNCE_FREQ(DEBOUNCE_FREQ)) 
    dec_debounce(
    .clk(clk),
    .rst_n(rst_n),
    .input_signal(dec),
    .clean_signal(clean_dec)
);


edge_detector inc_edge(
.clk(clk),
.rst_n(rst_n),
.input_signal(clean_inc),
.edge_pulse(pulse_inc)
);

edge_detector dec_edge(
.clk(clk),
.rst_n(rst_n),
.input_signal(clean_dec),
.edge_pulse(pulse_dec)
);

up_down_counter PMW0_ref (
    .clk(clk),
    .rst_n(rst_n),
    .enable(PWM0_enable),
    .inc(pulse_inc),
    .dec(pulse_dec),
    .pwm_ref(pwm_ref_0)
);

up_down_counter PMW1_ref (
    .clk(clk),
    .rst_n(rst_n),
    .enable(PWM1_enable),
    .inc(pulse_inc),
    .dec(pulse_dec),
    .pwm_ref(pwm_ref_1)
);

up_down_counter PMW2_ref (
    .clk(clk),
    .rst_n(rst_n),
    .enable(PWM2_enable),
    .inc(pulse_inc),
    .dec(pulse_dec),
    .pwm_ref(pwm_ref_2)
);


PWM #(.CLK_FREQ(CLK_FREQ),
    .PWM_FREQ(PWM_FREQ)
    ) PWM0_inst(
    .clk(clk),
    .rst_n(rst_n),
    .pwm_ref({pwm_ref_0,{N_FILL{pwm_ref_0[0]}}}),
    .pwm(PWM0)
    );

PWM #(.CLK_FREQ(CLK_FREQ),
    .PWM_FREQ(PWM_FREQ)
    ) PWM1_inst(
    .clk(clk),
    .rst_n(rst_n),
    .pwm_ref({pwm_ref_1,{N_FILL{pwm_ref_1[0]}}}),
    .pwm(PWM1)
    );

PWM #(.CLK_FREQ(CLK_FREQ),
    .PWM_FREQ(PWM_FREQ)
    ) PWM2_inst(
    .clk(clk),
    .rst_n(rst_n),
    .pwm_ref({pwm_ref_2,{N_FILL{pwm_ref_2[0]}}}),
    .pwm(PWM2)
    );

always @(*) begin
    case (led)
        2'b00 : {PWM2_enable, PWM1_enable, PWM0_enable} = 3'b001;
        2'b01 : {PWM2_enable, PWM1_enable, PWM0_enable} = 3'b010;
        2'b10 : {PWM2_enable, PWM1_enable, PWM0_enable} = 3'b100;
        2'b11 : {PWM2_enable, PWM1_enable, PWM0_enable} = 3'b000;
        default: {PWM2_enable, PWM1_enable, PWM0_enable} = 3'b000;
    endcase
end

/**
`ifdef COCOTB_SIM
    initial begin
        $dumpfile("tb_rgb_mixer.vcd");
        $dumpvars(0, rgb_mixer); // Dumps all variables in the module
        #1; // Wait a little time for initial values to propagate
    end
  `endif
**/
endmodule