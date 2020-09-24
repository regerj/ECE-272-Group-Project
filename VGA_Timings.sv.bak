module VGA (input logic clk,
				input logic strobe,
				input logic reset,
				output logic hsync,
				output logic vsync,
				output logic active_draw,
				output logic finished,
				output logic [9:0] curr_x,
				output logic [9:0] curr_y);

// Timing parameters set here
parameter hsync_begin = 16;
parameter hsync_end = 112;
parameter h_active = 160;
parameter vsync_begin = 490;
parameter vsync_end = 492;
parameter v_active_end = 480;
parameter pixel_line = 800;
parameter line_screen = 525;

reg [9:0] h_count;
reg [9:0] v_count;

assign hsync = ~((h_count >= hsync_begin) & (h_count < hsync_end));
assign vsync = ~((v_count >= vsync_begin) & (v_count < vsync_end));
assign curr_x = (h_count < h_active) ? 0 : (h_count - h_active);
assign curr_y = (v_count >= v_active_end) ? (v_active_end - 1) : (v_count);

assign active_draw = ~((h_count < h_active) | (v_count > v_active_end - 1));
assign finished = ((v_count == line_screen - 1) & (h_count == pixel_line));

always @ (posedge clk)
begin
	if(reset)
	begin
		h_count <= 0;
		v_count <= 0;
	end
	if(strobe)
	begin
		if(h_count == pixel_line)
		begin
			h_count <= 0;
			v_count <= v_count + 1;
		end
		else
			h_count <= h_count + 1;
			
		if(v_count == line_screen)
			v_count <= 0;
	end
end
endmodule