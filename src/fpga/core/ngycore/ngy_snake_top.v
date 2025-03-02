`default_nettype none

module ngy_snake_top #(
    parameter RAM_LENGTH = 1199, 
    parameter GRID_ROWS = 30, 
    parameter GRID_COLS = 40
)(
    input wire clk_74a, // 74mhz clock
    input wire reset_n,
    input wire [15:0] cont1_key,
    output reg [0:RAM_LENGTH-1] grid_ram // this represents a 30x40 led screen ram
);

    wire dpad_up = cont1_key[0];
    wire dpad_down = cont1_key[1];
    wire dpad_left = cont1_key[2];
    wire dpad_right = cont1_key[3];

    //generate a 10hz clock from the 74mhz clock
    wire clk_10hz;

    clock_divider #(
        .DIVIDER(74000000/10)) 
    cd1 (
        .clk_74(clk_74a),
        .reset_n(reset_n),
        .clk_out(clk_10hz)
    );

    // Snake parameters
    localparam SNAKE_INIT_LENGTH = 5;
    localparam SNAKE_MAX_LENGTH = 15;
    localparam SNAKE_SPEED = 5; // pixels per second

    // Snake state
    reg [5:0] snake_length = SNAKE_INIT_LENGTH;
    reg [5:0] snake_x [0:SNAKE_MAX_LENGTH-1];
    reg [5:0] snake_y [0:SNAKE_MAX_LENGTH-1];
    reg [1:0] snake_dir = 2'b00; // 00: right, 01: down, 10: left, 11: up
    reg [1:0] snake_next_dir = 2'b00; // new direction state register


    // Initial snake position
    initial begin
        integer i;
        for (i = 0; i < SNAKE_INIT_LENGTH; i = i + 1) begin
            snake_x[i] = 20 + i;
            snake_y[i] = 15;
        end
    end

    // Update direction based on input
    always @(posedge clk_74a or negedge reset_n) begin
        if (!reset_n) begin
            snake_next_dir <= 2'b00;
        end else begin
            if (dpad_up && snake_dir != 2'b01) snake_next_dir <= 2'b11;
            else if (dpad_down && snake_dir != 2'b11) snake_next_dir <= 2'b01;
            else if (dpad_left && snake_dir != 2'b00) snake_next_dir <= 2'b10;
            else if (dpad_right && snake_dir != 2'b10) snake_next_dir <= 2'b00;
        end
    end

    // Move snake
    always @(posedge clk_10hz or negedge reset_n) begin
        integer i;
        if (!reset_n) begin
            // Reset snake position and length
            snake_length <= SNAKE_INIT_LENGTH;
            snake_dir <= 2'b00;
            for (i = 0; i < SNAKE_INIT_LENGTH; i = i + 1) begin
                snake_x[i] <= 20 + i;
                snake_y[i] <= 15;
            end
        end else begin
            // Move snake body
            for (i = SNAKE_MAX_LENGTH-1; i > 0; i = i - 1) begin
                snake_x[i] <= snake_x[i-1];
                snake_y[i] <= snake_y[i-1];
            end

            snake_dir <= snake_next_dir;

            // Move snake head
            case (snake_next_dir)
                2'b00: snake_x[0] <= snake_x[0] + 1; // right
                2'b01: snake_y[0] <= snake_y[0] + 1; // down
                2'b10: snake_x[0] <= snake_x[0] - 1; // left
                2'b11: snake_y[0] <= snake_y[0] - 1; // up
            endcase
        end
    end

    reg [1:0] ram_update_state;
    reg [10:0] grid_ram_index;
    reg [3:0] snake_index;

    // Update grid RAM
    // always @(posedge clk_74a or negedge reset_n) begin
    //     integer i, j;
    //     // Clear grid
    //     for (i = 0; i < GRID_ROWS; i = i + 1) begin
    //         for (j = 0; j < GRID_COLS; j = j + 1) begin
    //             grid_ram[i * GRID_COLS + j] <= 0;
    //         end
    //     end
    //     // Draw snake
    //     for (i = 0; i < snake_length; i = i + 1) begin
    //         if (i < SNAKE_MAX_LENGTH) begin
    //             grid_ram[snake_y[i] * GRID_COLS + snake_x[i]] <= 1;
    //         end
    //     end
    // end

    always @(posedge clk_74a or negedge reset_n) begin
        if (!reset_n) begin
            ram_update_state <= 2'b00;
            grid_ram_index <= 11'b0;
        end else begin
            case (ram_update_state)
                2'b00: begin
                    grid_ram_index <= 11'b0;
                    ram_update_state <= 2'b01;
                end
                2'b01: begin //clear grid
                    grid_ram[grid_ram_index] <= 0;
                    grid_ram_index <= grid_ram_index + 1;
                    if (grid_ram_index == RAM_LENGTH-1) begin
                        ram_update_state <= 2'b10;
                        snake_index <= 0;
                    end
                end
                2'b10: begin //draw snake
                    // for (i = 0; i < snake_length; i = i + 1) begin
                    //     if (i < SNAKE_MAX_LENGTH) begin 
                    //         grid_ram[snake_y[i] * GRID_COLS + snake_x[i]] <= 1;
                    //     end
                    // end
                    if (snake_index < snake_length-1 && snake_index < SNAKE_MAX_LENGTH) begin
                        grid_ram[snake_y[snake_index] * GRID_COLS + snake_x[snake_index]] <= 1;
                        snake_index <= snake_index + 1;
                    end else begin
                        ram_update_state <= 2'b00;
                    end
                end
                2'b11: begin //reset to 00 for now
                    ram_update_state <= 2'b00;
                end
            endcase
        end
    end
endmodule