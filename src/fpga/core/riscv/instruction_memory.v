module instruction_memory #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 10
)(
    input  [ADDR_WIDTH-1:0] address,  // Instruction address
    output reg [DATA_WIDTH-1:0] instruction  // Output instruction
);
    
    // Declare memory array
    reg [7:0] memory_array [0:(1<<ADDR_WIDTH)-1];
    
    // Initialize the memory array from a file
    initial begin
        $readmemh("/Users/niuguangyuan/Projects/openfpga/intel-quartus-drivec/myprojects/my-analogue-pocket-computer/src/fpga/core/riscv/instructions.mem", memory_array);  // Read hex data from file
        // Or use $readmemb for binary file: $readmemb("instructions.mem", memory_array);
    end
    
    // Output the instruction at the specified address
    always @(*) begin
        instruction = {memory_array[address+3], memory_array[address+2], memory_array[address+1], memory_array[address]};
    end

endmodule