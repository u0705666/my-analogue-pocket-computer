`default_nettype none
module pixel_driver(
    input wire [9:0] visible_x,
    input wire [9:0] visible_y,
    input wire [0:1199] grid_ram,
    output reg pixel_state,
    input wire clk_74a
);

	localparam CELL_WIDTH = 8;    // Width of each cell in pixels
	localparam CELL_HEIGHT = 8;   // Height of each cell in pixels
	localparam GRID_COLS = 40;     // Number of columns
	localparam GRID_ROWS = 30;     // Number of rows
	localparam TOTAL_CELLS = GRID_ROWS * GRID_COLS;

    reg [5:0] cell_col;
    reg [4:0] cell_row;
    reg [3:0] cell_pixel_x;
    reg [3:0] cell_pixel_y;

    always @(*) begin
        cell_col = visible_x / CELL_WIDTH;
        cell_row = visible_y / CELL_HEIGHT;

        if (cell_col < GRID_COLS && cell_row < GRID_ROWS) begin
            pixel_state = grid_ram[cell_row * GRID_COLS + cell_col];
        end else begin
            pixel_state = 1'b0;
        end
    end

endmodule