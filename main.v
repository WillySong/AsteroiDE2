// Part 2 skeleton

module main
	(
		CLOCK_50,						//	On Board 50 MHz
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input		CLOCK_50;				//	50 MHz


	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]


	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;
	wire [3:0] count;
	wire resetn;
	assign colour = 3'b111;
	assign resetn = 1'b1;


	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive tyhe monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
			
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
		
	counter(CLOCK_50, count);
	drawRight(CLOCK_50, x, y, writeEn, count);
endmodule

module counter(CLOCK_50, count);
	input CLOCK_50;
	output reg [3:0] count;
	always@(posedge CLOCK_50)
	begin
		if (count == 4'b1110)
			count <= 4'b0000;
		else
			count = count + 1'b1;
	end

endmodule

module drawUp(clk, x, y, writeEn, count);
    input [3:0] count;
	 input clk;
	 output reg [7:0] x;
	 output reg [6:0] y;
	 output reg writeEn;
	 
	 always@(posedge clk)
	 begin
	     case (count[3:0])
				4'b0000: writeEn = 1'b0;
		      4'b0001:
				begin
				    x = 8'b1010000;
					 y = 7'b111100;
					 writeEn = 1'b1;
				end
				4'b0010: writeEn = 1'b0;
				4'b0011:
				begin
				    x = 8'b1001111;
					 y = 7'b111101;
					 writeEn = 1'b1;
				end
				4'b0100:
				begin
				    x = 8'b1010000;
					 y = 7'b111101;
					 writeEn = 1'b1;
				end
				4'b0101:
				begin
				    x = 8'b1010001;
					 y = 7'b111101;
					 writeEn = 1'b1;
				end
				4'b0110:
				begin
				    x = 8'b1001111;
					 y = 7'b111110;
					 writeEn = 1'b1;
				end
				4'b0111: writeEn = 1'b0;
				4'b1000:
				begin
				    x = 8'b1010001;
					 y = 7'b111110;
					 writeEn = 1'b1;
				end
				default: writeEn = 1'b0;
			endcase
		end
endmodule

module drawDown(clk, x, y, writeEn, count);
    input [3:0] count;
	 input clk;
	 output reg [7:0] x;
	 output reg [6:0] y;
	 output reg writeEn;
	 
	 always@(posedge clk)
	 begin
	     case (count[3:0])
				4'b0000:
				begin
				    x = 8'b1010000;
					 y = 7'b111100;
					 writeEn = 1'b1;
				end
		      4'b0001: writeEn = 1'b0;
				4'b0010:
				begin
				    x = 8'b1010010;
					 y = 7'b111100;
					 writeEn = 1'b1;
				end
				4'b0011:
				begin
				    x = 8'b1010000;
					 y = 7'b111101;
					 writeEn = 1'b1;
				end
				4'b0100:
				begin
				    x = 8'b1010001;
					 y = 7'b111101;
					 writeEn = 1'b1;
				end
				4'b0101:
				begin
				    x = 8'b1010001;
					 y = 7'b111101;
					 writeEn = 1'b1;
				end
				4'b0110: writeEn = 1'b0;
				4'b0111:
				begin
				    x = 8'b1010001;
					 y = 7'b111101;
					 writeEn = 1'b1;
				end
				4'b1000: writeEn = 1'b0;
				default: writeEn = 1'b0;
			endcase
		end
endmodule

module drawLeft(clk, x, y, writeEn, count);
    input [3:0] count;
	 input clk;
	 output reg [7:0] x;
	 output reg [6:0] y;
	 output reg writeEn;
	 
	 always@(posedge clk)
	 begin
	     case (count[3:0])
				4'b0000: writeEn = 1'b0;
		      4'b0001:
				begin
				    x = 8'b1010001;
					 y = 7'b111100;
					 writeEn = 1'b1;
				end				
				4'b0010:
				begin
				    x = 8'b1010010;
					 y = 7'b111100;
					 writeEn = 1'b1;
				end
				4'b0011:
				begin
				    x = 8'b1010000;
					 y = 7'b111101;
					 writeEn = 1'b1;
				end
				4'b0100: 
				begin
				    x = 8'b1010001;
					 y = 7'b111101;
					 writeEn = 1'b1;
				end
				4'b0101: writeEn = 1'b0;				
				4'b0110: writeEn = 1'b0;
				4'b0111:
				begin
				    x = 8'b1010001;
					 y = 7'b111110;
					 writeEn = 1'b1;
				end
				4'b1000:
				begin
				    x = 8'b1010010;
					 y = 7'b111110;
					 writeEn = 1'b1;
				end
				default: writeEn = 1'b0;
			endcase
		end
endmodule			

module drawRight(clk, x, y, writeEn, count);
    input [3:0] count;
	 input clk;
	 output reg [7:0] x;
	 output reg [6:0] y;
	 output reg writeEn;
	 
	 always@(posedge clk)
	 begin
	     case (count[3:0])
				4'b0000:
				begin
				    x = 8'b1010000;
					 y = 7'b111100;
					 writeEn = 1'b1;
				end
		      4'b0001:
				begin
				    x = 8'b1010001;
					 y = 7'b111100;
					 writeEn = 1'b1;
				end				
				4'b0010: writeEn = 1'b0;
				4'b0011: writeEn = 1'b0;
				4'b0100: 
				begin
				    x = 8'b1010001;
					 y = 7'b111101;
					 writeEn = 1'b1;
				end
				4'b0101: 
				begin
				    x = 8'b1010010;
					 y = 7'b111101;
					 writeEn = 1'b1;
				end				
				4'b0110:
				begin
				    x = 8'b1010000;
					 y = 7'b111110;
					 writeEn = 1'b1;
				end
				4'b0111:
				begin
				    x = 8'b1010001;
					 y = 7'b111110;
					 writeEn = 1'b1;
				end
				4'b1000: writeEn = 1'b0;
				default: writeEn = 1'b0;
			endcase
		end
endmodule

module datapath(xIN, yIN, colourIn, resetN, yIncrement, xIncrement, xOut,yOut,colourOut, clock);
	// set inputs
	input[6:0] xIN, yIN;
	input[2:0] colourIn;
	input resetN;
	input [1:0] yIncrement, xIncrement;
	input clock;
	// Set outputs
	output reg [7:0] xOut;
	output reg [6:0] yOut;
	output reg [2:0] colourOut;
	// Handle possible y overflow to cary over to top of screen
	reg [7:0] y;
	// Handle assignments on clock posedge
	always@(posedge clock, negedge resetN)
	begin
		if (~resetN)
			begin
				xOut = 7'd0;
				yOut = 6'd0;
				colourOut = 2'd0;
			end
		else
			begin
				y = yIN + yIncrement;
				xOut = xIN + xIncrement;
				yOut = y[6:0];
				colourOut = colourIn;
			end				
	end
endmodule


module control(go, resetN, yIncrement, xIncrement, plot, clock);
	input go;
	input resetN;
	input clock;
	output reg  plot;
	output reg [1:0] yIncrement, xIncrement;

	reg [4:0] current_state, next_state;
	// Note FSM basically a counter that halts on stop until go is recieved again
	localparam  Y_0_Y_0 = 5'd0,
					Y_0_X_1 = 5'd1,
					Y_0_X_2 = 5'd2,
					Y_0_X_3 = 5'd3,
					Y_1_Y_0 = 5'd4,
					Y_1_X_1 = 5'd5,
					Y_1_X_2 = 5'd6,
					Y_1_X_3 = 5'd7,
					Y_2_Y_0 = 5'd8,
					Y_2_X_1 = 5'd9,
					Y_2_X_2 = 5'd10,
					Y_2_X_3 = 5'd11,
					Y_3_Y_0 = 5'd12,
					Y_3_X_1 = 5'd13,
					Y_3_X_2 = 5'd14,
					Y_3_X_3 = 5'd15,
					STOP = 5'd16;

	// Next state logic aka our state table
	always@(posedge clock)
	begin: state_table
			case (current_state)
				STOP: begin
						if (go) next_state = Y_0_Y_0;
						else next_state = STOP;
						end
				default: next_state = current_state + 1'b1;  // Since states are linear move to next state
			endcase
	end // state_table


	// Output logic aka all of our datapath control signals
	always @(*)
	begin: enable_signals
			// By default make all our signals 0
			// plot = 1'b0;
			// yIncrement = 2'd0;
			// xIncrement = 2'd0;
			case (current_state)
					STOP: begin // Do R <- A + C
						plot = 1'b0;
						yIncrement = 2'd0;
						xIncrement = 2'd0;
					end
					default: begin
						plot = 1'b1;
						yIncrement = current_state[3:2];
						xIncrement = current_state[1:0];
					end
			endcase
	end // enable_signals

	// current_state registers
	always@(posedge clock)
	begin: state_FFs
			if(!resetN)
				begin
					current_state <= STOP;
				end
			else
					current_state <= next_state;
	end // state_FFS
endmodule
