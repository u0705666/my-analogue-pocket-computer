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
    reg [10:0] cursor_pos;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        // Reset logic to initialize the grid
        for (i = 0; i < GRID_ROWS; i = i + 1) begin
            for (j = 0; j < GRID_COLS; j = j + 1) begin
				grid_ram[i*GRID_COLS + j] <= 0; // initialize to black
            end
        end
        cursor_pos <= 0;
    end else begin
        // Normal operation
        if (one_second) begin
            grid_ram[cursor_pos] <= 1;
            cursor_pos <= cursor_pos + 1;
        end
    end
end

//add a 1s counter, for each second, I want to highlight pixel one by one.
localparam COUNTER_MAX = 74000000 - 1;
reg one_second;

reg [31:0] counter;


    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            counter <= 0;
            one_second <= 0;
        end else begin
            if (counter == COUNTER_MAX) begin
                counter <= 0;
                one_second <= 1;  // Generate 1-second pulse
            end else begin
                counter <= counter + 1;
                one_second <= 0;
            end
        end
    end

endmodule