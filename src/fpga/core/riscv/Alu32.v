module Alu32(control, a, b, out, zero);
    input [3:0] control;
    input [31:0] a, b;
    output reg [31:0] out;
    output zero;

    assign zero = (out == 0);
    always @(*) begin
        case(control)
            0: out <= a & b;
            1: out <= a | b;
            2: out <= a + b;
            6: out <= a - b;
            7: out <= a < b ? 1 : 0;
            12: out <= ~(a | b); // nor
            default: out <= 0;
        endcase
    end
endmodule