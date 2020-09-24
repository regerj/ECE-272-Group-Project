module clock_divider_1Hz (input logic clock,
		    input logic reset,
		    output logic clk_1Hz);

reg [27:0] counter;

always@(posedge reset or posedge clock)
begin
	if (reset == 1)
	begin
		clk_1Hz <= 0;
		counter <= 0;
	end
	else
	begin
		counter <= counter + 1;
		if(counter == 25_000_000)
		begin
			counter <= 0;
			clk_1Hz <= ~clk_1Hz;
		end
	end
end
endmodule