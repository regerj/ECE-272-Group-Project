module top_level(input logic clk,
					  input logic strobe,
					  input logic data,
					  input logic reset,
					  output logic snes_latch,
					  output logic snes_clk,
					  output logic v_sync,
					  output logic h_sync,
					  output logic [3:0] r,
					  output logic [3:0] g,
					  output logic [3:0] b);

reg [11:0] controller_state;
wire clk_25MHz, active_draw;
reg [3:0] r_reg;
reg [3:0] g_reg;
reg [3:0] b_reg;
reg [9:0] curr_x;
reg [8:0] curr_y;

fsm_snes snes_decode (
	.clk (clk),
	.strobe (strobe),
	.data (data),
	.snes_latch (snes_latch),
	.controller_state (controller_state),
	.snes_clk (snes_clk));
					  
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
	.curr_x (curr_x),
	.curr_y (curr_y),
	.active_draw (active_draw));

rgb_decoder my_decoder (
	.clk (clk),
	.controller_state (controller_state),
	.reset (reset),
	.curr_x (curr_x),
	.curr_y (curr_y),
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