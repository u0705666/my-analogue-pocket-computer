`timescale 1ns / 1ns

module display_tb;

    //input
    reg clk_74a;
    reg clk_74b;
    reg clk_core_12288;
    reg clk_core_12288_90deg;
    reg reset_n;
    reg [15:0] cont1_key;

    reg [31:0] bridge_addr;
    reg bridge_wr;
    reg [31:0] bridge_wr_data;

    //output
    reg [23:0] video_rgb;
    reg video_rgb_clock;
    reg video_rgb_clock_90;
    reg video_de;
    reg video_skip;
    reg video_vs;
    reg video_hs;

    display dut(
        .clk_74a(clk_74a),
        .clk_74b(clk_74b),
        .clk_core_12288(clk_core_12288),
        .clk_core_12288_90deg(clk_core_12288_90deg),
        .reset_n(reset_n),
        .cont1_key(cont1_key),
        .bridge_addr(bridge_addr),
        .bridge_wr(bridge_wr),
        .bridge_wr_data(bridge_wr_data),
        .video_rgb(video_rgb),
        .video_rgb_clock(video_rgb_clock),
        .video_rgb_clock_90(video_rgb_clock_90),
        .video_de(video_de),
        .video_skip(video_skip),
        .video_vs(video_vs),
        .video_hs(video_hs)
    );

    initial begin
        $dumpfile("display_tb.vcd");
        $dumpvars(0,display_tb);
    end

    initial begin
       clk_74a = 0;
       forever #1 clk_74a = ~clk_74a;
    end

    initial begin
       clk_core_12288 = 0;
       forever #1 clk_core_12288 = ~clk_core_12288;
    end

    initial begin
        reset_n = 0;
        #5; reset_n = 1;
        #10000 $stop;
    end

endmodule