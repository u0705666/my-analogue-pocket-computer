`default_nettype none

module video_driver #(
    parameter RAM_LENGTH = 1199, 
    parameter GRID_ROWS = 30, 
    parameter GRID_COLS = 40
)(
    input wire clk,
    input wire reset_n,
    output reg [RAM_LENGTH-1:0] grid_ram
);


	integer i, j;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        // Reset logic to initialize the grid
        for (i = 0; i < GRID_ROWS; i = i + 1) begin
            for (j = 0; j < GRID_COLS; j = j + 1) begin
				grid_ram[i*GRID_COLS + j] <= (i+j)%2; // initialize to chessboard like background
            end
        end
    end else begin
        // Normal operation
    end
end


endmodule