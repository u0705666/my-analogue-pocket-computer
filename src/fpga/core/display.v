`default_nettype none

module display (

//
// physical connections
//

///////////////////////////////////////////////////
// clock inputs 74.25mhz. not phase aligned, so treat these domains as asynchronous

input   wire            clk_74a, // mainclk1
input   wire            clk_74b, // mainclk1 
input   wire            clk_core_12288,
input   wire            clk_core_12288_90deg,

input   wire            reset_n,
input   wire    [15:0]  cont1_key,

///////////////////////////////////////////////////
// video output to scaler
output  wire    [23:0]  video_rgb,
output  wire            video_rgb_clock,
output  wire            video_rgb_clock_90,
output  wire            video_de,
output  wire            video_skip,
output  wire            video_vs,
output  wire            video_hs,

///////////////////////////////////////////////////
// bridge bus connection
// synchronous to clk_74a
output  wire            bridge_endian_little,
input   wire    [31:0]  bridge_addr,
input   wire            bridge_rd,
output  reg     [31:0]  bridge_rd_data,
input   wire            bridge_wr,
input   wire    [31:0]  bridge_wr_data
);

	reg	[2:0]	video_channel_enable = 3'b111;
	reg			video_anim_enable = 1;
	reg			video_resetsquare;
	reg			video_resetframe;
	reg			video_incrframe;
	
	reg			video_squareposx;
	reg			video_squareposy;
	reg	[9:0]	video_square_newx;
	reg	[9:0]	video_square_newy;
	
	reg	[31:0]	signed_value;
	
	reg	[31:0]	debug_value = 32'h12005678;

    always @(posedge clk_74a) begin

        if(bridge_wr) begin
        casex(bridge_addr)
            32'h002000xx: begin
                
                casex(bridge_addr[7:0])
                8'h00: begin
                    video_square_newx <= bridge_wr_data;
                    video_squareposx <= ~video_squareposx;
                end
                8'h04: begin
                    video_square_newy <= bridge_wr_data;
                    video_squareposy <= ~video_squareposy;
                end
                endcase
            end
            32'h00F0000C: begin
                video_channel_enable <= bridge_wr_data[2:0];
            end
            32'h00100000: begin
                video_anim_enable <= bridge_wr_data[0];
            end
            32'h00100004: begin
                debug_value <= bridge_wr_data;
            end
            32'h00300000: begin
                signed_value <= bridge_wr_data;
            end
            32'h00F00010: begin
                // toggle. the other clock domain will synchronize this and detect an edge
                video_resetsquare <= ~video_resetsquare;
            end
            32'h00F00014: begin
                // toggle. the other clock domain will synchronize this and detect an edge
                video_resetframe <= ~video_resetframe;
            end
            32'h00F00018: begin
                // toggle. the other clock domain will synchronize this and detect an edge
                video_incrframe <= ~video_incrframe;
            end
            endcase
        
        
        end

    end

////////////////////////////////////////////////////////////////////////////////////////
//
// sychronizers for getting stuff from clk_74 (BRIDGE and others) into the video pixel
// clock domain (clk_core_12288/video_rgb_clock)
//
// this is very necessary and should not be neglected!
//
	wire	[2:0]	video_channel_enable_s;
	wire			video_anim_enable_s;
	wire			video_resetsquare_s;
	reg				video_resetsquare_last;
	wire			video_resetframe_s;
	reg				video_resetframe_last;
	wire			video_incrframe_s;
	reg				video_incrframe_last;
	wire			video_squareposx_s;
	reg				video_squareposx_last;
	wire			video_squareposy_s;
	reg				video_squareposy_last;
	wire	[9:0]	video_square_newx_s;
	wire	[9:0]	video_square_newy_s;
	reg				video_squareposx_nextcycle;
	reg				video_squareposy_nextcycle;
	
    synch_3_sync_output_only #(.WIDTH(3)) s1(video_channel_enable, video_channel_enable_s, video_rgb_clock);
    synch_3_sync_output_only 			 s2(video_anim_enable, video_anim_enable_s, video_rgb_clock);
    synch_3_sync_output_only 			 s3(video_resetsquare, video_resetsquare_s, video_rgb_clock);
    synch_3_sync_output_only 			 s4(video_resetframe, video_resetframe_s, video_rgb_clock);
    synch_3_sync_output_only 			 s5(video_incrframe, video_incrframe_s, video_rgb_clock);

    synch_3_sync_output_only 			 s6(video_squareposx, video_squareposx_s, video_rgb_clock);
    synch_3_sync_output_only 			 s7(video_squareposy, video_squareposy_s, video_rgb_clock);
    synch_3_sync_output_only #(.WIDTH(10)) s8(video_square_newx, video_square_newx_s, video_rgb_clock);
    synch_3_sync_output_only #(.WIDTH(10)) s9(video_square_newy, video_square_newy_s, video_rgb_clock);



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


    assign video_rgb_clock = clk_core_12288;
    assign video_rgb_clock_90 = clk_core_12288_90deg;
    assign video_rgb = vidout_rgb;
    assign video_de = vidout_de;
    assign video_skip = vidout_skip;
    assign video_vs = vidout_vs;
    assign video_hs = vidout_hs;


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
        
        reg	[15:0]	frame_count;
        
        reg	[9:0]	x_count;
        reg	[9:0]	y_count;
        
        wire [9:0]	visible_x = x_count - VID_H_BPORCH;
        wire [9:0]	visible_y = y_count - VID_V_BPORCH;

        reg	[23:0]	vidout_rgb;
        reg			vidout_de, vidout_de_1;
        reg			vidout_skip;
        reg			vidout_vs;
        reg			vidout_hs, vidout_hs_1;
        
        localparam	INIT_X = VID_H_ACTIVE / 2 - (50) / 2;
        localparam	INIT_Y = VID_V_ACTIVE / 2 - (50) / 2;
        
        reg	[9:0]	square_x = INIT_X;
        reg	[9:0]	square_y = INIT_Y;

    always @(posedge video_rgb_clock or negedge reset_n) begin

        if(~reset_n) begin
            x_count <= 0;
            y_count <= 0;
            
        end else begin
            
            vidout_de <= 0;
            vidout_skip <= 0;
            vidout_vs <= 0;
            vidout_hs <= 0;
            
            vidout_hs_1 <= vidout_hs;
            vidout_de_1 <= vidout_de;
            
            video_resetsquare_last <= video_resetsquare_s;
            video_resetframe_last <= video_resetframe_s;
            video_incrframe_last <= video_incrframe_s;
            video_squareposx_last <= video_squareposx_s;
            video_squareposy_last <= video_squareposy_s;
            
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
                    
                    // generate the sliding XOR background
                    vidout_rgb[23:16] <= (visible_x + frame_count / 1) ^ (visible_y + frame_count/1);
                    vidout_rgb[15:8]  <= (visible_x + frame_count / 2) ^ (visible_y - frame_count/2);
                    vidout_rgb[7:0]	  <= (visible_x - frame_count / 1) ^ (visible_y + 128);
                    
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
                    
                    // generate square
                    if(visible_x >= square_x && visible_x < square_x+50) begin
                        if(visible_y >= square_y && visible_y < square_y+50) begin
                            vidout_rgb <= 24'h0; 
                        end
                    end
                    if(visible_x >= square_x+1 && visible_x < square_x+50-1) begin
                        if(visible_y >= square_y+1 && visible_y < square_y+50-1) begin
                            // change color of the square based on button state.
                            // note: because the button state could change in the middle of the frame,
                            // tearing on the square color could occur, but this is normal.
                            if(cont1_key[4])	
                                vidout_rgb <= 24'hFF00FF; 
                            else if(cont1_key[5])	
                                vidout_rgb <= 24'h00FF00; 
                            else 
                                vidout_rgb <= 24'hFFFFFF; 
                        end
                    end
                    
                end 
            end
            
            if(vidout_vs) begin
                // vertical sync, new frame pulse (actually occurred on the previous cycle)
                // this will actually cause tearing but only on the upperleft-most pixel
                
                if(cont1_key[0]) begin
                    // d-pad up
                    if(square_y > 0) square_y <= square_y - 'd1;
                end
                if(cont1_key[1]) begin
                    // d-pad down
                    if(square_y < VID_V_ACTIVE-50) square_y <= square_y + 'd1;
                end
                if(cont1_key[2]) begin
                    // d-pad left
                    if(square_x > 0) square_x <= square_x - 'd1;
                end
                if(cont1_key[3]) begin
                    // d-pad right
                    if(square_x < VID_H_ACTIVE-50) square_x <= square_x + 'd1;
                end
            end
            
            // detect any edge coming from the synchronized square reset signal
            if(video_resetsquare_last != video_resetsquare_s) begin
                square_x <= INIT_X;
                square_y <= INIT_Y;
            end
            
            // detect any edge coming from the synchronized frame reset signal
            if(video_resetframe_last != video_resetframe_s) begin
                frame_count <= 0;
            end
            
            // detect any edge coming from the synchronized frame reset signal
            if(video_incrframe_last != video_incrframe_s) begin
                frame_count <= frame_count + 1'b1;
            end
            
            // detect any edge coming from the synchronized frame reset signal
            // then generate a delay signal
            if(video_squareposx_last != video_squareposx_s) begin
                video_squareposx_nextcycle <= 1;
            end else begin
                video_squareposx_nextcycle <= 0;
            end
            if(video_squareposy_last != video_squareposy_s) begin
                video_squareposy_nextcycle <= 1;
            end else begin
                video_squareposy_nextcycle <= 0;
            end
            // load the new square coordinates, but 1 cycle delayed so the 10-bit wide data
            // has settled
            if(video_squareposx_nextcycle) begin
                square_x <= video_square_newx_s;
            end
            if(video_squareposy_nextcycle) begin
                square_y <= video_square_newy_s;
            end
        end
    end
endmodule