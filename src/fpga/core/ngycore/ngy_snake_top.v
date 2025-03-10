`default_nettype none

module ngy_snake_top (
    input wire clk_74a, // 74mhz clock
    input wire reset_n,
    input wire [15:0] cont1_key,
    input wire [9:0]	visible_x,
    input wire [9:0]	visible_y,
    output wire pixel_state,

    output wire [16:0] sram_chip_addr,
    inout wire [15:0] sram_chip_data,
    output wire sram_chip_oe_n,
    output wire sram_chip_we_n,
    output wire sram_chip_ub_n,
    output wire sram_chip_lb_n
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

    //screen parameters
	localparam CELL_WIDTH = 8;    // Width of each cell in pixels
	localparam CELL_HEIGHT = 8;   // Height of each cell in pixels
	localparam GRID_COLS = 40;     // Number of columns
	localparam GRID_ROWS = 30;     // Number of rows
	localparam RAM_LENGTH = GRID_ROWS * GRID_COLS;

    reg sram_wr_en;
    wire [10:0] sram_addr;
    reg sram_data_in;
    wire sram_data_out;

    assign sram_addr = sram_wr_en ? sram_write_addr : sram_read_addr;
    assign sram_chip_addr = {6'b0, sram_addr};
    assign sram_chip_data = sram_wr_en ? {15'b0, sram_data_in} : 16'bz;
    assign sram_data_out = sram_chip_data[0];
    assign sram_chip_we_n = ~sram_wr_en;
    assign sram_chip_oe_n = sram_wr_en;
    assign sram_chip_ub_n = 1'b0;
    assign sram_chip_lb_n = 1'b0;



    // sram_module sram_module_inst (
    //     .clk_74a(clk_74a),
    //     .wr_en(sram_wr_en),
    //     .addr(sram_addr),
    //     .data_in(sram_data_in),
    //     .data_out(sram_data_out)
    // );

    wire [10:0] sram_read_addr; // for read data from sram to pixel driver
    reg [10:0] sram_write_addr; // for write data to sram from snake

    pixel_driver pd1(
		.visible_x(visible_x),
		.visible_y(visible_y),
		.pixel_state(pixel_state),
		.clk_74a(clk_74a),
        .sram_addr(sram_read_addr),
        .sram_data_out(sram_data_out),
        .is_sram_available_to_read(~sram_wr_en)
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


   // Snake movement detection
    reg snake_moved_toggle = 0;  // Toggle signal in 10Hz domain
    reg [1:0] snake_moved_sync;  // Synchronizer in 74MHz domain

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
            snake_moved_toggle <= 0;
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

            // Detect snake movement
            snake_moved_toggle <= ~snake_moved_toggle;
        end
    end

    // Synchronize to 74MHz domain
    always @(posedge clk_74a or negedge reset_n) begin
        if (!reset_n) begin
            snake_moved_sync <= 2'b00;
        end else begin
            snake_moved_sync <= {snake_moved_sync[0], snake_moved_toggle};
        end
    end

    // Generate pulse when toggle changes (74MHz domain)
    wire snake_moved_pulse = (snake_moved_sync[1] ^ snake_moved_sync[0]);


    reg [1:0] ram_update_state;
    reg [3:0] snake_index;


    always @(posedge clk_74a or negedge reset_n) begin
        if (!reset_n) begin
            ram_update_state <= 2'b00;
        end else begin
            case (ram_update_state)
                2'b00: begin
                    sram_write_addr <= 11'b0;
                    sram_wr_en <= 1'b1;
                    ram_update_state <= 2'b01;
                end
                2'b01: begin //clear grid
                    sram_data_in <= 0;
                    sram_write_addr <= sram_write_addr + 1;
                    if (sram_write_addr == RAM_LENGTH-1) begin
                        ram_update_state <= 2'b10;
                        snake_index <= 0;
                    end
                end
                2'b10: begin //draw snake
                    if (snake_index < snake_length-1 && snake_index < SNAKE_MAX_LENGTH) begin
                        sram_write_addr <= snake_y[snake_index] * GRID_COLS + snake_x[snake_index];
                        sram_data_in <= 1;
                        snake_index <= snake_index + 1;
                    end else begin
                        ram_update_state <= 2'b11;
                    end
                end
                2'b11: begin //wait for next snake move
                    sram_wr_en <= 1'b0;
                    if (snake_moved_pulse) begin
                        ram_update_state <= 2'b00;
                    end
                end
            endcase
        end
    end
endmodule