`timescale 1ns/1ps

module instruction_memory_tb;

    // Parameters
    parameter DATA_WIDTH = 32;
    parameter ADDR_WIDTH = 2;
    
    // Testbench signals
    reg [ADDR_WIDTH-1:0] address;
    wire [DATA_WIDTH-1:0] instruction;
    
    // Instantiate the Instruction Memory module
    instruction_memory #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) uut (
        .address(address),
        .instruction(instruction)
    );
    
    // Test vector
    initial begin
        // Initialize address to 0
        address = 0;
        
        // Wait for some time and check different addresses
        #10;
        address = 1; // Should fetch the instruction at address 1
        
        #10;
        address = 2; // Should fetch the instruction at address 2
        
        #10;
        address = 3; // Should fetch the instruction at address 3
        
        // Add more address tests if needed
        #10;
        
        // End simulation after a short delay
        $finish;
    end

    // Monitor output signals for debugging
    initial begin
        $monitor("At time %t, Address = %d, Instruction = %h", $time, address, instruction);
    end

    // Optionally dump the waveform for viewing in a simulator
    initial begin
        $dumpfile("instruction_memory_tb.vcd");
        $dumpvars(0, instruction_memory_tb);
    end

endmodule