`default_nettype none

module vga_controller(
    output wire [23:0] video_rgb,
    output wire video_rgb_clock,
    output wire video_rgb_clock_90,
    output wire video_de,
    output wire video_skip,
    output wire video_vs,
    output wire video_hs,
    output reg [15:0] frame_count,
    output wire [9:0] visible_x,
    output wire [9:0] visible_y,
    input wire pixel_state,
    input wire clk_core_12288,  
    input wire clk_core_12288_90,
    input wire reset_n,
    input wire video_resetframe_s,
    input wire video_incrframe_s,
    input wire [2:0] video_channel_enable_s,
    input wire video_anim_enable_s
);

// video generation
// ~12,288,000 hz pixel clock
//
// we want our video mode of 320x240 @ 60hz, this results in 204800 clocks per frame
// we need to add hblank and vblank times to this, so there will be a nondisplay area. 
// it can be thought of as a border around the visible area.
// to make numbers simple, we can have 400 total clocks per line, and 320 visible.
// dividing 204800 by 400 results in 512 total lines per frame, and 240 visible.
// this pixel clock is fairly high for the relatively low resolution, but that's fine.
// PLL output has a minimum output frequency anyway.

// horizontal back porch: 10
// horizontal active: 320
// horizontal front porch: 70

// vertical back porch: 10
// vertical active: 240
// vertical front porch: 262

localparam	VID_V_BPORCH = 'd10;
localparam	VID_V_ACTIVE = 'd288;
localparam	VID_V_TOTAL = 'd512;
localparam	VID_H_BPORCH = 'd10;
localparam	VID_H_ACTIVE = 'd320;
localparam	VID_H_TOTAL = 'd400;


reg	[9:0]	x_count;
reg	[9:0]	y_count;

reg	[23:0]	vidout_rgb;
reg			vidout_de, vidout_de_1;
reg			vidout_skip;
reg			vidout_vs;
reg			vidout_hs, vidout_hs_1;

reg				video_resetframe_last;
reg				video_incrframe_last;

assign video_rgb_clock = clk_core_12288;
assign video_rgb_clock_90 = clk_core_12288_90;

assign video_rgb_clock = clk_core_12288;
assign video_rgb_clock_90 = clk_core_12288_90;
assign video_rgb = vidout_rgb;
assign video_de = vidout_de;
assign video_skip = vidout_skip;
assign video_vs = vidout_vs;
assign video_hs = vidout_hs;


assign visible_x = x_count - VID_H_BPORCH;
assign visible_y = y_count - VID_V_BPORCH;

always @(posedge clk_core_12288 or negedge reset_n) begin
    if(~reset_n) begin
        x_count <= 0;
        y_count <= 0;
    end else begin
        vidout_de <= 0;
        vidout_skip <= 0;
        vidout_vs <= 0;
        vidout_hs <= 0;

        vidout_de_1 <= vidout_de;
        vidout_hs_1 <= vidout_hs;

        video_resetframe_last <= video_resetframe_s;
        video_incrframe_last <= video_incrframe_s;

		// x and y counters
		x_count <= x_count + 1'b1;
		if(x_count == VID_H_TOTAL-1) begin
			x_count <= 0;
			
			y_count <= y_count + 1'b1;
			if(y_count == VID_V_TOTAL-1) begin
				y_count <= 0;
			end
		end

		// generate sync 
		if(x_count == 0 && y_count == 0) begin
			// sync signal in back porch
			// new frame
			vidout_vs <= 1;
			
			if(video_anim_enable_s) begin
				frame_count <= frame_count + 1'b1;
			end
		end

        		// we want HS to occur a bit after VS, not on the same cycle
		if(x_count == 3) begin
			// sync signal in back porch
			// new line
			vidout_hs <= 1;
		end

		// inactive screen areas are black
		vidout_rgb <= 24'h0;

		// generate active video
		if(x_count >= VID_H_BPORCH && x_count < VID_H_ACTIVE+VID_H_BPORCH) begin

			if(y_count >= VID_V_BPORCH && y_count < VID_V_ACTIVE+VID_V_BPORCH) begin
				// data enable. this is the active region of the line
				vidout_de <= 1;
				
				// blank out background channels if they are masked
				if(~video_channel_enable_s[2]) vidout_rgb[23:16] <= 0;
				if(~video_channel_enable_s[1]) vidout_rgb[15:8] <= 0;
				if(~video_channel_enable_s[0]) vidout_rgb[7:0] <= 0;
				
				// add colored borders for debugging
				if(visible_x == 0) begin
					vidout_rgb <= 24'hFFFFFF;
				end else if(visible_x == VID_H_ACTIVE-1) begin
					vidout_rgb <= 24'h00FF00;
				end else if(visible_y == 0) begin
					vidout_rgb <= 24'hFF0000;
				end else if(visible_y == VID_V_ACTIVE-1) begin
					vidout_rgb <= 24'h0000FF;
				end
				
				vidout_rgb <= (pixel_state == 1'b1) ? 24'hFFFFFF : 24'h000000;
				
			end 
		end
		
		// detect any edge coming from the synchronized frame reset signal
		if(video_resetframe_last != video_resetframe_s) begin
			frame_count <= 0;
		end
		
		// detect any edge coming from the synchronized frame reset signal
		if(video_incrframe_last != video_incrframe_s) begin
			frame_count <= frame_count + 1'b1;
		end
    end
end

endmodule