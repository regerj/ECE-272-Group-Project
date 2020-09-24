module rgb_decoder (input logic clk,
						  input logic [1:0] r_in,
						  input logic [1:0] g_in,
						  input logic [1:0] b_in,
						  output logic [3:0] r_out,
						  output logic [3:0] g_out,
						  output logic [3:0] b_out);

always @ (posedge clk)
begin
	case(r_in)
		2'b00 :
		begin
			r_out = 4'b0000;
		end
		
		2'b01 :
		begin
			r_out = 4'b0101;
		end
		
		2'b10 :
		begin
			r_out = 4'b1010;
		end
		
		2'b11 :
		begin
			r_out = 4'b1111;
		end
	endcase

	case(g_in)
		2'b00 :
		begin
			g_out = 4'b0000;
		end
		
		2'b01 :
		begin
			g_out = 4'b0101;
		end
		
		2'b10 :
		begin
			g_out = 4'b1010;
		end
		
		2'b11 :
		begin
			g_out = 4'b1111;
		end
	endcase
	
	case(b_in)
		2'b00 :
		begin
			b_out = 4'b0000;
		end
		
		2'b01 :
		begin
			b_out = 4'b0101;
		end
		
		2'b10 :
		begin
			b_out = 4'b1010;
		end
		
		2'b11 :
		begin
			b_out = 4'b1111;
		end
	endcase
end
endmodule
			