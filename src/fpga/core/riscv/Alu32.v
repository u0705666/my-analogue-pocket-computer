`include "riscv_configs.v"

module Alu32(control, a, b, out, zero);
    input [3:0] control;
    input [31:0] a, b;
    output reg [31:0] out;
    output zero;

    assign zero = (out == 0);
    always @(*) begin
        case(control)
            `ALU_AND: out = a & b;
            `ALU_OR: out = a | b;
            `ALU_ADD: out = a + b;
            `ALU_SUB: out = a - b;
            `ALU_SLT: out = (a < b) ? 1 : 0;
            `ALU_NOR: out = ~(a | b); // nor
            default: out = 0;
        endcase
    end
endmodule