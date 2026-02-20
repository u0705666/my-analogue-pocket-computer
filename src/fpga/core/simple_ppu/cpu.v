`default_nettype none

module simple_ppu_cpu (
    input   wire            clk,
    input   wire            reset_n,

    input   wire            dataslot_requestwrite,
    input   wire            dataslot_allcomplete,
    input   wire    [31:0]  datatable_q,
    input   wire    [15:0]  cont1_key,

    input   wire    [31:0]  bridge_addr,
    input   wire            bridge_rd,
    input   wire            bridge_wr,
    input   wire    [31:0]  bridge_wr_data,
    output  reg     [31:0]  bridge_ram_rd_data,
    output  reg     [31:0]  ppu_status_rd_data,

    output  reg             display_enable,

    output  reg             mem_word_rd,
    output  reg             mem_word_wr,
    output  reg     [23:0]  mem_word_addr,
    output  reg     [31:0]  mem_word_data,
    input   wire    [31:0]  mem_word_q,
    input   wire            mem_word_busy
);

localparam [7:0] OP_CLEAR = 8'h01;
localparam [7:0] OP_PLOT  = 8'h02;
localparam [7:0] OP_LINE  = 8'h03;
localparam [7:0] OP_RECT  = 8'h04;
localparam [7:0] OP_END   = 8'hFF;

localparam [23:0] CMD_BASE_WORD = 24'h000000;

localparam [7:0]
    ST_IDLE              = 8'd0,
    ST_FETCH_OP_REQ      = 8'd1,
    ST_FETCH_OP_WAIT0    = 8'd2,
    ST_FETCH_OP_LATCH    = 8'd3,
    ST_FETCH_ARG_REQ     = 8'd4,
    ST_FETCH_ARG_WAIT0   = 8'd5,
    ST_FETCH_ARG_LATCH   = 8'd6,
    ST_START_PPU         = 8'd7,
    ST_WAIT_PPU          = 8'd8,
    ST_DONE              = 8'd9;

reg [7:0] state;
reg [7:0] current_opcode;
reg [3:0] arg_index;
reg [3:0] arg_needed;
reg [31:0] arg0, arg1, arg2, arg3, arg4, arg5, arg6;
reg [31:0] cmd_pc;
reg [31:0] cmd_word_count;
reg        render_busy;
reg        render_done_once;
reg        rerun_pending;
reg        data_loaded_seen;
reg [3:0]  dpad_prev;

wire [3:0] dpad_bits = cont1_key[3:0];
wire dpad_rise_any = |(dpad_bits & ~dpad_prev);

reg         ppu_start;
wire        ppu_busy;
wire        ppu_done;
wire        ppu_mem_word_rd;
wire        ppu_mem_word_wr;
wire [23:0] ppu_mem_word_addr;
wire [31:0] ppu_mem_word_data;

simple_ppu_ppu ppu_inst (
    .clk            ( clk ),
    .reset_n        ( reset_n ),
    .start          ( ppu_start ),
    .opcode         ( current_opcode ),
    .arg0           ( arg0 ),
    .arg1           ( arg1 ),
    .arg2           ( arg2 ),
    .arg3           ( arg3 ),
    .arg4           ( arg4 ),
    .arg5           ( arg5 ),
    .arg6           ( arg6 ),
    .busy           ( ppu_busy ),
    .done           ( ppu_done ),
    .mem_word_rd    ( ppu_mem_word_rd ),
    .mem_word_wr    ( ppu_mem_word_wr ),
    .mem_word_addr  ( ppu_mem_word_addr ),
    .mem_word_data  ( ppu_mem_word_data ),
    .mem_word_q     ( mem_word_q ),
    .mem_word_busy  ( mem_word_busy )
);

always @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        state <= ST_IDLE;
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
        dpad_prev <= 4'd0;
        ppu_start <= 1'b0;
        display_enable <= 1'b0;
        bridge_ram_rd_data <= 32'd0;
        ppu_status_rd_data <= 32'd0;
        mem_word_rd <= 1'b0;
        mem_word_wr <= 1'b0;
        mem_word_addr <= 24'd0;
        mem_word_data <= 32'd0;
    end else begin
        mem_word_rd <= 1'b0;
        mem_word_wr <= 1'b0;
        ppu_start <= 1'b0;
        dpad_prev <= dpad_bits;

        if(dataslot_requestwrite) begin
            display_enable <= 1'b0;
            render_done_once <= 1'b0;
            data_loaded_seen <= 1'b0;
            render_busy <= 1'b0;
            state <= ST_IDLE;
        end

        if(dataslot_allcomplete && !data_loaded_seen) begin
            data_loaded_seen <= 1'b1;
            cmd_word_count <= datatable_q >> 2;
        end

        if(dpad_rise_any && render_done_once) begin
            rerun_pending <= 1'b1;
        end

        // forward PPU memory requests first while it is running
        if(ppu_mem_word_rd && !mem_word_busy) begin
            mem_word_rd <= 1'b1;
            mem_word_addr <= ppu_mem_word_addr;
        end
        if(ppu_mem_word_wr && !mem_word_busy) begin
            mem_word_wr <= 1'b1;
            mem_word_addr <= ppu_mem_word_addr;
            mem_word_data <= ppu_mem_word_data;
        end

        // bridge mem-mapped reads/writes (disabled while render pipeline is active)
        if(bridge_wr && !render_busy && !ppu_busy) begin
            casex(bridge_addr[31:24])
            8'b000000xx: begin
                if(!mem_word_busy) begin
                    mem_word_wr <= 1'b1;
                    mem_word_addr <= bridge_addr[25:2];
                    mem_word_data <= bridge_wr_data;
                end
            end
            endcase
        end
        if(bridge_rd && !render_busy && !ppu_busy) begin
            casex(bridge_addr[31:24])
            8'b000000xx: begin
                if(!mem_word_busy) begin
                    mem_word_rd <= 1'b1;
                    mem_word_addr <= bridge_addr[25:2];
                end
                bridge_ram_rd_data <= mem_word_q;
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
            cmd_pc <= 32'd0;
            state <= ST_FETCH_OP_REQ;
        end else if(rerun_pending && !render_busy && render_done_once) begin
            render_busy <= 1'b1;
            rerun_pending <= 1'b0;
            display_enable <= 1'b0;
            cmd_pc <= 32'd0;
            state <= ST_FETCH_OP_REQ;
        end

        case(state)
        ST_IDLE: begin
        end
        ST_FETCH_OP_REQ: begin
            if(cmd_pc >= cmd_word_count) begin
                state <= ST_DONE;
            end else if(!mem_word_busy && !ppu_busy) begin
                mem_word_rd <= 1'b1;
                mem_word_addr <= CMD_BASE_WORD + cmd_pc[23:0];
                state <= ST_FETCH_OP_WAIT0;
            end
        end
        ST_FETCH_OP_WAIT0: state <= ST_FETCH_OP_LATCH;
        ST_FETCH_OP_LATCH: begin
            current_opcode <= mem_word_q[31:24];
            cmd_pc <= cmd_pc + 32'd1;
            arg_index <= 4'd0;
            case(mem_word_q[31:24])
            OP_CLEAR: arg_needed <= 4'd1;
            OP_PLOT:  arg_needed <= 4'd3;
            OP_LINE:  arg_needed <= 4'd5;
            OP_RECT:  arg_needed <= 4'd6;
            OP_END:   arg_needed <= 4'd0;
            default:  arg_needed <= 4'd0;
            endcase

            if(mem_word_q[31:24] == OP_END) begin
                state <= ST_DONE;
            end else if((mem_word_q[31:24] == OP_CLEAR) ||
                        (mem_word_q[31:24] == OP_PLOT)  ||
                        (mem_word_q[31:24] == OP_LINE)  ||
                        (mem_word_q[31:24] == OP_RECT)) begin
                state <= ST_FETCH_ARG_REQ;
            end else begin
                state <= ST_DONE;
            end
        end
        ST_FETCH_ARG_REQ: begin
            if(arg_index >= arg_needed) begin
                state <= ST_START_PPU;
            end else if(!mem_word_busy && !ppu_busy) begin
                mem_word_rd <= 1'b1;
                mem_word_addr <= CMD_BASE_WORD + cmd_pc[23:0];
                state <= ST_FETCH_ARG_WAIT0;
            end
        end
        ST_FETCH_ARG_WAIT0: state <= ST_FETCH_ARG_LATCH;
        ST_FETCH_ARG_LATCH: begin
            if(arg_index == 4'd0) arg0 <= mem_word_q;
            if(arg_index == 4'd1) arg1 <= mem_word_q;
            if(arg_index == 4'd2) arg2 <= mem_word_q;
            if(arg_index == 4'd3) arg3 <= mem_word_q;
            if(arg_index == 4'd4) arg4 <= mem_word_q;
            if(arg_index == 4'd5) arg5 <= mem_word_q;
            if(arg_index == 4'd6) arg6 <= mem_word_q;
            arg_index <= arg_index + 4'd1;
            cmd_pc <= cmd_pc + 32'd1;
            if(arg_index + 4'd1 >= arg_needed) state <= ST_START_PPU;
            else state <= ST_FETCH_ARG_REQ;
        end
        ST_START_PPU: begin
            ppu_start <= 1'b1;
            state <= ST_WAIT_PPU;
        end
        ST_WAIT_PPU: begin
            if(ppu_done) state <= ST_FETCH_OP_REQ;
        end
        ST_DONE: begin
            render_busy <= 1'b0;
            render_done_once <= 1'b1;
            display_enable <= 1'b1;
            state <= ST_IDLE;
        end
        default: state <= ST_IDLE;
        endcase
    end
end

endmodule
