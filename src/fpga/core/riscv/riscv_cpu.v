`include "riscv_configs.v"
`default_nettype none

module riscv_cpu(
    input clk,
    input reset_n,
    output [31:0] instruction_memory_address,
    input [31:0] instruction_memory_instruction,
    output [31:0] data_memory_address,
    output [31:0] data_memory_write_data,
    output data_memory_mem_write,
    output data_memory_mem_read,
    input [31:0] data_memory_read_data
);
    reg [31:0] pc;
    wire [31:0] pc_next;

    assign pc_next = pc + 4;

    // Register file instance
    wire [31:0] rd1;
    wire [31:0] rd2;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] writeReg;
    wire [31:0] writeData;
    wire regWrite;

    register_file reg_file (
        .clk(clk),
        .reset_n(reset_n),
        .rs1(rs1),
        .rs2(rs2),
        .writeReg(writeReg),
        .writeData(writeData),
        .regWrite(regWrite),
        .rd1(rd1),
        .rd2(rd2)
    );

    // Alu32 instance
    wire [31:0] alu_result;
    wire alu_zero;

    //bind these to the register file later
    wire [31:0] alu_a;
    wire [31:0] alu_b;

    Alu32 alu (
        .control(alu_control),
        .a(alu_a),
        .b(alu_b),
        .out(alu_result),
        .zero(alu_zero)
    );

    // ALU control unit
    wire [1:0] ALUOp;
    wire [6:0] funct7;
    wire [2:0] funct3;
    reg [3:0] alu_control;

    // Extract funct7 and funct3 from the instruction
    assign funct7 = instruction_memory_instruction[31:25];
    assign funct3 = instruction_memory_instruction[14:12];

    // ALU control logic
    always @(*) begin
        case (ALUOp)
            2'b00: alu_control = `ALU_ADD; // add for loads and stores
            2'b01: alu_control = `ALU_SUB; // subtract for beq
            2'b10: begin
                case ({funct7, funct3})
                    10'b0000000_000: alu_control = `ALU_ADD; // add
                    10'b0100000_000: alu_control = `ALU_SUB; // subtract
                    10'b0000000_111: alu_control = `ALU_AND; // and
                    10'b0000000_110: alu_control = `ALU_OR; // or
                    default: alu_control = `ALU_AND; // default to and
                endcase
            end
            default: alu_control = `ALU_AND; // default to and
        endcase
    end
    



endmodule
