`default_nettype none

module data_memory(
    input clk,
    input [31:0] address,
    input [31:0] write_data,
    input mem_write,
    input mem_read,
    output [31:0] read_data
);
    // Declare memory array (4KB memory)
    reg [7:0] mem [0:4095];  // 4KB = 4096 bytes

    reg [31:0] read_data_reg;

    // Write operation (edge-triggered)
    always @(posedge clk) begin
        if (mem_write) begin
            mem[address]   <= write_data[7:0];
            mem[address+1] <= write_data[15:8];
            mem[address+2] <= write_data[23:16];
            mem[address+3] <= write_data[31:24];
        end
    end

    // Read operation (combinational)
    always @(*) begin
        if (mem_read) begin
            read_data_reg = {mem[address+3], mem[address+2], mem[address+1], mem[address]};
        end else begin
            read_data_reg = 32'b0;
        end
    end

    assign read_data = read_data_reg;


endmodule