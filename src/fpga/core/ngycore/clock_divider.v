`default_nettype none

module clock_divider #(
    parameter DIVIDER = 74000000/10
)(
    input wire clk_74,
    input wire reset_n,
    output reg clk_out
);

    reg [31:0] counter;

    always @(posedge clk_74 or negedge reset_n) begin
        if (~reset_n) begin
            counter <= 0;
            clk_out <= 0;
        end else begin
            if (counter == DIVIDER-1) begin
                counter <= 0;
                clk_out <= ~clk_out;
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule