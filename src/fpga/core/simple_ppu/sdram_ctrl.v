`default_nettype none

module simple_ppu_sdram_ctrl (
    input   wire            reset_n,

    input   wire            clk_video,
    input   wire            clk_ram_controller,
    input   wire            clk_ram_chip,
    input   wire            clk_ram_90,

    input   wire            display_enable,

    input   wire            word_rd,
    input   wire            word_wr,
    input   wire    [23:0]  word_addr,
    input   wire    [31:0]  word_data,
    output  wire    [31:0]  word_q,
    output  wire            word_busy,

    output  wire    [23:0]  video_rgb,
    output  wire            video_de,
    output  wire            video_skip,
    output  wire            video_vs,
    output  wire            video_hs,

    output  wire    [12:0]  dram_a,
    output  wire    [1:0]   dram_ba,
    inout   wire    [15:0]  dram_dq,
    output  wire    [1:0]   dram_dqm,
    output  wire            dram_clk,
    output  wire            dram_cke,
    output  wire            dram_ras_n,
    output  wire            dram_cas_n,
    output  wire            dram_we_n
);

localparam [9:0] VID_V_BPORCH = 10'd10;
localparam [9:0] VID_V_ACTIVE = 10'd288;
localparam [9:0] VID_V_TOTAL  = 10'd512;
localparam [9:0] VID_H_BPORCH = 10'd10;
localparam [9:0] VID_H_ACTIVE = 10'd320;
localparam [9:0] VID_H_TOTAL  = 10'd400;
localparam [24:0] FB_BASE_BURST_ADDR = 25'h080000;

reg [9:0] x_count;
reg [9:0] y_count;
reg [23:0] vidout_rgb;
reg        vidout_de;
reg        vidout_skip;
reg        vidout_vs;
reg        vidout_hs;
assign video_rgb = vidout_rgb;
assign video_de = vidout_de;
assign video_skip = vidout_skip;
assign video_vs = vidout_vs;
assign video_hs = vidout_hs;

reg next_line;
reg new_frame;
reg linebuf_toggle;
reg [9:0] linebuf_rdaddr;
wire [10:0] linebuf_rdaddr_fix = (linebuf_toggle ? linebuf_rdaddr : (linebuf_rdaddr + 10'd1024));
wire [15:0] linebuf_q;

always @(posedge clk_video or negedge reset_n) begin
    if(!reset_n) begin
        x_count <= 10'd0;
        y_count <= 10'd0;
        vidout_rgb <= 24'd0;
        vidout_de <= 1'b0;
        vidout_skip <= 1'b0;
        vidout_vs <= 1'b0;
        vidout_hs <= 1'b0;
        new_frame <= 1'b0;
        next_line <= 1'b0;
        linebuf_toggle <= 1'b0;
        linebuf_rdaddr <= 10'd0;
    end else begin
        vidout_de <= 1'b0;
        vidout_skip <= 1'b0;
        vidout_vs <= 1'b0;
        vidout_hs <= 1'b0;
        new_frame <= 1'b0;
        next_line <= 1'b0;

        x_count <= x_count + 10'd1;
        if(x_count == VID_H_TOTAL-1) begin
            x_count <= 10'd0;
            y_count <= y_count + 10'd1;
            if(y_count == VID_V_TOTAL-1) y_count <= 10'd0;
        end

        if(x_count == 10'd0 && y_count == 10'd0) begin
            vidout_vs <= 1'b1;
            new_frame <= 1'b1;
        end
        if(x_count == 10'd3) begin
            vidout_hs <= 1'b1;
            if(y_count >= VID_V_BPORCH-1 && y_count < VID_V_BPORCH+VID_V_ACTIVE) begin
                next_line <= 1'b1;
                linebuf_toggle <= ~linebuf_toggle;
            end
        end

        if(x_count >= VID_H_BPORCH-1) linebuf_rdaddr <= linebuf_rdaddr + 10'd1;
        else linebuf_rdaddr <= 10'd0;

        vidout_rgb <= 24'h0;
        if(display_enable &&
           x_count >= VID_H_BPORCH && x_count < VID_H_BPORCH + VID_H_ACTIVE &&
           y_count >= VID_V_BPORCH && y_count < VID_V_BPORCH + VID_V_ACTIVE) begin
            vidout_de <= 1'b1;
            vidout_rgb[23:16] <= {linebuf_q[15:11], linebuf_q[15:13]};
            vidout_rgb[15:8]  <= {linebuf_q[10:5], linebuf_q[10:9]};
            vidout_rgb[7:0]   <= {linebuf_q[4:0], linebuf_q[4:2]};
        end
    end
end

wire next_line_s;
wire new_frame_s;
wire linebuf_toggle_s;
wire display_enable_s;
synch_3 s0(next_line, next_line_s, clk_ram_controller);
synch_3 s1(new_frame, new_frame_s, clk_ram_controller);
synch_3 s2(linebuf_toggle, linebuf_toggle_s, clk_ram_controller);
synch_3 s3(display_enable, display_enable_s, clk_ram_controller);

reg [9:0] linebuf_wraddr;
wire [10:0] linebuf_wraddr_fix = (linebuf_toggle_s ? (linebuf_wraddr + 10'd1024) : linebuf_wraddr);
reg [15:0] linebuf_data;
reg        linebuf_wren;

mf_linebuf mf_linebuf_inst (
    .rdclock    ( clk_video ),
    .rdaddress  ( linebuf_rdaddr_fix ),
    .q          ( linebuf_q ),
    .wrclock    ( clk_ram_controller ),
    .wraddress  ( linebuf_wraddr_fix ),
    .data       ( linebuf_data ),
    .wren       ( linebuf_wren )
);

reg             burst_rd;
reg     [24:0]  burst_addr;
reg     [10:0]  burst_len;
reg             burst_32bit;
wire    [31:0]  burst_data;
wire            burst_data_valid;
wire            burst_data_done;

wire            burstwr;
wire    [24:0]  burstwr_addr;
wire            burstwr_ready;
wire            burstwr_strobe;
wire    [15:0]  burstwr_data;
wire            burstwr_done;

reg [3:0] rr_state;
reg [10:0] rr_line;
localparam RR_IDLE = 4'd0;
localparam RR_WAIT = 4'd1;
localparam RR_READ = 4'd2;

always @(posedge clk_ram_controller or negedge reset_n) begin
    if(!reset_n) begin
        rr_state <= RR_IDLE;
        rr_line <= 11'd0;
        burst_rd <= 1'b0;
        burst_addr <= 25'd0;
        burst_len <= 11'd0;
        burst_32bit <= 1'b0;
        linebuf_wren <= 1'b0;
        linebuf_wraddr <= 10'd0;
        linebuf_data <= 16'd0;
    end else begin
        burst_rd <= 1'b0;
        linebuf_wren <= 1'b0;
        case(rr_state)
        RR_IDLE: rr_state <= RR_WAIT;
        RR_WAIT: begin
            if(new_frame_s) rr_line <= 11'd0;
            if(next_line_s && display_enable_s) begin
                rr_line <= rr_line + 11'd1;
                burst_rd <= 1'b1;
                burst_addr <= FB_BASE_BURST_ADDR + (rr_line * VID_H_ACTIVE);
                burst_len <= 11'd1024;
                burst_32bit <= 1'b0;
                linebuf_wraddr <= 10'h3ff;
                rr_state <= RR_READ;
            end
        end
        RR_READ: begin
            if(burst_data_valid) begin
                linebuf_data <= burst_data[15:0];
                linebuf_wraddr <= linebuf_wraddr + 10'd1;
                linebuf_wren <= 1'b1;
            end
            if(burst_data_done) rr_state <= RR_WAIT;
        end
        default: rr_state <= RR_IDLE;
        endcase
    end
end

io_sdram sdram_inst (
    .controller_clk     ( clk_ram_controller ),
    .chip_clk           ( clk_ram_chip ),
    .clk_90             ( clk_ram_90 ),
    .reset_n            ( 1'b1 ),
    .phy_cke            ( dram_cke ),
    .phy_clk            ( dram_clk ),
    .phy_cas            ( dram_cas_n ),
    .phy_ras            ( dram_ras_n ),
    .phy_we             ( dram_we_n ),
    .phy_ba             ( dram_ba ),
    .phy_a              ( dram_a ),
    .phy_dq             ( dram_dq ),
    .phy_dqm            ( dram_dqm ),

    .burst_rd           ( burst_rd ),
    .burst_addr         ( burst_addr ),
    .burst_len          ( burst_len ),
    .burst_32bit        ( burst_32bit ),
    .burst_data         ( burst_data ),
    .burst_data_valid   ( burst_data_valid ),
    .burst_data_done    ( burst_data_done ),

    .burstwr            ( burstwr ),
    .burstwr_addr       ( burstwr_addr ),
    .burstwr_ready      ( burstwr_ready ),
    .burstwr_strobe     ( burstwr_strobe ),
    .burstwr_data       ( burstwr_data ),
    .burstwr_done       ( burstwr_done ),

    .word_rd            ( word_rd ),
    .word_wr            ( word_wr ),
    .word_addr          ( word_addr ),
    .word_data          ( word_data ),
    .word_q             ( word_q ),
    .word_busy          ( word_busy )
);

endmodule
