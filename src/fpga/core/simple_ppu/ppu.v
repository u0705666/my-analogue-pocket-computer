`default_nettype none

module simple_ppu_ppu (
    input   wire            clk,
    input   wire            reset_n,
    input   wire            start,
    input   wire    [7:0]   opcode,
    input   wire    [31:0]  arg0,
    input   wire    [31:0]  arg1,
    input   wire    [31:0]  arg2,
    input   wire    [31:0]  arg3,
    input   wire    [31:0]  arg4,
    input   wire    [31:0]  arg5,
    input   wire    [31:0]  arg6,
    output  reg             busy,
    output  reg             done,

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

localparam [23:0] FB_BASE_WORD = 24'h040000; // byte 0x00100000
localparam [15:0] VID_H_ACTIVE = 16'd320;
localparam [15:0] VID_V_ACTIVE = 16'd288;
localparam [31:0] FB_WORDS     = 32'd46080;

localparam [7:0]
    ST_IDLE         = 8'd0,
    ST_DECODE       = 8'd1,
    ST_CLEAR_LOOP   = 8'd2,
    ST_PLOT_START   = 8'd3,
    ST_LINE_SETUP   = 8'd4,
    ST_LINE_PIXEL   = 8'd5,
    ST_LINE_STEP    = 8'd6,
    ST_RECT_SETUP   = 8'd7,
    ST_RECT_PIXEL   = 8'd8,
    ST_RECT_STEP    = 8'd9,
    ST_PIX_RD_REQ   = 8'd10,
    ST_PIX_RD_WAIT  = 8'd11,
    ST_PIX_WR_REQ   = 8'd12,
    ST_DONE         = 8'd13;

reg [7:0] state;
reg [7:0] resume_state;
reg [7:0] op_latched;
reg [31:0] a0, a1, a2, a3, a4, a5, a6;

reg [31:0] clear_word_index;
reg [31:0] clear_word_data;

reg signed [15:0] line_x0, line_y0, line_x1, line_y1;
reg signed [15:0] line_dx, line_dy, line_err;
reg signed [15:0] line_sx, line_sy, line_next_err;
reg [15:0] line_color;

wire signed [15:0] line_e2 = line_err <<< 1;

reg [15:0] rect_x, rect_y, rect_w, rect_h, rect_color;
reg        rect_fill;
reg [15:0] rect_cur_x, rect_cur_y;

reg [15:0] pix_x, pix_y, pix_color;
reg [31:0] pix_index;
reg [23:0] pix_word_addr;
reg [31:0] pix_word_new;
reg        pix_hi;

always @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        state <= ST_IDLE;
        busy <= 1'b0;
        done <= 1'b0;
        mem_word_rd <= 1'b0;
        mem_word_wr <= 1'b0;
        mem_word_addr <= 24'd0;
        mem_word_data <= 32'd0;
        resume_state <= ST_IDLE;
        op_latched <= 8'd0;
        a0 <= 32'd0; a1 <= 32'd0; a2 <= 32'd0; a3 <= 32'd0; a4 <= 32'd0; a5 <= 32'd0; a6 <= 32'd0;
        clear_word_index <= 32'd0;
        clear_word_data <= 32'd0;
        line_x0 <= 16'sd0; line_y0 <= 16'sd0; line_x1 <= 16'sd0; line_y1 <= 16'sd0;
        line_dx <= 16'sd0; line_dy <= 16'sd0; line_err <= 16'sd0;
        line_sx <= 16'sd0; line_sy <= 16'sd0; line_next_err <= 16'sd0; line_color <= 16'd0;
        rect_x <= 16'd0; rect_y <= 16'd0; rect_w <= 16'd0; rect_h <= 16'd0; rect_color <= 16'd0;
        rect_fill <= 1'b0; rect_cur_x <= 16'd0; rect_cur_y <= 16'd0;
        pix_x <= 16'd0; pix_y <= 16'd0; pix_color <= 16'd0; pix_index <= 32'd0;
        pix_word_addr <= 24'd0; pix_word_new <= 32'd0; pix_hi <= 1'b0;
    end else begin
        done <= 1'b0;
        mem_word_rd <= 1'b0;
        mem_word_wr <= 1'b0;

        if(state == ST_IDLE) begin
            busy <= 1'b0;
            if(start) begin
                busy <= 1'b1;
                op_latched <= opcode;
                a0 <= arg0; a1 <= arg1; a2 <= arg2; a3 <= arg3; a4 <= arg4; a5 <= arg5; a6 <= arg6;
                state <= ST_DECODE;
            end
        end else begin
            case(state)
            ST_DECODE: begin
                if(op_latched == OP_CLEAR) begin
                    clear_word_index <= 32'd0;
                    clear_word_data <= {a0[15:0], a0[15:0]};
                    state <= ST_CLEAR_LOOP;
                end else if(op_latched == OP_PLOT) begin
                    pix_x <= a0[15:0];
                    pix_y <= a1[15:0];
                    pix_color <= a2[15:0];
                    resume_state <= ST_DONE;
                    state <= ST_PLOT_START;
                end else if(op_latched == OP_LINE) begin
                    state <= ST_LINE_SETUP;
                end else if(op_latched == OP_RECT) begin
                    state <= ST_RECT_SETUP;
                end else begin
                    state <= ST_DONE;
                end
            end
            ST_CLEAR_LOOP: begin
                if(clear_word_index >= FB_WORDS) begin
                    state <= ST_DONE;
                end else if(!mem_word_busy) begin
                    mem_word_wr <= 1'b1;
                    mem_word_addr <= FB_BASE_WORD + clear_word_index[23:0];
                    mem_word_data <= clear_word_data;
                    clear_word_index <= clear_word_index + 32'd1;
                end
            end
            ST_PLOT_START: state <= ST_PIX_RD_REQ;
            ST_LINE_SETUP: begin
                line_x0 <= a0[15:0];
                line_y0 <= a1[15:0];
                line_x1 <= a2[15:0];
                line_y1 <= a3[15:0];
                line_dx <= ($signed(a2[15:0]) >= $signed(a0[15:0])) ? ($signed(a2[15:0]) - $signed(a0[15:0])) : ($signed(a0[15:0]) - $signed(a2[15:0]));
                line_dy <= -(($signed(a3[15:0]) >= $signed(a1[15:0])) ? ($signed(a3[15:0]) - $signed(a1[15:0])) : ($signed(a1[15:0]) - $signed(a3[15:0])));
                line_sx <= ($signed(a0[15:0]) < $signed(a2[15:0])) ? 16'sd1 : -16'sd1;
                line_sy <= ($signed(a1[15:0]) < $signed(a3[15:0])) ? 16'sd1 : -16'sd1;
                line_err <= (($signed(a2[15:0]) >= $signed(a0[15:0])) ? ($signed(a2[15:0]) - $signed(a0[15:0])) : ($signed(a0[15:0]) - $signed(a2[15:0])))
                          - (($signed(a3[15:0]) >= $signed(a1[15:0])) ? ($signed(a3[15:0]) - $signed(a1[15:0])) : ($signed(a1[15:0]) - $signed(a3[15:0])));
                line_color <= a4[15:0];
                state <= ST_LINE_PIXEL;
            end
            ST_LINE_PIXEL: begin
                pix_x <= line_x0[15:0];
                pix_y <= line_y0[15:0];
                pix_color <= line_color;
                resume_state <= ST_LINE_STEP;
                state <= ST_PIX_RD_REQ;
            end
            ST_LINE_STEP: begin
                if((line_x0 == line_x1) && (line_y0 == line_y1)) begin
                    state <= ST_DONE;
                end else begin
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
                    state <= ST_LINE_PIXEL;
                end
            end
            ST_RECT_SETUP: begin
                rect_x <= a0[15:0];
                rect_y <= a1[15:0];
                rect_w <= a2[15:0];
                rect_h <= a3[15:0];
                rect_color <= a4[15:0];
                rect_fill <= (a5 != 32'd0);
                rect_cur_x <= 16'd0;
                rect_cur_y <= 16'd0;
                state <= ST_RECT_PIXEL;
            end
            ST_RECT_PIXEL: begin
                if(rect_w == 16'd0 || rect_h == 16'd0) begin
                    state <= ST_DONE;
                end else if(rect_fill ||
                            (rect_cur_x == 16'd0) ||
                            (rect_cur_y == 16'd0) ||
                            (rect_cur_x == rect_w - 16'd1) ||
                            (rect_cur_y == rect_h - 16'd1)) begin
                    pix_x <= rect_x + rect_cur_x;
                    pix_y <= rect_y + rect_cur_y;
                    pix_color <= rect_color;
                    resume_state <= ST_RECT_STEP;
                    state <= ST_PIX_RD_REQ;
                end else begin
                    state <= ST_RECT_STEP;
                end
            end
            ST_RECT_STEP: begin
                if(rect_cur_x == rect_w - 16'd1) begin
                    rect_cur_x <= 16'd0;
                    if(rect_cur_y == rect_h - 16'd1) begin
                        state <= ST_DONE;
                    end else begin
                        rect_cur_y <= rect_cur_y + 16'd1;
                        state <= ST_RECT_PIXEL;
                    end
                end else begin
                    rect_cur_x <= rect_cur_x + 16'd1;
                    state <= ST_RECT_PIXEL;
                end
            end
            ST_PIX_RD_REQ: begin
                if((pix_x >= VID_H_ACTIVE) || (pix_y >= VID_V_ACTIVE)) begin
                    state <= resume_state;
                end else begin
                    pix_index <= pix_y * VID_H_ACTIVE + pix_x;
                    pix_hi <= (pix_y * VID_H_ACTIVE + pix_x) & 16'd1;
                    pix_word_addr <= FB_BASE_WORD + ((pix_y * VID_H_ACTIVE + pix_x) >> 1);
                    if(!mem_word_busy) begin
                        mem_word_rd <= 1'b1;
                        mem_word_addr <= FB_BASE_WORD + ((pix_y * VID_H_ACTIVE + pix_x) >> 1);
                        state <= ST_PIX_RD_WAIT;
                    end
                end
            end
            ST_PIX_RD_WAIT: begin
                if(pix_hi) pix_word_new <= {pix_color, mem_word_q[15:0]};
                else       pix_word_new <= {mem_word_q[31:16], pix_color};
                state <= ST_PIX_WR_REQ;
            end
            ST_PIX_WR_REQ: begin
                if(!mem_word_busy) begin
                    mem_word_wr <= 1'b1;
                    mem_word_addr <= pix_word_addr;
                    mem_word_data <= pix_word_new;
                    state <= resume_state;
                end
            end
            ST_DONE: begin
                busy <= 1'b0;
                done <= 1'b1;
                state <= ST_IDLE;
            end
            default: state <= ST_IDLE;
            endcase
        end
    end
end

endmodule
