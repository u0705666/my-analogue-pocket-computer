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


endmodule
