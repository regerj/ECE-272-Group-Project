module rgb_decoder (input logic clk,
						  input logic reset,
						  input wire [11:0] controller_state,
						  input logic [9:0] curr_x,
						  input logic [8:0] curr_y,
						  output logic [3:0] r_out,
						  output logic [3:0] g_out,
						  output logic [3:0] b_out);
						  
reg [9:0] x_pos;
reg [8:0] y_pos;
reg [3:0] r_out_sprite;
reg [3:0] g_out_sprite;
reg [3:0] b_out_sprite;
wire clk_1Hz;
reg [30:0] counter;
reg [30:0] counter2;
reg [30:0] counter3;
reg [7:0] size;

clock_divider_1Hz clk_div_1 (
	.clock (clk),
	.reset (reset),
	.clk_1Hz (clk_1Hz));
	

always @ (posedge clk or posedge reset)
begin
	if(reset)
	begin
		x_pos = 10'b1000000000;
		y_pos = 9'b100000000;
		counter = 31'd0;
		counter2 = 31'd0;
		counter3 = 31'd0;
		r_out_sprite = 4'b1111;
		g_out_sprite = 4'b1111;
		b_out_sprite = 4'b1111;
		size = 8'b000010100;
	end
	else
	begin
		counter = counter + 1;
		counter2 = counter2 + 1;
		counter3 = counter3 + 1;
		if(counter == 31'd100000)
		begin
			if(~controller_state[4])
				y_pos = y_pos - 1;
			if(~controller_state[5])
				y_pos = y_pos + 1;
			if(~controller_state[6])
				x_pos = x_pos - 1;
			if(~controller_state[7])
				x_pos = x_pos + 1;
			counter = 31'd0;
		end
		if(counter2 == 31'd10000000)
		begin
			if(~controller_state[10])
				r_out_sprite = r_out_sprite - 1;
			if(~controller_state[11])
				r_out_sprite = r_out_sprite + 1;
			if(~controller_state[0])
				g_out_sprite = g_out_sprite - 1;
			if(~controller_state[8])
				g_out_sprite = g_out_sprite + 1;
			if(~controller_state[1])
				b_out_sprite = b_out_sprite - 1;
			if(~controller_state[9])
				b_out_sprite = b_out_sprite + 1;
			if(~controller_state[2])
				size = size - 1;
			if(~controller_state[3])
				size = size + 1;
			counter2 = 31'd0;
		end
		if(curr_x > x_pos - size & curr_x < x_pos + size)
		begin
			if(curr_y > y_pos - size & curr_y < y_pos + size)
			begin
				r_out = r_out_sprite;
				g_out = g_out_sprite;
				b_out = b_out_sprite;
			end
		end
		else
		begin
			r_out <= 4'b0000;
			g_out <= 4'b0000;
			b_out <= 4'b0000;
		end
	end
end
endmodule