module Alu(
    input a,
    input b,
    input cin,
    input[1:0] op,
    output cout,
    output reg result
);
    wire sum;

    Full_adder fa(
        .a(a),
        .b(b),
        .cin(cin),
        .cout(cout),
        .sum(sum)
    );

    always@(*) begin
        case(op)
            2'b0: begin
                result = a&b;
            end
            2'b1: begin
                result = a|b;
            end
            2'b10: begin
                result = sum;
            end
        endcase
    end
endmodule