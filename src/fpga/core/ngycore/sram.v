`default_nettype none

module sram_module #(
  parameter DEPTH = 1200,              // 30x40 grid = 1200 cells
  parameter ADDR_WIDTH = 11            // ceil(log2(1200)) = 11 bits
)(
  input  wire                   clk_74a,
  input  wire                   wr_en,
  input  wire [ADDR_WIDTH-1:0]    addr,
  input  wire                   data_in,
  output reg                    data_out
);
  // Use synthesis attribute to hint using M10K block memory
  reg mem [0:DEPTH-1] /* synthesis ramstyle = "M10K" */;
  
  always @(posedge clk_74a) begin
    if (wr_en) begin
      mem[addr] <= data_in;
    end 
    else begin
        data_out <= mem[addr];
    end
  end
endmodule