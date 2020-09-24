//////////////////////////////////////////////////////////////////////////////////
// Company:        Oregon State University
// Engineer:       Jacob Reger
// 
// Create Date:    05/28/2020 
// Design Name:    SNES Finite State Machine
// Module Name:    fsm_snes
// Project Name:   ECE 271 Group Project
// Target Devices: DE10-Lite FPGA
// Tool versions:  Quartus Prime Lite Edition
// Description:    The communication protocol for the SNES controller can be found
// below this header. This module works by creating a finite state machine to
// track the current state of the data line and decode their booleans to use thier
// inputs.
//
// Dependencies: 
//
// Revision: 0.01 - File creation
// additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////
// SNES controller communication protocol
// Connection interface    ________
//                        |OOOO|OOOD
//                         --------
//                         ^^^^ ^^^
//                         0123 456
// PIN_0 : 5V
// PIN_1 : Clock
// PIN_2 : Latch
// PIN_3 : Data
// PIN_4 : Unused
// PIN_5 : Unused
// PIN_6 : Ground

// The controller protocol explanation:
// FPGA pings latch and controller saves current state of the controller
// FPGA then sends a clock signal of 12 us period through PIN_1
// Controller then transforms clock signal into data signal with 16-bit depth
// Only first 12 bits are used
// Buttons are active-low
//////////////////////////////////////////////////////////////////////////////////


module fsm_snes (input clk,											// 50 MHz clock input from FPGA clock pin
					  input strobe,										// Strobe input from FPGA, sending HIGH requests controller state from controller
					  input data,											// Data input from SNES controller, sends 16-bit depth wave in order {B, Y, SELECT, START, UP, DOWN, LEFT, RIGHT, A, X, LB, RB} with four empty trailing bits
					  output wire [11:0] controller_state,			// Output bus with 12 spots to represent the 12 buttons on the SNES controller
					  output finish,										// Boolean output to indicate finish
					  output idle,											// Boolean output to indicate idle
					  output snes_latch,									// Boolean output to ping latch on SNES controller
					  output snes_clk);									// Boolean output to send clock to SNES controller, this clock has a period of 12 microseconds, and it is transformed into the data line with an identical frequency

parameter s0 = 10'b0101000001;							// Define state 0 in binary code
parameter s1 = 10'b1100000010;							// Define state 1 in binary code
parameter s2 = 10'b0100000100;							// Define state 2 in binary code
parameter s3 = 10'b0000001000;							// Define state 3 in binary code
parameter s4 = 10'b0100010000;							// Define state 4 in binary code
parameter s5 = 10'b0110100000;							// Define state 5 in binary code

reg [9:0] state = s0;										// Register for holding current state data
reg [9:0] delay = 10'd600;									// Register for holding current delay count
reg [3:0] clks = 4'd0;										// Register for holding current clock count
reg [14:0] controller_state_temp = 15'd0;				// Register for holding controller state
wire prefinish = (state[9:0] == s4) ? 1'b1:0;		// Wire to identify if state 4 has been reached
assign snes_latch = state[9];								// Extract latch boolean from state register
assign snes_clk = state[8];								// Extract clk boolean from state register
assign finish = state[7];									// Extract finish boolean from state register
assign idle = state[6];										// Extract idle boolean from state register

					
always @(posedge clk)
begin
	case(state[9:0])
	
	s0:									// Idle state
	begin									
		state <= s0;					// Confirm idle state
		delay <= 10'd600;				// Delay for 12 us
		clks <= 4'd0;					// Initialize clocks counted to zero
		if(strobe == 1)				// Progress gate for when strobing is true
			state <= s1;				// Progress to state 1
	end
	
	s1:									// Pinging latch state
	begin
		state <= s1;					// Confirm latch state
		delay <= delay - 1'b1;		// Decrement delay
		clks <= 4'd1;					// Set clocks counted to one
		if(delay == 10'd0)			// Once delay gets to zero
		begin
			delay <= 10'd300;			// Set delay to 6 us
			state <= s2;				// Progress to state 2
		end
	end
	
	s2:									// Positive duty of snes_clock
	begin
		state <= s2;					// Confirm pos clk state
		delay <= delay - 1'b1;		// Decrement delay
		clks <= clks;					// Confirm clock count
		if(delay == 10'd0)			// Once delay gets to zero
		begin
			delay <= 10'd300;			// Set delay to 6 us
			state <= s3;				// Progress to state 3
		end
	end
	
	s3:									// Negetive duty of snes_clock
	begin
		state <= s3;					// Confirm neg clk state
		delay <= delay - 1'b1;		// Decrement delay
		clks <= clks;					// Confirm clock count
		if(delay == 10'd0)			// Once delay gets to zero
		begin
			clks <= clks + 1'b1;		// Increment clock count
			if(clks < 4'd15)			// As long as clock count is below the 16 bit depth of SNES communication protocol
			begin
				delay <= 10'd300;		// Set delay to 6 us
				state <= s2;			// Progress to state 2
			end
			else							// Otherwise
			begin
				delay <= 10'd600;		// Set delay to 12 us
				state <= s4;			// Progress to state 4
			end
		end
	end
	
	s4:									// State for pinging to dump controller state to outputs
	begin
		state <= s4;					// Confirm prefinish state
		delay <= delay - 1'b1;		// Decrement delay
		clks <= 4'd0;					// Reset clock count
		if(delay == 10'd0)			// Once delay gets to zero
			state <= s5;				// Progress to state 5
	end
	
	s5:									// Finished state
	begin
		state <= s0;					// Reset state to state 0 to await strobe ping
		delay <= 10'd0;				// Reset delay to zero
		clks <= 4'd0;					// Reset clock count to zero
	end
	
	default:								// Default to identical as state 5
	begin
		state <= s0;
		delay <= 10'd0;
		clks <= 4'd0;
	end
	endcase
end

always@(negedge snes_clk)																// At negative edge of snes clk
begin
	controller_state_temp[14:0] <= {data, controller_state_temp[14:1]};	// Dump data into controller state temp
end

always@(posedge prefinish)																// At prefnish state
begin	
	controller_state[11:0] <= controller_state_temp [11:0];					// Dump controller state to output
end
	
endmodule