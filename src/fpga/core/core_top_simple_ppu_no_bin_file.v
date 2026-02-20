`default_nettype none

module core_top_simple_ppu_no_bin_file (
input   wire            clk_74a,
input   wire            clk_74b,
inout   wire    [7:0]   cart_tran_bank2,
output  wire            cart_tran_bank2_dir,
inout   wire    [7:0]   cart_tran_bank3,
output  wire            cart_tran_bank3_dir,
inout   wire    [7:0]   cart_tran_bank1,
output  wire            cart_tran_bank1_dir,
inout   wire    [7:4]   cart_tran_bank0,
output  wire            cart_tran_bank0_dir,
inout   wire            cart_tran_pin30,
output  wire            cart_tran_pin30_dir,
output  wire            cart_pin30_pwroff_reset,
inout   wire            cart_tran_pin31,
output  wire            cart_tran_pin31_dir,
input   wire            port_ir_rx,
output  wire            port_ir_tx,
output  wire            port_ir_rx_disable,
inout   wire            port_tran_si,
output  wire            port_tran_si_dir,
inout   wire            port_tran_so,
output  wire            port_tran_so_dir,
inout   wire            port_tran_sck,
output  wire            port_tran_sck_dir,
inout   wire            port_tran_sd,
output  wire            port_tran_sd_dir,
output  wire    [21:16] cram0_a,
inout   wire    [15:0]  cram0_dq,
input   wire            cram0_wait,
output  wire            cram0_clk,
output  wire            cram0_adv_n,
output  wire            cram0_cre,
output  wire            cram0_ce0_n,
output  wire            cram0_ce1_n,
output  wire            cram0_oe_n,
output  wire            cram0_we_n,
output  wire            cram0_ub_n,
output  wire            cram0_lb_n,
output  wire    [21:16] cram1_a,
inout   wire    [15:0]  cram1_dq,
input   wire            cram1_wait,
output  wire            cram1_clk,
output  wire            cram1_adv_n,
output  wire            cram1_cre,
output  wire            cram1_ce0_n,
output  wire            cram1_ce1_n,
output  wire            cram1_oe_n,
output  wire            cram1_we_n,
output  wire            cram1_ub_n,
output  wire            cram1_lb_n,
output  wire    [12:0]  dram_a,
output  wire    [1:0]   dram_ba,
inout   wire    [15:0]  dram_dq,
output  wire    [1:0]   dram_dqm,
output  wire            dram_clk,
output  wire            dram_cke,
output  wire            dram_ras_n,
output  wire            dram_cas_n,
output  wire            dram_we_n,
output  wire    [16:0]  sram_a,
inout   wire    [15:0]  sram_dq,
output  wire            sram_oe_n,
output  wire            sram_we_n,
output  wire            sram_ub_n,
output  wire            sram_lb_n,
input   wire            vblank,
output  wire            dbg_tx,
input   wire            dbg_rx,
output  wire            user1,
input   wire            user2,
inout   wire            aux_sda,
output  wire            aux_scl,
output  wire            vpll_feed,
output  wire    [23:0]  video_rgb,
output  wire            video_rgb_clock,
output  wire            video_rgb_clock_90,
output  wire            video_de,
output  wire            video_skip,
output  wire            video_vs,
output  wire            video_hs,
output  wire            audio_mclk,
input   wire            audio_adc,
output  wire            audio_dac,
output  wire            audio_lrck,
output  wire            bridge_endian_little,
input   wire    [31:0]  bridge_addr,
input   wire            bridge_rd,
output  reg     [31:0]  bridge_rd_data,
input   wire            bridge_wr,
input   wire    [31:0]  bridge_wr_data,
input   wire    [15:0]  cont1_key,
input   wire    [15:0]  cont2_key,
input   wire    [15:0]  cont3_key,
input   wire    [15:0]  cont4_key,
input   wire    [31:0]  cont1_joy,
input   wire    [31:0]  cont2_joy,
input   wire    [31:0]  cont3_joy,
input   wire    [31:0]  cont4_joy,
input   wire    [15:0]  cont1_trig,
input   wire    [15:0]  cont2_trig,
input   wire    [15:0]  cont3_trig,
input   wire    [15:0]  cont4_trig
);

localparam [7:0] OP_CLEAR = 8'h01;
localparam [7:0] OP_PLOT  = 8'h02;
localparam [7:0] OP_LINE  = 8'h03;
localparam [7:0] OP_RECT  = 8'h04;
localparam [7:0] OP_END   = 8'hFF;
localparam integer CMD_WORD_COUNT = 25;

assign port_ir_tx = 1'b0;
assign port_ir_rx_disable = 1'b1;
assign bridge_endian_little = 1'b0;

assign cart_tran_bank3 = 8'hzz;
assign cart_tran_bank3_dir = 1'b0;
assign cart_tran_bank2 = 8'hzz;
assign cart_tran_bank2_dir = 1'b0;
assign cart_tran_bank1 = 8'hzz;
assign cart_tran_bank1_dir = 1'b0;
assign cart_tran_bank0 = 4'hf;
assign cart_tran_bank0_dir = 1'b1;
assign cart_tran_pin30 = 1'b0;
assign cart_tran_pin30_dir = 1'bz;
assign cart_pin30_pwroff_reset = 1'b0;
assign cart_tran_pin31 = 1'bz;
assign cart_tran_pin31_dir = 1'b0;

assign port_tran_so = 1'bz;
assign port_tran_so_dir = 1'b0;
assign port_tran_si = 1'bz;
assign port_tran_si_dir = 1'b0;
assign port_tran_sck = 1'bz;
assign port_tran_sck_dir = 1'b0;
assign port_tran_sd = 1'bz;
assign port_tran_sd_dir = 1'b0;

assign cram0_a = 'h0;
assign cram0_dq = {16{1'bZ}};
assign cram0_clk = 1'b0;
assign cram0_adv_n = 1'b1;
assign cram0_cre = 1'b0;
assign cram0_ce0_n = 1'b1;
assign cram0_ce1_n = 1'b1;
assign cram0_oe_n = 1'b1;
assign cram0_we_n = 1'b1;
assign cram0_ub_n = 1'b1;
assign cram0_lb_n = 1'b1;

assign cram1_a = 'h0;
assign cram1_dq = {16{1'bZ}};
assign cram1_clk = 1'b0;
assign cram1_adv_n = 1'b1;
assign cram1_cre = 1'b0;
assign cram1_ce0_n = 1'b1;
assign cram1_ce1_n = 1'b1;
assign cram1_oe_n = 1'b1;
assign cram1_we_n = 1'b1;
assign cram1_ub_n = 1'b1;
assign cram1_lb_n = 1'b1;

assign sram_a = 'h0;
assign sram_dq = {16{1'bZ}};
assign sram_oe_n = 1'b1;
assign sram_we_n = 1'b1;
assign sram_ub_n = 1'b1;
assign sram_lb_n = 1'b1;

assign dbg_tx = 1'bZ;
assign user1 = 1'bZ;
assign aux_scl = 1'bZ;
assign vpll_feed = 1'bZ;

assign audio_mclk = 1'b0;
assign audio_dac = 1'b0;
assign audio_lrck = 1'b0;

wire clk_core_12288;
wire clk_core_12288_90deg;
wire clk_ram_controller;
wire clk_ram_chip;
wire clk_ram_90;
wire pll_core_locked;

mf_pllbase pll_i (
    .refclk     ( clk_74a ),
    .rst        ( 1'b0 ),
    .outclk_0   ( clk_core_12288 ),
    .outclk_1   ( clk_core_12288_90deg ),
    .outclk_2   ( clk_ram_controller ),
    .outclk_3   ( clk_ram_chip ),
    .outclk_4   ( clk_ram_90 ),
    .locked     ( pll_core_locked )
);

assign video_rgb_clock = clk_core_12288;
assign video_rgb_clock_90 = clk_core_12288_90deg;

wire reset_n;
wire [31:0] cmd_bridge_rd_data;
wire status_boot_done = pll_core_locked;
wire status_setup_done = pll_core_locked;
wire status_running = reset_n;
wire dataslot_requestread;
wire [15:0] dataslot_requestread_id;
wire dataslot_requestread_ack = 1'b1;
wire dataslot_requestread_ok = 1'b1;
wire dataslot_requestwrite;
wire [15:0] dataslot_requestwrite_id;
wire dataslot_requestwrite_ack = 1'b1;
wire dataslot_requestwrite_ok = 1'b1;
wire dataslot_allcomplete;
wire osnotify_inmenu;
wire [9:0] datatable_addr;
wire datatable_wren;
wire [31:0] datatable_data;
wire [31:0] datatable_q;

core_bridge_cmd bridge_cmd_i (
    .clk                    ( clk_74a ),
    .reset_n                ( reset_n ),
    .bridge_endian_little   ( bridge_endian_little ),
    .bridge_addr            ( bridge_addr ),
    .bridge_rd              ( bridge_rd ),
    .bridge_rd_data         ( cmd_bridge_rd_data ),
    .bridge_wr              ( bridge_wr ),
    .bridge_wr_data         ( bridge_wr_data ),
    .status_boot_done       ( status_boot_done ),
    .status_setup_done      ( status_setup_done ),
    .status_running         ( status_running ),
    .dataslot_requestread       ( dataslot_requestread ),
    .dataslot_requestread_id    ( dataslot_requestread_id ),
    .dataslot_requestread_ack   ( dataslot_requestread_ack ),
    .dataslot_requestread_ok    ( dataslot_requestread_ok ),
    .dataslot_requestwrite      ( dataslot_requestwrite ),
    .dataslot_requestwrite_id   ( dataslot_requestwrite_id ),
    .dataslot_requestwrite_ack  ( dataslot_requestwrite_ack ),
    .dataslot_requestwrite_ok   ( dataslot_requestwrite_ok ),
    .dataslot_allcomplete   ( dataslot_allcomplete ),
    .savestate_supported    ( 1'b0 ),
    .savestate_addr         ( 32'd0 ),
    .savestate_size         ( 32'd0 ),
    .savestate_maxloadsize  ( 32'd0 ),
    .osnotify_inmenu        ( osnotify_inmenu ),
    .savestate_start        ( ),
    .savestate_start_ack    ( 1'b0 ),
    .savestate_start_busy   ( 1'b0 ),
    .savestate_start_ok     ( 1'b0 ),
    .savestate_start_err    ( 1'b0 ),
    .savestate_load         ( ),
    .savestate_load_ack     ( 1'b0 ),
    .savestate_load_busy    ( 1'b0 ),
    .savestate_load_ok      ( 1'b0 ),
    .savestate_load_err     ( 1'b0 ),
    .datatable_addr         ( datatable_addr ),
    .datatable_wren         ( datatable_wren ),
    .datatable_data         ( datatable_data ),
    .datatable_q            ( datatable_q )
);

wire [31:0] ram_word_q;
wire        ram_word_busy;
reg         word_rd_mux;
reg         word_wr_mux;
reg  [23:0] word_addr_mux;
reg  [31:0] word_data_mux;

reg display_enable;

simple_ppu_sdram_ctrl sdram_ctrl_i (
    .reset_n            ( reset_n ),
    .clk_video          ( clk_core_12288 ),
    .clk_ram_controller ( clk_ram_controller ),
    .clk_ram_chip       ( clk_ram_chip ),
    .clk_ram_90         ( clk_ram_90 ),
    .display_enable     ( display_enable ),
    .word_rd            ( word_rd_mux ),
    .word_wr            ( word_wr_mux ),
    .word_addr          ( word_addr_mux ),
    .word_data          ( word_data_mux ),
    .word_q             ( ram_word_q ),
    .word_busy          ( ram_word_busy ),
    .video_rgb          ( video_rgb ),
    .video_de           ( video_de ),
    .video_skip         ( video_skip ),
    .video_vs           ( video_vs ),
    .video_hs           ( video_hs ),
    .dram_a             ( dram_a ),
    .dram_ba            ( dram_ba ),
    .dram_dq            ( dram_dq ),
    .dram_dqm           ( dram_dqm ),
    .dram_clk           ( dram_clk ),
    .dram_cke           ( dram_cke ),
    .dram_ras_n         ( dram_ras_n ),
    .dram_cas_n         ( dram_cas_n ),
    .dram_we_n          ( dram_we_n )
);

reg         ppu_start;
reg  [7:0]  ppu_opcode;
reg  [31:0] ppu_arg0, ppu_arg1, ppu_arg2, ppu_arg3, ppu_arg4, ppu_arg5, ppu_arg6;
wire        ppu_busy;
wire        ppu_done;
wire        ppu_mem_word_rd;
wire        ppu_mem_word_wr;
wire [23:0] ppu_mem_word_addr;
wire [31:0] ppu_mem_word_data;

simple_ppu_ppu ppu_i (
    .clk            ( clk_74a ),
    .reset_n        ( reset_n ),
    .start          ( ppu_start ),
    .opcode         ( ppu_opcode ),
    .arg0           ( ppu_arg0 ),
    .arg1           ( ppu_arg1 ),
    .arg2           ( ppu_arg2 ),
    .arg3           ( ppu_arg3 ),
    .arg4           ( ppu_arg4 ),
    .arg5           ( ppu_arg5 ),
    .arg6           ( ppu_arg6 ),
    .busy           ( ppu_busy ),
    .done           ( ppu_done ),
    .mem_word_rd    ( ppu_mem_word_rd ),
    .mem_word_wr    ( ppu_mem_word_wr ),
    .mem_word_addr  ( ppu_mem_word_addr ),
    .mem_word_data  ( ppu_mem_word_data ),
    .mem_word_q     ( ram_word_q ),
    .mem_word_busy  ( ram_word_busy )
);

(* ramstyle = "M10K" *) reg [31:0] cmd_rom [0:63];
reg [5:0] rom_addr;
reg [31:0] rom_q;
integer i;
initial begin
    for(i = 0; i < 64; i = i + 1) cmd_rom[i] = {OP_END, 24'd0};
    cmd_rom[0]  = {OP_CLEAR, 24'd0};  cmd_rom[1]  = 32'h00000010;
    cmd_rom[2]  = {OP_LINE, 24'd0};   cmd_rom[3]  = 32'd40;  cmd_rom[4]  = 32'd40;  cmd_rom[5]  = 32'd280; cmd_rom[6]  = 32'd40;  cmd_rom[7]  = 32'h0000FFFF;
    cmd_rom[8]  = {OP_LINE, 24'd0};   cmd_rom[9]  = 32'd280; cmd_rom[10] = 32'd40;  cmd_rom[11] = 32'd160; cmd_rom[12] = 32'd240; cmd_rom[13] = 32'h0000F800;
    cmd_rom[14] = {OP_LINE, 24'd0};   cmd_rom[15] = 32'd160; cmd_rom[16] = 32'd240; cmd_rom[17] = 32'd40;  cmd_rom[18] = 32'd40;  cmd_rom[19] = 32'h000007E0;
    cmd_rom[20] = {OP_PLOT, 24'd0};   cmd_rom[21] = 32'd160; cmd_rom[22] = 32'd144; cmd_rom[23] = 32'h0000001F;
    cmd_rom[24] = {OP_END, 24'd0};
end
always @(posedge clk_74a) begin
    rom_q <= cmd_rom[rom_addr];
end

localparam [7:0]
    ST_IDLE = 8'd0,
    ST_FETCH_OP_REQ = 8'd1,
    ST_FETCH_OP_WAIT = 8'd2,
    ST_FETCH_OP_LATCH = 8'd3,
    ST_FETCH_ARG_REQ = 8'd4,
    ST_FETCH_ARG_WAIT = 8'd5,
    ST_FETCH_ARG_LATCH = 8'd6,
    ST_START_PPU = 8'd7,
    ST_WAIT_PPU = 8'd8,
    ST_DONE = 8'd9;

reg [7:0] seq_state;
reg [31:0] cmd_pc;
reg [3:0] arg_index;
reg [3:0] arg_needed;
reg [31:0] arg0, arg1, arg2, arg3, arg4, arg5, arg6;
reg [7:0] op_latched;
reg render_busy;
reg render_done_once;
reg rerun_pending;
reg [3:0] dpad_prev;
wire [3:0] dpad_bits = cont1_key[3:0];
wire dpad_rise_any = |(dpad_bits & ~dpad_prev);
reg [31:0] bridge_ram_rd_data;
reg [31:0] status_rd_data;

always @(posedge clk_74a or negedge reset_n) begin
    if(!reset_n) begin
        ppu_start <= 1'b0;
        ppu_opcode <= 8'd0;
        ppu_arg0 <= 32'd0; ppu_arg1 <= 32'd0; ppu_arg2 <= 32'd0; ppu_arg3 <= 32'd0;
        ppu_arg4 <= 32'd0; ppu_arg5 <= 32'd0; ppu_arg6 <= 32'd0;
        seq_state <= ST_IDLE;
        cmd_pc <= 32'd0;
        arg_index <= 4'd0;
        arg_needed <= 4'd0;
        arg0 <= 32'd0; arg1 <= 32'd0; arg2 <= 32'd0; arg3 <= 32'd0;
        arg4 <= 32'd0; arg5 <= 32'd0; arg6 <= 32'd0;
        op_latched <= 8'd0;
        display_enable <= 1'b0;
        render_busy <= 1'b0;
        render_done_once <= 1'b0;
        rerun_pending <= 1'b0;
        dpad_prev <= 4'd0;
        rom_addr <= 6'd0;
        bridge_ram_rd_data <= 32'd0;
        status_rd_data <= 32'd0;
        word_rd_mux <= 1'b0;
        word_wr_mux <= 1'b0;
        word_addr_mux <= 24'd0;
        word_data_mux <= 32'd0;
    end else begin
        ppu_start <= 1'b0;
        word_rd_mux <= 1'b0;
        word_wr_mux <= 1'b0;
        dpad_prev <= dpad_bits;

        if(dpad_rise_any && render_done_once) rerun_pending <= 1'b1;

        if(ppu_mem_word_rd && !ram_word_busy) begin
            word_rd_mux <= 1'b1;
            word_addr_mux <= ppu_mem_word_addr;
        end
        if(ppu_mem_word_wr && !ram_word_busy) begin
            word_wr_mux <= 1'b1;
            word_addr_mux <= ppu_mem_word_addr;
            word_data_mux <= ppu_mem_word_data;
        end

        if(bridge_wr && !render_busy && !ppu_busy) begin
            casex(bridge_addr[31:24])
            8'b000000xx: begin
                if(!ram_word_busy) begin
                    word_wr_mux <= 1'b1;
                    word_addr_mux <= bridge_addr[25:2];
                    word_data_mux <= bridge_wr_data;
                end
            end
            endcase
        end
        if(bridge_rd && !render_busy && !ppu_busy) begin
            casex(bridge_addr[31:24])
            8'b000000xx: begin
                if(!ram_word_busy) begin
                    word_rd_mux <= 1'b1;
                    word_addr_mux <= bridge_addr[25:2];
                end
                bridge_ram_rd_data <= ram_word_q;
            end
            8'h50: begin
                status_rd_data <= {24'd0, render_busy, render_done_once, display_enable, rerun_pending, dpad_rise_any, 1'b1, reset_n};
            end
            endcase
        end

        if(!render_busy && !render_done_once) begin
            render_busy <= 1'b1;
            cmd_pc <= 32'd0;
            seq_state <= ST_FETCH_OP_REQ;
            display_enable <= 1'b0;
        end else if(rerun_pending && !render_busy && render_done_once) begin
            rerun_pending <= 1'b0;
            render_busy <= 1'b1;
            cmd_pc <= 32'd0;
            seq_state <= ST_FETCH_OP_REQ;
            display_enable <= 1'b0;
        end

        case(seq_state)
        ST_IDLE: begin end
        ST_FETCH_OP_REQ: begin
            if(cmd_pc >= CMD_WORD_COUNT) seq_state <= ST_DONE;
            else begin
                rom_addr <= cmd_pc[5:0];
                seq_state <= ST_FETCH_OP_WAIT;
            end
        end
        ST_FETCH_OP_WAIT: seq_state <= ST_FETCH_OP_LATCH;
        ST_FETCH_OP_LATCH: begin
            op_latched <= rom_q[31:24];
            cmd_pc <= cmd_pc + 32'd1;
            arg_index <= 4'd0;
            case(rom_q[31:24])
            OP_CLEAR: arg_needed <= 4'd1;
            OP_PLOT:  arg_needed <= 4'd3;
            OP_LINE:  arg_needed <= 4'd5;
            OP_RECT:  arg_needed <= 4'd6;
            OP_END:   arg_needed <= 4'd0;
            default:  arg_needed <= 4'd0;
            endcase
            if(rom_q[31:24] == OP_END) seq_state <= ST_DONE;
            else seq_state <= ST_FETCH_ARG_REQ;
        end
        ST_FETCH_ARG_REQ: begin
            if(arg_index >= arg_needed) seq_state <= ST_START_PPU;
            else begin
                rom_addr <= cmd_pc[5:0];
                seq_state <= ST_FETCH_ARG_WAIT;
            end
        end
        ST_FETCH_ARG_WAIT: seq_state <= ST_FETCH_ARG_LATCH;
        ST_FETCH_ARG_LATCH: begin
            if(arg_index == 4'd0) arg0 <= rom_q;
            if(arg_index == 4'd1) arg1 <= rom_q;
            if(arg_index == 4'd2) arg2 <= rom_q;
            if(arg_index == 4'd3) arg3 <= rom_q;
            if(arg_index == 4'd4) arg4 <= rom_q;
            if(arg_index == 4'd5) arg5 <= rom_q;
            if(arg_index == 4'd6) arg6 <= rom_q;
            arg_index <= arg_index + 4'd1;
            cmd_pc <= cmd_pc + 32'd1;
            if(arg_index + 4'd1 >= arg_needed) seq_state <= ST_START_PPU;
            else seq_state <= ST_FETCH_ARG_REQ;
        end
        ST_START_PPU: begin
            ppu_opcode <= op_latched;
            ppu_arg0 <= arg0; ppu_arg1 <= arg1; ppu_arg2 <= arg2; ppu_arg3 <= arg3;
            ppu_arg4 <= arg4; ppu_arg5 <= arg5; ppu_arg6 <= arg6;
            ppu_start <= 1'b1;
            seq_state <= ST_WAIT_PPU;
        end
        ST_WAIT_PPU: begin
            if(ppu_done) seq_state <= ST_FETCH_OP_REQ;
        end
        ST_DONE: begin
            render_busy <= 1'b0;
            render_done_once <= 1'b1;
            display_enable <= 1'b1;
            seq_state <= ST_IDLE;
        end
        default: seq_state <= ST_IDLE;
        endcase
    end
end

always @(*) begin
    casex(bridge_addr)
    32'b000000xx_xxxxxxxx_xxxxxxxx_xxxxxxxx: bridge_rd_data <= bridge_ram_rd_data;
    32'h50000000: bridge_rd_data <= status_rd_data;
    32'hF8xxxxxx: bridge_rd_data <= cmd_bridge_rd_data;
    default: bridge_rd_data <= 32'd0;
    endcase
end

endmodule
