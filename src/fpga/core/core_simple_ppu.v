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

wire [31:0] ram1_word_q;
wire ram1_word_busy;
wire [31:0] cpu_bridge_ram_rd_data;
wire [31:0] cpu_status_rd_data;
wire cpu_display_enable;
wire cpu_mem_word_rd;
wire cpu_mem_word_wr;
wire [23:0] cpu_mem_word_addr;
wire [31:0] cpu_mem_word_data;

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
    .bridge_ram_rd_data ( cpu_bridge_ram_rd_data ),
    .ppu_status_rd_data ( cpu_status_rd_data ),
    .display_enable     ( cpu_display_enable ),
    .mem_word_rd        ( cpu_mem_word_rd ),
    .mem_word_wr        ( cpu_mem_word_wr ),
    .mem_word_addr      ( cpu_mem_word_addr ),
    .mem_word_data      ( cpu_mem_word_data ),
    .mem_word_q         ( ram1_word_q ),
    .mem_word_busy      ( ram1_word_busy )
);

simple_ppu_sdram_ctrl sdram_ctrl_i (
    .reset_n            ( reset_n ),
    .clk_video          ( clk_core_12288 ),
    .clk_ram_controller ( clk_ram_controller ),
    .clk_ram_chip       ( clk_ram_chip ),
    .clk_ram_90         ( clk_ram_90 ),
    .display_enable     ( cpu_display_enable ),
    .word_rd            ( cpu_mem_word_rd ),
    .word_wr            ( cpu_mem_word_wr ),
    .word_addr          ( cpu_mem_word_addr ),
    .word_data          ( cpu_mem_word_data ),
    .word_q             ( ram1_word_q ),
    .word_busy          ( ram1_word_busy ),
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
    32'b000000xx_xxxxxxxx_xxxxxxxx_xxxxxxxx: bridge_rd_data <= cpu_bridge_ram_rd_data;
    32'h50000000: bridge_rd_data <= cpu_status_rd_data;
    32'hF8xxxxxx: bridge_rd_data <= cmd_bridge_rd_data;
    default: bridge_rd_data <= 32'd0;
    endcase
end

endmodule
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

wire [31:0] ram1_word_q;
wire ram1_word_busy;
wire [31:0] cpu_bridge_ram_rd_data;
wire [31:0] cpu_status_rd_data;
wire cpu_display_enable;
wire cpu_mem_word_rd;
wire cpu_mem_word_wr;
wire [23:0] cpu_mem_word_addr;
wire [31:0] cpu_mem_word_data;

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
    .bridge_ram_rd_data ( cpu_bridge_ram_rd_data ),
    .ppu_status_rd_data ( cpu_status_rd_data ),
    .display_enable     ( cpu_display_enable ),
    .mem_word_rd        ( cpu_mem_word_rd ),
    .mem_word_wr        ( cpu_mem_word_wr ),
    .mem_word_addr      ( cpu_mem_word_addr ),
    .mem_word_data      ( cpu_mem_word_data ),
    .mem_word_q         ( ram1_word_q ),
    .mem_word_busy      ( ram1_word_busy )
);

simple_ppu_sdram_ctrl sdram_ctrl_i (
    .reset_n            ( reset_n ),
    .clk_video          ( clk_core_12288 ),
    .clk_ram_controller ( clk_ram_controller ),
    .clk_ram_chip       ( clk_ram_chip ),
    .clk_ram_90         ( clk_ram_90 ),
    .display_enable     ( cpu_display_enable ),
    .word_rd            ( cpu_mem_word_rd ),
    .word_wr            ( cpu_mem_word_wr ),
    .word_addr          ( cpu_mem_word_addr ),
    .word_data          ( cpu_mem_word_data ),
    .word_q             ( ram1_word_q ),
    .word_busy          ( ram1_word_busy ),
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
    32'b000000xx_xxxxxxxx_xxxxxxxx_xxxxxxxx: bridge_rd_data <= cpu_bridge_ram_rd_data;
    32'h50000000: bridge_rd_data <= cpu_status_rd_data;
    32'hF8xxxxxx: bridge_rd_data <= cmd_bridge_rd_data;
    default: bridge_rd_data <= 32'd0;
    endcase
end

endmodule
//
// Simple PPU core for Analogue Pocket.
//
// Startup flow:
// - Command .bin is loaded by data slot into SDRAM command buffer base.
// - Core executes command stream once to render framebuffer.
// - Any D-pad arrow rising edge reruns command stream and redraws.
//
// Command stream format (32-bit words):
//   word0: [31:24]=opcode, [23:0]=reserved
//   opcode 0x01 CLEAR: word1=color565
//   opcode 0x02 PLOT : word1=x, word2=y, word3=color565
//   opcode 0x03 LINE : word1=x0, word2=y0, word3=x1, word4=y1, word5=color565
//   opcode 0x04 RECT : word1=x, word2=y, word3=w, word4=h, word5=color565, word6=fillFlag(0/1)
//   opcode 0xFF END  : no args
//

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

assign port_ir_tx = 0;
assign port_ir_rx_disable = 1;

assign bridge_endian_little = 0;

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
assign cram0_clk = 0;
assign cram0_adv_n = 1;
assign cram0_cre = 0;
assign cram0_ce0_n = 1;
assign cram0_ce1_n = 1;
assign cram0_oe_n = 1;
assign cram0_we_n = 1;
assign cram0_ub_n = 1;
assign cram0_lb_n = 1;

assign cram1_a = 'h0;
assign cram1_dq = {16{1'bZ}};
assign cram1_clk = 0;
assign cram1_adv_n = 1;
assign cram1_cre = 0;
assign cram1_ce0_n = 1;
assign cram1_ce1_n = 1;
assign cram1_oe_n = 1;
assign cram1_we_n = 1;
assign cram1_ub_n = 1;
assign cram1_lb_n = 1;

assign sram_a = 'h0;
assign sram_dq = {16{1'bZ}};
assign sram_oe_n = 1;
assign sram_we_n = 1;
assign sram_ub_n = 1;
assign sram_lb_n = 1;

assign dbg_tx = 1'bZ;
assign user1 = 1'bZ;
assign aux_scl = 1'bZ;
assign vpll_feed = 1'bZ;

assign audio_mclk = 1'b0;
assign audio_dac = 1'b0;
assign audio_lrck = 1'b0;

wire            reset_n;
wire    [31:0]  cmd_bridge_rd_data;

wire            status_boot_done = pll_core_locked;
wire            status_setup_done = pll_core_locked;
wire            status_running = reset_n;

wire            dataslot_requestread;
wire    [15:0]  dataslot_requestread_id;
wire            dataslot_requestread_ack = 1'b1;
wire            dataslot_requestread_ok = 1'b1;

wire            dataslot_requestwrite;
wire    [15:0]  dataslot_requestwrite_id;
wire            dataslot_requestwrite_ack = 1'b1;
wire            dataslot_requestwrite_ok = 1'b1;

wire            dataslot_allcomplete;

wire            savestate_supported = 1'b0;
wire    [31:0]  savestate_addr = 32'd0;
wire    [31:0]  savestate_size = 32'd0;
wire    [31:0]  savestate_maxloadsize = 32'd0;
wire            savestate_start;
wire            savestate_start_ack = 1'b0;
wire            savestate_start_busy = 1'b0;
wire            savestate_start_ok = 1'b0;
wire            savestate_start_err = 1'b0;
wire            savestate_load;
wire            savestate_load_ack = 1'b0;
wire            savestate_load_busy = 1'b0;
wire            savestate_load_ok = 1'b0;
wire            savestate_load_err = 1'b0;
wire            osnotify_inmenu;

wire    [9:0]   datatable_addr;
wire            datatable_wren;
wire    [31:0]  datatable_data;
wire    [31:0]  datatable_q;

core_bridge_cmd icb (
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
    .savestate_supported    ( savestate_supported ),
    .savestate_addr         ( savestate_addr ),
    .savestate_size         ( savestate_size ),
    .savestate_maxloadsize  ( savestate_maxloadsize ),
    .osnotify_inmenu        ( osnotify_inmenu ),
    .savestate_start        ( savestate_start ),
    .savestate_start_ack    ( savestate_start_ack ),
    .savestate_start_busy   ( savestate_start_busy ),
    .savestate_start_ok     ( savestate_start_ok ),
    .savestate_start_err    ( savestate_start_err ),
    .savestate_load         ( savestate_load ),
    .savestate_load_ack     ( savestate_load_ack ),
    .savestate_load_busy    ( savestate_load_busy ),
    .savestate_load_ok      ( savestate_load_ok ),
    .savestate_load_err     ( savestate_load_err ),
    .datatable_addr         ( datatable_addr ),
    .datatable_wren         ( datatable_wren ),
    .datatable_data         ( datatable_data ),
    .datatable_q            ( datatable_q )
);

reg [31:0] ram1_bridge_rd_data;
reg [31:0] ppu_status_rd_data;
always @(*) begin
    casex(bridge_addr)
    32'b000000xx_xxxxxxxx_xxxxxxxx_xxxxxxxx: bridge_rd_data <= ram1_bridge_rd_data;
    32'h50000000: bridge_rd_data <= ppu_status_rd_data;
    32'hF8xxxxxx: bridge_rd_data <= cmd_bridge_rd_data;
    default:      bridge_rd_data <= 32'd0;
    endcase
end

wire    clk_core_12288;
wire    clk_core_12288_90deg;
wire    clk_ram_controller;
wire    clk_ram_chip;
wire    clk_ram_90;
wire    pll_core_locked;

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

localparam  [9:0]   VID_V_BPORCH = 10'd10;
localparam  [9:0]   VID_V_ACTIVE = 10'd288;
localparam  [9:0]   VID_V_TOTAL  = 10'd512;
localparam  [9:0]   VID_H_BPORCH = 10'd10;
localparam  [9:0]   VID_H_ACTIVE = 10'd320;
localparam  [9:0]   VID_H_TOTAL  = 10'd400;

reg [9:0] x_count;
reg [9:0] y_count;
wire signed [10:0] visible_x = $signed({1'b0, x_count}) - $signed({1'b0, VID_H_BPORCH});
wire signed [10:0] visible_y = $signed({1'b0, y_count}) - $signed({1'b0, VID_V_BPORCH});

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

reg             new_frame;
reg             next_line;

reg             linebuf_toggle;
reg [9:0]       linebuf_rdaddr;
wire [10:0]     linebuf_rdaddr_fix = (linebuf_toggle ? linebuf_rdaddr : (linebuf_rdaddr + 10'd1024));
wire [15:0]     linebuf_q;

always @(posedge video_rgb_clock or negedge reset_n) begin
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
        if(x_count >= VID_H_BPORCH && x_count < VID_H_BPORCH + VID_H_ACTIVE &&
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
synch_3 s3(next_line, next_line_s, clk_ram_controller);
synch_3 s4(new_frame, new_frame_s, clk_ram_controller);
synch_3 s9(linebuf_toggle, linebuf_toggle_s, clk_ram_controller);

reg [9:0]   linebuf_wraddr;
wire [10:0] linebuf_wraddr_fix = (linebuf_toggle_s ? (linebuf_wraddr + 10'd1024) : linebuf_wraddr);
reg [15:0]  linebuf_data;
reg         linebuf_wren;

mf_linebuf mf_linebuf_inst (
    .rdclock    ( clk_core_12288 ),
    .rdaddress  ( linebuf_rdaddr_fix ),
    .q          ( linebuf_q ),
    .wrclock    ( clk_ram_controller ),
    .wraddress  ( linebuf_wraddr_fix ),
    .data       ( linebuf_data ),
    .wren       ( linebuf_wren )
);

reg             ram1_burst_rd;
reg     [24:0]  ram1_burst_addr;
reg     [10:0]  ram1_burst_len;
reg             ram1_burst_32bit;
wire    [31:0]  ram1_burst_data;
wire            ram1_burst_data_valid;
wire            ram1_burst_data_done;

wire            ram1_burstwr;
wire    [24:0]  ram1_burstwr_addr;
wire            ram1_burstwr_ready;
wire            ram1_burstwr_strobe;
wire    [15:0]  ram1_burstwr_data;
wire            ram1_burstwr_done;

reg             ram1_word_rd;
reg             ram1_word_wr;
reg     [23:0]  ram1_word_addr;
reg     [31:0]  ram1_word_data;
wire    [31:0]  ram1_word_q;
wire            ram1_word_busy;

io_sdram isr0 (
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
    .burst_rd           ( ram1_burst_rd ),
    .burst_addr         ( ram1_burst_addr ),
    .burst_len          ( ram1_burst_len ),
    .burst_32bit        ( ram1_burst_32bit ),
    .burst_data         ( ram1_burst_data ),
    .burst_data_valid   ( ram1_burst_data_valid ),
    .burst_data_done    ( ram1_burst_data_done ),
    .burstwr            ( ram1_burstwr ),
    .burstwr_addr       ( ram1_burstwr_addr ),
    .burstwr_ready      ( ram1_burstwr_ready ),
    .burstwr_strobe     ( ram1_burstwr_strobe ),
    .burstwr_data       ( ram1_burstwr_data ),
    .burstwr_done       ( ram1_burstwr_done ),
    .word_rd            ( ram1_word_rd ),
    .word_wr            ( ram1_word_wr ),
    .word_addr          ( ram1_word_addr ),
    .word_data          ( ram1_word_data ),
    .word_q             ( ram1_word_q ),
    .word_busy          ( ram1_word_busy )
);

localparam [24:0] FB_BASE_BURST_ADDR = 25'h080000;   // byte 0x00100000 in 16-bit words
localparam [23:0] FB_BASE_WORD       = 24'h040000;   // byte 0x00100000 in 32-bit words
localparam [23:0] CMD_BASE_WORD      = 24'h000000;
localparam [31:0] FB_PIXELS          = 32'd92160;    // 320*288
localparam [31:0] FB_WORDS           = 32'd46080;    // 16bpp packed into 32-bit words
localparam [9:0]  CMD_SLOT_ID        = 10'd1;

assign datatable_addr = CMD_SLOT_ID;
reg display_enable;
reg display_enable_gated;
synch_3 s5(display_enable_gated, display_enable_s, clk_ram_controller);

reg [3:0] rr_state;
reg [10:0] rr_line;
localparam RR_STATE_IDLE = 4'd0;
localparam RR_STATE_WAIT = 4'd1;
localparam RR_STATE_READ = 4'd2;

always @(posedge clk_ram_controller or negedge reset_n) begin
    if(!reset_n) begin
        rr_state <= RR_STATE_IDLE;
        rr_line <= 11'd0;
        ram1_burst_rd <= 1'b0;
        ram1_burst_addr <= 25'd0;
        ram1_burst_len <= 11'd0;
        ram1_burst_32bit <= 1'b0;
        linebuf_wren <= 1'b0;
        linebuf_wraddr <= 10'd0;
        linebuf_data <= 16'd0;
    end else begin
        ram1_burst_rd <= 1'b0;
        linebuf_wren <= 1'b0;

        case(rr_state)
        RR_STATE_IDLE: rr_state <= RR_STATE_WAIT;
        RR_STATE_WAIT: begin
            if(new_frame_s) rr_line <= 11'd0;
            if(next_line_s && display_enable_s) begin
                rr_line <= rr_line + 11'd1;
                ram1_burst_rd <= 1'b1;
                ram1_burst_addr <= FB_BASE_BURST_ADDR + (rr_line * VID_H_ACTIVE);
                ram1_burst_len <= 11'd1024;
                ram1_burst_32bit <= 1'b0;
                linebuf_wraddr <= 10'h3ff;
                rr_state <= RR_STATE_READ;
            end
        end
        RR_STATE_READ: begin
            if(ram1_burst_data_valid) begin
                linebuf_data <= ram1_burst_data[15:0];
                linebuf_wraddr <= linebuf_wraddr + 10'd1;
                linebuf_wren <= 1'b1;
            end
            if(ram1_burst_data_done) rr_state <= RR_STATE_WAIT;
        end
        default: rr_state <= RR_STATE_IDLE;
        endcase
    end
end

localparam [7:0] OP_CLEAR = 8'h01;
localparam [7:0] OP_PLOT  = 8'h02;
localparam [7:0] OP_LINE  = 8'h03;
localparam [7:0] OP_RECT  = 8'h04;
localparam [7:0] OP_END   = 8'hFF;

localparam [7:0]
    RS_IDLE               = 8'd0,
    RS_FETCH_OP_REQ       = 8'd1,
    RS_FETCH_OP_WAIT0     = 8'd2,
    RS_FETCH_OP_LATCH     = 8'd3,
    RS_FETCH_ARG_REQ      = 8'd4,
    RS_FETCH_ARG_WAIT0    = 8'd5,
    RS_FETCH_ARG_LATCH    = 8'd6,
    RS_DECODE_EXEC        = 8'd7,
    RS_CLEAR_LOOP         = 8'd8,
    RS_PLOT_START         = 8'd9,
    RS_LINE_SETUP         = 8'd10,
    RS_LINE_PIXEL         = 8'd11,
    RS_LINE_STEP          = 8'd12,
    RS_RECT_SETUP         = 8'd13,
    RS_RECT_PIXEL         = 8'd14,
    RS_RECT_STEP          = 8'd15,
    RS_PIXEL_RD_REQ       = 8'd16,
    RS_PIXEL_RD_WAIT0     = 8'd17,
    RS_PIXEL_WR_REQ       = 8'd18,
    RS_DONE               = 8'd19;

reg [7:0]  render_state;
reg [7:0]  render_resume_state;
reg [7:0]  current_opcode;
reg [3:0]  arg_index;
reg [3:0]  arg_needed;
reg [31:0] arg0, arg1, arg2, arg3, arg4, arg5, arg6;
reg [31:0] cmd_pc;
reg [31:0] cmd_word_count;
reg        render_busy;
reg        render_done_once;
reg        rerun_pending;
reg        data_loaded_seen;

reg [31:0] clear_word_index;
reg [31:0] clear_word_data;

reg signed [15:0] line_x0, line_y0, line_x1, line_y1;
reg signed [15:0] line_dx, line_dy, line_err, line_e2;
reg signed [15:0] line_sx, line_sy;
reg signed [15:0] line_next_err;
reg [15:0] line_color;

reg [15:0] rect_x, rect_y, rect_w, rect_h, rect_color;
reg        rect_fill;
reg [15:0] rect_cur_x, rect_cur_y;

reg [15:0] pix_x;
reg [15:0] pix_y;
reg [15:0] pix_color;
reg [31:0] pix_index;
reg [23:0] pix_word_addr;
reg [31:0] pix_word_old;
reg [31:0] pix_word_new;
reg        pix_hi;
reg        pix_skip;

reg [3:0] dpad_prev;
wire [3:0] dpad_bits = cont1_key[3:0];
wire dpad_rise_any = |(dpad_bits & ~dpad_prev);

always @(posedge clk_74a or negedge reset_n) begin
    if(!reset_n) begin
        render_state <= RS_IDLE;
        render_resume_state <= RS_IDLE;
        current_opcode <= 8'd0;
        arg_index <= 4'd0;
        arg_needed <= 4'd0;
        arg0 <= 32'd0; arg1 <= 32'd0; arg2 <= 32'd0; arg3 <= 32'd0;
        arg4 <= 32'd0; arg5 <= 32'd0; arg6 <= 32'd0;
        cmd_pc <= 32'd0;
        cmd_word_count <= 32'd0;
        render_busy <= 1'b0;
        render_done_once <= 1'b0;
        rerun_pending <= 1'b0;
        data_loaded_seen <= 1'b0;
        clear_word_index <= 32'd0;
        clear_word_data <= 32'd0;
        line_x0 <= 16'sd0; line_y0 <= 16'sd0; line_x1 <= 16'sd0; line_y1 <= 16'sd0;
        line_dx <= 16'sd0; line_dy <= 16'sd0; line_err <= 16'sd0; line_e2 <= 16'sd0;
        line_sx <= 16'sd0; line_sy <= 16'sd0; line_next_err <= 16'sd0; line_color <= 16'd0;
        rect_x <= 16'd0; rect_y <= 16'd0; rect_w <= 16'd0; rect_h <= 16'd0;
        rect_color <= 16'd0; rect_fill <= 1'b0; rect_cur_x <= 16'd0; rect_cur_y <= 16'd0;
        pix_x <= 16'd0; pix_y <= 16'd0; pix_color <= 16'd0; pix_index <= 32'd0;
        pix_word_addr <= 24'd0; pix_word_old <= 32'd0; pix_word_new <= 32'd0; pix_hi <= 1'b0; pix_skip <= 1'b0;
        display_enable <= 1'b0;
        display_enable_gated <= 1'b0;
        dpad_prev <= 4'd0;
        ram1_word_rd <= 1'b0;
        ram1_word_wr <= 1'b0;
        ram1_word_addr <= 24'd0;
        ram1_word_data <= 32'd0;
        ram1_bridge_rd_data <= 32'd0;
        ppu_status_rd_data <= 32'd0;
    end else begin
        ram1_word_rd <= 1'b0;
        ram1_word_wr <= 1'b0;

        dpad_prev <= dpad_bits;

        if(dataslot_requestwrite) begin
            display_enable <= 1'b0;
            display_enable_gated <= 1'b0;
            render_done_once <= 1'b0;
            data_loaded_seen <= 1'b0;
        end

        if(dataslot_allcomplete && !data_loaded_seen) begin
            data_loaded_seen <= 1'b1;
            cmd_word_count <= datatable_q >> 2;
        end

        if(dpad_rise_any && render_done_once) begin
            if(render_busy) rerun_pending <= 1'b1;
            else rerun_pending <= 1'b1;
        end

        if(bridge_wr && !render_busy) begin
            casex(bridge_addr[31:24])
            8'b000000xx: begin
                ram1_word_wr <= 1'b1;
                ram1_word_addr <= bridge_addr[25:2];
                ram1_word_data <= bridge_wr_data;
            end
            endcase
        end
        if(bridge_rd && !render_busy) begin
            casex(bridge_addr[31:24])
            8'b000000xx: begin
                ram1_word_rd <= 1'b1;
                ram1_word_addr <= bridge_addr[25:2];
                ram1_bridge_rd_data <= ram1_word_q;
            end
            8'h50: begin
                ppu_status_rd_data <= {24'd0, render_busy, render_done_once, display_enable, rerun_pending, dpad_rise_any, dataslot_allcomplete, reset_n};
            end
            endcase
        end

        if(data_loaded_seen && !render_busy && !render_done_once) begin
            render_busy <= 1'b1;
            rerun_pending <= 1'b0;
            display_enable <= 1'b0;
            display_enable_gated <= 1'b0;
            cmd_pc <= 32'd0;
            render_state <= RS_FETCH_OP_REQ;
        end else if(rerun_pending && !render_busy && render_done_once) begin
            render_busy <= 1'b1;
            rerun_pending <= 1'b0;
            display_enable <= 1'b0;
            display_enable_gated <= 1'b0;
            cmd_pc <= 32'd0;
            render_state <= RS_FETCH_OP_REQ;
        end

        case(render_state)
        RS_IDLE: begin
        end
        RS_FETCH_OP_REQ: begin
            if(cmd_pc >= cmd_word_count) begin
                render_state <= RS_DONE;
            end else if(!ram1_word_busy) begin
                ram1_word_rd <= 1'b1;
                ram1_word_addr <= CMD_BASE_WORD + cmd_pc[23:0];
                render_state <= RS_FETCH_OP_WAIT0;
            end
        end
        RS_FETCH_OP_WAIT0: begin
            render_state <= RS_FETCH_OP_LATCH;
        end
        RS_FETCH_OP_LATCH: begin
            current_opcode <= ram1_word_q[31:24];
            cmd_pc <= cmd_pc + 32'd1;
            arg_index <= 4'd0;
            case(ram1_word_q[31:24])
            OP_CLEAR: arg_needed <= 4'd1;
            OP_PLOT:  arg_needed <= 4'd3;
            OP_LINE:  arg_needed <= 4'd5;
            OP_RECT:  arg_needed <= 4'd6;
            OP_END:   arg_needed <= 4'd0;
            default:  arg_needed <= 4'd0;
            endcase
            if(ram1_word_q[31:24] == OP_END) render_state <= RS_DONE;
            else if((ram1_word_q[31:24] == OP_CLEAR) || (ram1_word_q[31:24] == OP_PLOT) ||
                    (ram1_word_q[31:24] == OP_LINE) || (ram1_word_q[31:24] == OP_RECT))
                render_state <= RS_FETCH_ARG_REQ;
            else
                render_state <= RS_DONE;
        end
        RS_FETCH_ARG_REQ: begin
            if(arg_index >= arg_needed) begin
                render_state <= RS_DECODE_EXEC;
            end else if(!ram1_word_busy) begin
                ram1_word_rd <= 1'b1;
                ram1_word_addr <= CMD_BASE_WORD + cmd_pc[23:0];
                render_state <= RS_FETCH_ARG_WAIT0;
            end
        end
        RS_FETCH_ARG_WAIT0: begin
            render_state <= RS_FETCH_ARG_LATCH;
        end
        RS_FETCH_ARG_LATCH: begin
            if(arg_index == 4'd0) arg0 <= ram1_word_q;
            if(arg_index == 4'd1) arg1 <= ram1_word_q;
            if(arg_index == 4'd2) arg2 <= ram1_word_q;
            if(arg_index == 4'd3) arg3 <= ram1_word_q;
            if(arg_index == 4'd4) arg4 <= ram1_word_q;
            if(arg_index == 4'd5) arg5 <= ram1_word_q;
            if(arg_index == 4'd6) arg6 <= ram1_word_q;
            arg_index <= arg_index + 4'd1;
            cmd_pc <= cmd_pc + 32'd1;
            if(arg_index + 4'd1 >= arg_needed) render_state <= RS_DECODE_EXEC;
            else render_state <= RS_FETCH_ARG_REQ;
        end
        RS_DECODE_EXEC: begin
            if(current_opcode == OP_CLEAR) begin
                clear_word_index <= 32'd0;
                clear_word_data <= {arg0[15:0], arg0[15:0]};
                render_state <= RS_CLEAR_LOOP;
            end else if(current_opcode == OP_PLOT) begin
                pix_x <= arg0[15:0];
                pix_y <= arg1[15:0];
                pix_color <= arg2[15:0];
                render_resume_state <= RS_FETCH_OP_REQ;
                render_state <= RS_PLOT_START;
            end else if(current_opcode == OP_LINE) begin
                render_state <= RS_LINE_SETUP;
            end else if(current_opcode == OP_RECT) begin
                render_state <= RS_RECT_SETUP;
            end else begin
                render_state <= RS_DONE;
            end
        end
        RS_CLEAR_LOOP: begin
            if(clear_word_index >= FB_WORDS) begin
                render_state <= RS_FETCH_OP_REQ;
            end else if(!ram1_word_busy) begin
                ram1_word_wr <= 1'b1;
                ram1_word_addr <= FB_BASE_WORD + clear_word_index[23:0];
                ram1_word_data <= clear_word_data;
                clear_word_index <= clear_word_index + 32'd1;
            end
        end
        RS_PLOT_START: begin
            render_state <= RS_PIXEL_RD_REQ;
        end
        RS_LINE_SETUP: begin
            line_x0 <= arg0[15:0];
            line_y0 <= arg1[15:0];
            line_x1 <= arg2[15:0];
            line_y1 <= arg3[15:0];
            line_dx <= ($signed(arg2[15:0]) >= $signed(arg0[15:0])) ? ($signed(arg2[15:0]) - $signed(arg0[15:0])) : ($signed(arg0[15:0]) - $signed(arg2[15:0]));
            line_dy <= -(( $signed(arg3[15:0]) >= $signed(arg1[15:0])) ? ($signed(arg3[15:0]) - $signed(arg1[15:0])) : ($signed(arg1[15:0]) - $signed(arg3[15:0])));
            line_sx <= ($signed(arg0[15:0]) < $signed(arg2[15:0])) ? 16'sd1 : -16'sd1;
            line_sy <= ($signed(arg1[15:0]) < $signed(arg3[15:0])) ? 16'sd1 : -16'sd1;
            line_err <= (($signed(arg2[15:0]) >= $signed(arg0[15:0])) ? ($signed(arg2[15:0]) - $signed(arg0[15:0])) : ($signed(arg0[15:0]) - $signed(arg2[15:0])))
                      - (( $signed(arg3[15:0]) >= $signed(arg1[15:0])) ? ($signed(arg3[15:0]) - $signed(arg1[15:0])) : ($signed(arg1[15:0]) - $signed(arg3[15:0])));
            line_color <= arg4[15:0];
            render_state <= RS_LINE_PIXEL;
        end
        RS_LINE_PIXEL: begin
            pix_x <= line_x0[15:0];
            pix_y <= line_y0[15:0];
            pix_color <= line_color;
            render_resume_state <= RS_LINE_STEP;
            render_state <= RS_PIXEL_RD_REQ;
        end
        RS_LINE_STEP: begin
            if((line_x0 == line_x1) && (line_y0 == line_y1)) begin
                render_state <= RS_FETCH_OP_REQ;
            end else begin
                line_e2 = line_err <<< 1;
                line_next_err = line_err;
                if(line_e2 >= line_dy) begin
                    line_next_err = line_next_err + line_dy;
                    line_x0 <= line_x0 + line_sx;
                end
                if(line_e2 <= line_dx) begin
                    line_next_err = line_next_err + line_dx;
                    line_y0 <= line_y0 + line_sy;
                end
                line_err <= line_next_err;
                render_state <= RS_LINE_PIXEL;
            end
        end
        RS_RECT_SETUP: begin
            rect_x <= arg0[15:0];
            rect_y <= arg1[15:0];
            rect_w <= arg2[15:0];
            rect_h <= arg3[15:0];
            rect_color <= arg4[15:0];
            rect_fill <= (arg5 != 32'd0);
            rect_cur_x <= 16'd0;
            rect_cur_y <= 16'd0;
            render_state <= RS_RECT_PIXEL;
        end
        RS_RECT_PIXEL: begin
            if(rect_w == 16'd0 || rect_h == 16'd0) begin
                render_state <= RS_FETCH_OP_REQ;
            end else begin
                if(rect_fill ||
                   (rect_cur_x == 16'd0) ||
                   (rect_cur_y == 16'd0) ||
                   (rect_cur_x == rect_w - 16'd1) ||
                   (rect_cur_y == rect_h - 16'd1)) begin
                    pix_x <= rect_x + rect_cur_x;
                    pix_y <= rect_y + rect_cur_y;
                    pix_color <= rect_color;
                    render_resume_state <= RS_RECT_STEP;
                    render_state <= RS_PIXEL_RD_REQ;
                end else begin
                    render_state <= RS_RECT_STEP;
                end
            end
        end
        RS_RECT_STEP: begin
            if(rect_cur_x == rect_w - 16'd1) begin
                rect_cur_x <= 16'd0;
                if(rect_cur_y == rect_h - 16'd1) begin
                    render_state <= RS_FETCH_OP_REQ;
                end else begin
                    rect_cur_y <= rect_cur_y + 16'd1;
                    render_state <= RS_RECT_PIXEL;
                end
            end else begin
                rect_cur_x <= rect_cur_x + 16'd1;
                render_state <= RS_RECT_PIXEL;
            end
        end
        RS_PIXEL_RD_REQ: begin
            pix_skip <= 1'b0;
            if(($signed({1'b0, pix_x}) >= $signed(VID_H_ACTIVE)) || ($signed({1'b0, pix_y}) >= $signed(VID_V_ACTIVE))) begin
                pix_skip <= 1'b1;
                render_state <= render_resume_state;
            end else begin
                pix_index <= pix_y * VID_H_ACTIVE + pix_x;
                pix_hi <= (pix_y * VID_H_ACTIVE + pix_x) & 16'd1;
                pix_word_addr <= FB_BASE_WORD + ((pix_y * VID_H_ACTIVE + pix_x) >> 1);
                if(!ram1_word_busy) begin
                    ram1_word_rd <= 1'b1;
                    ram1_word_addr <= FB_BASE_WORD + ((pix_y * VID_H_ACTIVE + pix_x) >> 1);
                    render_state <= RS_PIXEL_RD_WAIT0;
                end
            end
        end
        RS_PIXEL_RD_WAIT0: begin
            pix_word_old <= ram1_word_q;
            if(pix_hi) pix_word_new <= {pix_color, ram1_word_q[15:0]};
            else       pix_word_new <= {ram1_word_q[31:16], pix_color};
            render_state <= RS_PIXEL_WR_REQ;
        end
        RS_PIXEL_WR_REQ: begin
            if(!ram1_word_busy) begin
                ram1_word_wr <= 1'b1;
                ram1_word_addr <= pix_word_addr;
                ram1_word_data <= pix_word_new;
                render_state <= render_resume_state;
            end
        end
        RS_DONE: begin
            render_busy <= 1'b0;
            render_done_once <= 1'b1;
            display_enable <= 1'b1;
            display_enable_gated <= reset_n;
            render_state <= RS_IDLE;
        end
        default: begin
            render_state <= RS_IDLE;
        end
        endcase
    end
end

endmodule
