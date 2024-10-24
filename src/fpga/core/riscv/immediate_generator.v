module immediate_generator (
    input wire [31:0] instruction,
    output reg [31:0] immediate
);

    wire [6:0] opcode;
    assign opcode = instruction[6:0];

    always @(*) begin
        case (opcode)
            7'b0000011: // Load instructions
                immediate = {{20{instruction[31]}}, instruction[31:20]};
            7'b0100011: // Store instructions
                immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            7'b1100011: // Branch instructions
                immediate = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
            default:
                immediate = 32'b0; // Default case, can be modified as needed
        endcase
    end

endmodule
