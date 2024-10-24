// ALU Control Macros
`define ALU_AND     4'b0000  // 0: AND
`define ALU_OR      4'b0001  // 1: OR
`define ALU_ADD     4'b0010  // 2: ADD
`define ALU_SUB     4'b0110  // 6: SUB
`define ALU_SLT     4'b0111  // 7: Set Less Than
`define ALU_NOR     4'b1100  // 12: NOR

// Additional operations (not used in the given ALU, but common in RISC-V)
`define ALU_XOR     4'b0011  // XOR
`define ALU_SLL     4'b0100  // Shift Left Logical
`define ALU_SRL     4'b0101  // Shift Right Logical
`define ALU_SRA     4'b1000  // Shift Right Arithmetic

