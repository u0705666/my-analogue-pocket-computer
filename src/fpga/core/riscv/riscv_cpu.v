module riscv_cpu(
    input clk,
    input reset_n
);
    reg [31:0] pc;
    wire [31:0] pc_next;

    assign pc_next = pc + 4;


endmodule
