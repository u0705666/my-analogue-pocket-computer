`default_nettype none

module dual_port_sram(
    input  wire        clk,           // Single clock for both ports and SRAM
    // Port A Interface
    input  wire [16:0] sram_a_A,
    input  wire [15:0] sram_dq_in_A,
    output reg  [15:0] sram_dq_out_A,
    input  wire        sram_we_A,
    input  wire        sram_re_A,
    // Port B Interface
    input  wire [16:0] sram_a_B,
    input  wire [15:0] sram_dq_in_B,
    output reg  [15:0] sram_dq_out_B,
    input  wire        sram_we_B,
    input  wire        sram_re_B,
    // SRAM Interface
    output reg  [16:0] sram_a,
    inout  wire [15:0] sram_dq,
    output reg         sram_oe_n,
    output reg         sram_we_n,
    output wire        sram_ub_n,
    output wire        sram_lb_n
);

// Byte enables (assuming full word access)
assign sram_ub_n = 0;
assign sram_lb_n = 0;

// Internal signals
reg       sram_dq_oe;
reg [15:0] sram_dq_out;
assign sram_dq = sram_dq_oe ? sram_dq_out : 16'bz;

// Arbitration signals
reg [1:0] current_port;  // 0: None, 1: Port A, 2: Port B
reg last_served_port;

always @(posedge clk) begin
    // Default values
    sram_we_n  <= 1;
    sram_oe_n  <= 1;
    sram_dq_oe <= 0;
    sram_dq_out <= 16'b0;
    sram_a     <= 17'b0;
    if (current_port != 0) begin
        last_served_port <= (current_port == 1) ? 0 : 1;
    end

    // Arbitration Logic
    if (sram_we_A || sram_re_A) begin
        if (sram_we_B || sram_re_B) begin
            current_port <= last_served_port ? 1 : 2;
        end else begin
            current_port <= 1; //  only port a requests access
        end
    end else if (sram_we_B || sram_re_B) begin
        current_port <= 2; // only Port B request access
    end else begin
        current_port <= 0; // No access
    end

    // Handle Port A Access
    if (current_port == 1) begin
        sram_a <= sram_a_A;
        if (sram_we_A) begin
            sram_we_n  <= 0;
            sram_dq_oe <= 1;
            sram_dq_out <= sram_dq_in_A;
        end else if (sram_re_A) begin
            sram_oe_n <= 0;
            sram_dq_oe <= 0;
        end
    end
    // Handle Port B Access
    else if (current_port == 2) begin
        sram_a <= sram_a_B;
        if (sram_we_B) begin
            sram_we_n  <= 0;
            sram_dq_oe <= 1;
            sram_dq_out <= sram_dq_in_B;
        end else if (sram_re_B) begin
            sram_oe_n <= 0;
            sram_dq_oe <= 0;
        end
    end

    // Read Data Handling
    if (current_port == 1 && sram_re_A) begin
        sram_dq_out_A <= sram_dq;
    end else if (current_port == 2 && sram_re_B) begin
        sram_dq_out_B <= sram_dq;
    end
end

endmodule
