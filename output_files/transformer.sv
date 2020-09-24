module transformer (input logic clk_1Hz,
						  input logic reset,
						  input logic [11:0] controller_state,
						  output logic [9:0] sprite_x,
						  output logic [8:0] sprite_y);
always @ (posedge clk_1Hz)
begin
	if(reset)
	begin
		sprite_x = 10'b1000000000;
		sprite_y = 9'b100000000;
	end
	else
	begin
		if(controller_state[4])
			sprite_y = sprite_y + 1;
		if(controller_state[5])
			sprite_y = sprite_y - 1;
		if(controller_state[6])
			sprite_x = sprite_x - 1;
		if(controller_state[7])
			sprite_x = sprite_x + 1;
	end
end
endmodule
		
		