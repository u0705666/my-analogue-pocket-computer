`default_nettype none

module register_file (
    input wire clk,
    input wire reset_n,
    input wire [4:0] rs1,
    input wire [4:0] rs2,
    output wire [31:0] rd1,
    output wire [31:0] rd2,
    input wire [4:0] writeReg,
    input wire [31:0] writeData,
    input wire regWrite
);

    // 32 32-bit registers
    reg [31:0] registers [31:0];

    // Read operation
    assign rd1 = (rs1 == 0) ? 32'b0 : registers[rs1];
    assign rd2 = (rs2 == 0) ? 32'b0 : registers[rs2];

    // Write operation
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            integer i;
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'b0;
            end
        end else if (regWrite && writeReg != 0) begin
            registers[writeReg] <= writeData;
        end
    end

endmodule