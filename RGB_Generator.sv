module vga_generator(input logic active_draw,
							input logic [3:0] r,
							input logic [3:0] g,
							input logic [3:0] b,
							output logic [3:0] r_out,
							output logic [3:0] g_out,
							output logic [3:0] b_out);

always_comb
	if(active_draw)
	begin
		r_out = r;
		g_out = g;
		b_out = b;
	end
	else
	begin
		r_out = 4'b0000;
		g_out = 4'b0000;
		b_out = 4'b0000;
	end
endmodule