module top_level(input logic clk,
					  input logic [1:0] r_in,
					  input logic [1:0] g_in,
					  input logic [1:0] b_in,
					  input logic reset,
					  output logic v_sync,
					  output logic h_sync,
					  output logic [3:0] r,
					  output logic [3:0] g,
					  output logic [3:0] b);

wire clk_25MHz, active_draw;
reg [3:0] r_reg;
reg [3:0] g_reg;
reg [3:0] b_reg;
					  
clockdivider my_clk_div (
	.clock (clk),
	.reset (reset),
	.clk_25MHz (clk_25MHz));
	
VGA my_VGA (
	.clk (clk),
	.strobe (clk_25MHz),
	.reset (reset),
	.hsync (h_sync),
	.vsync (v_sync),
	.active_draw (active_draw));

rgb_decoder my_decoder (
	.clk (clk),
	.r_in (r_in),
	.g_in (g_in),
	.b_in (b_in),
	.r_out (r_reg),
	.g_out (g_reg),
	.b_out (b_reg));
	
vga_generator my_generator (
	.active_draw (active_draw),
	.r (r_reg),
	.g (g_reg),
	.b (b_reg),
	.r_out (r),
	.g_out (g),
	.b_out (b));
endmodule