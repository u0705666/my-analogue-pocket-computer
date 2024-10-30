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



endmodule
