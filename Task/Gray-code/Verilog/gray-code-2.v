`timescale 1ns/10ps
`default_nettype none

module gray_counter #(
    parameter SIZE=4
) (
    input  wire            i_clk,
    input  wire            i_rst_n,
	
    input  wire            i_inc,
	
    output wire [SIZE-1:0] o_count_gray,
    output wire [SIZE-1:0] o_count_binn
);

reg [SIZE-1:0] state_gray;
reg [SIZE-1:0] state_binn;
reg [SIZE-1:0] logic_gray;
reg [SIZE-1:0] logic_binn;

always @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
       state_gray <= 0;
       state_binn <= 0;
    end
    else begin
       state_gray <= logic_gray;
       state_binn <= logic_binn;
    end
end

always @* begin
    logic_binn = state_binn + i_inc;
    logic_gray = (logic_binn>>1) ^ logic_binn;
end

assign o_count_gray = state_gray;
assign o_count_binn = state_binn;

endmodule

`default_nettype none
