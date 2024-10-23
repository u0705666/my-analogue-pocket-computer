`timescale 1ns/1ps

module instruction_memory_tb;

    // Parameters
    parameter DATA_WIDTH = 32;
    parameter ADDR_WIDTH = 4;
    
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
        // Check instruction at address 0 is "04030201"
        assert(instruction == 32'h04030201) else $fatal(1, "instruction at address 0 is not 04030201");

        address = 4; // Should fetch the instruction at address 4
        
        #10;
        assert(instruction == 32'h08070605) else $fatal(1, "instruction at address 4 is not 08070605");

        address = 8; // Should fetch the instruction at address 8
        
        #10;
        assert(instruction == 32'h0c0b0a09) else $fatal(1, "instruction at address 8 is not 0c0b0a09");

        address = 12; // Should fetch the instruction at address 12
        
        // Add more address tests if needed
        #10;
        assert(instruction == 32'h100f0e0d) else $fatal(1, "instruction at address 12 is not 100f0e0d");
        
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