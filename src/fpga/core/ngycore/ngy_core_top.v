`default_nettype none

module ngy_core_top (
    // Clock and reset
    input wire clk_74a,
    input wire reset_n,
    
    // Controller inputs
    input wire [15:0] cont1_key,
    
    // Video outputs
    output wire [23:0] video_rgb,
    output wire video_rgb_clock,
    output wire video_rgb_clock_90,
    output wire video_de,
    output wire video_skip,
    output wire video_vs,
    output wire video_hs,
    
    // Video control inputs
    input wire [2:0] video_channel_enable_s,
    input wire video_anim_enable_s,
    input wire video_resetframe_s,
    input wire video_incrframe_s,
    
    // Clock inputs for video
    input wire clk_core_12288,
    input wire clk_core_12288_90deg,
    
    // SRAM interface
    output wire [16:0] sram_a,
    inout wire [15:0] sram_dq,
    output wire sram_oe_n,
    output wire sram_we_n,
    output wire sram_ub_n,
    output wire sram_lb_n,
    
    // Frame count output
    output wire [15:0] frame_count_wire
);

    // Internal signals
    wire [9:0] visible_x;
    wire [9:0] visible_y;
    wire pixel_state;
    wire [15:0] frame_count;

    // Instantiate ngy_snake_top (nst1)
    ngy_snake_top nst1(
        .clk_74a(clk_74a),
        .reset_n(reset_n),
        .cont1_key(cont1_key),
        .visible_x(visible_x),
        .visible_y(visible_y),
        .pixel_state(pixel_state),
        .sram_chip_addr(sram_a),
        .sram_chip_data(sram_dq),
        .sram_chip_oe_n(sram_oe_n),
        .sram_chip_we_n(sram_we_n),
        .sram_chip_ub_n(sram_ub_n),
        .sram_chip_lb_n(sram_lb_n)
    );

    // Instantiate vga_controller (vc1)
    vga_controller vc1(
        .video_rgb(video_rgb),
        .video_rgb_clock(video_rgb_clock),
        .video_rgb_clock_90(video_rgb_clock_90),
        .video_de(video_de),
        .video_skip(video_skip),
        .video_vs(video_vs),
        .video_hs(video_hs),
        .frame_count(frame_count),
        .visible_x(visible_x),
        .visible_y(visible_y),
        .pixel_state(pixel_state),
        .clk_core_12288(clk_core_12288),
        .clk_core_12288_90(clk_core_12288_90deg),
        .reset_n(reset_n),
        .video_resetframe_s(video_resetframe_s),
        .video_incrframe_s(video_incrframe_s),
        .video_channel_enable_s(video_channel_enable_s),
        .video_anim_enable_s(video_anim_enable_s)
    );

    // Pass through frame count
    assign frame_count_wire = frame_count;

endmodule
