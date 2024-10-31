`default_nettype none

module ngy_computer_top #(
    parameter RAM_LENGTH = 1199, 
    parameter GRID_ROWS = 30, 
    parameter GRID_COLS = 40
)(
    input wire clk_74a,
    input wire reset_n,
    input wire [15:0] cont1_key,
    output reg [0:RAM_LENGTH-1] grid_ram
);

/*************************************
Test Riscv related circuits here
*************************************/
wire [31:0] a, b;
reg [3:0] control;
wire [31:0] result;
wire zero;

Alu32 alu(
	.a(a),
	.b(b),
	.control(control),
	.out(result),
	.zero(zero)
);

assign a = 32'b01010100000000000000000000001000;
assign b = 32'b00000000000000000000000000000001;

wire [3:0] cont1_key_abxy;

assign cont1_key_abxy = cont1_key[7:4];

always @(*) begin
	case (cont1_key_abxy)
		4'b0001: begin
			control = 0;
		end
		4'b0010: begin
			control = 1;
		end
		4'b0100: begin
			control = 2;
		end
		4'b1000: begin
			control = 6;
		end
		default: control = 2;
	endcase
end



/***************************
end of riscv test
****************************/


//**************************************************
// riscv cpu
//**************************************************

wire [31:0] instruction_memory_instruction;
wire [31:0] instruction_memory_address;
wire [31:0] data_memory_address;
wire [31:0] data_memory_write_data;
wire data_memory_mem_write;
wire data_memory_mem_read;
wire [31:0] data_memory_read_data;

riscv_cpu cpu1(
	.clk(clk_74a),
	.reset_n(reset_n),
	.instruction_memory_address(instruction_memory_address),
	.instruction_memory_instruction(instruction_memory_instruction),
	.data_memory_address(data_memory_address),
	.data_memory_write_data(data_memory_write_data),
	.data_memory_mem_write(data_memory_mem_write),
	.data_memory_mem_read(data_memory_mem_read),
	.data_memory_read_data(data_memory_read_data)
);

instruction_memory #(
	.DATA_WIDTH(32),
	.ADDR_WIDTH(10)
) im1 (
	.address(instruction_memory_address[9:0]),
	.instruction(instruction_memory_instruction)
);

data_memory dm1(
	.address(data_memory_address),
	.write_data(data_memory_write_data),
	.mem_write(data_memory_mem_write),
	.mem_read(data_memory_mem_read),
	.read_data(data_memory_read_data)
);

//**************************************************
// end of riscv cpu
//**************************************************

	integer i, j;

always @(posedge clk_74a or negedge reset_n) begin
    if (!reset_n) begin
        // Reset logic to initialize the grid
        for (i = 0; i < GRID_ROWS; i = i + 1) begin
            for (j = 0; j < GRID_COLS; j = j + 1) begin
				grid_ram[i*GRID_COLS + j] <= 0; // initialize to black
            end
        end
    end else begin
        // Normal operation
        grid_ram[0:31] <= a;
        grid_ram[40:71] <= b;
        grid_ram[80:111] <= result;
        grid_ram[120] <= zero;
    end
end

endmodule