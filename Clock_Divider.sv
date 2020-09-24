module clockdivider(input logic clock,
						  input logic reset,
						  output logic clk_25MHz);

reg [1:0] counter;

always@(posedge reset or posedge clock)
begin
	if (reset == 1)
	begin
		clk_25MHz <= 0;
		counter <= 0;
	end
	else
	begin
		counter <= counter + 1;
		if(counter == 0)
		begin
			counter <= 0;
			clk_25MHz <= ~clk_25MHz;
		end
	end
end
endmodule