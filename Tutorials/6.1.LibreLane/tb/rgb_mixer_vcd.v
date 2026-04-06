module rgb_mixer_vcd();
initial begin
    $dumpfile("sim_build/rgb_mixer.vcd");
    $dumpvars(0, rgb_mixer);
end
endmodule
