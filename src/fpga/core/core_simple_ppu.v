`default_nettype none

module core_simple_ppu (
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

mf_pllbase mp1 (
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

wire display_enable;
wire mem_word_rd;
wire mem_word_wr;
wire [23:0] mem_word_addr;
wire [31:0] mem_word_data;
wire [31:0] mem_word_q;
wire mem_word_busy;
wire [31:0] bridge_ram_rd_data;
wire [31:0] ppu_status_rd_data;

// Data table index 3 reports slot-1 file size in bytes.
assign datatable_addr = 10'd3;
assign datatable_wren = 1'b0;
assign datatable_data = 32'd0;

simple_ppu_cpu cpu_i (
    .clk                ( clk_74a ),
    .reset_n            ( reset_n ),
    .dataslot_requestwrite  ( dataslot_requestwrite ),
    .dataslot_allcomplete   ( dataslot_allcomplete ),
    .datatable_q        ( datatable_q ),
    .cont1_key          ( cont1_key ),
    .bridge_addr        ( bridge_addr ),
    .bridge_rd          ( bridge_rd ),
    .bridge_wr          ( bridge_wr ),
    .bridge_wr_data     ( bridge_wr_data ),
    .bridge_ram_rd_data ( bridge_ram_rd_data ),
    .ppu_status_rd_data ( ppu_status_rd_data ),
    .display_enable     ( display_enable ),
    .mem_word_rd        ( mem_word_rd ),
    .mem_word_wr        ( mem_word_wr ),
    .mem_word_addr      ( mem_word_addr ),
    .mem_word_data      ( mem_word_data ),
    .mem_word_q         ( mem_word_q ),
    .mem_word_busy      ( mem_word_busy )
);

simple_ppu_sdram_ctrl sdram_ctrl_i (
    .reset_n            ( reset_n ),
    .clk_video          ( clk_core_12288 ),
    .clk_ram_controller ( clk_ram_controller ),
    .clk_ram_chip       ( clk_ram_chip ),
    .clk_ram_90         ( clk_ram_90 ),
    .display_enable     ( display_enable ),
    .word_rd            ( mem_word_rd ),
    .word_wr            ( mem_word_wr ),
    .word_addr          ( mem_word_addr ),
    .word_data          ( mem_word_data ),
    .word_q             ( mem_word_q ),
    .word_busy          ( mem_word_busy ),
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

always @(*) begin
    casex(bridge_addr)
    32'b000000xx_xxxxxxxx_xxxxxxxx_xxxxxxxx: bridge_rd_data <= bridge_ram_rd_data;
    32'h50000000: bridge_rd_data <= ppu_status_rd_data;
    32'hF8xxxxxx: bridge_rd_data <= cmd_bridge_rd_data;
    default: bridge_rd_data <= 32'd0;
    endcase
end

endmodule
