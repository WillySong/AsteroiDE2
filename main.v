// a counter for drawing the spaceship
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

// clock_divider slows down the CLOCK_50. it is for bullet motion
module clock_divider(clock, resetn, Enable);
	input clock, resetn;
	output reg Enable;
	reg [27:0] q;
	always @(posedge clock) // triggered every time clock rises
	begin
		if (resetn == 1'b0) // when resetn is 0...
		begin
			Enable <= 0;
			q <= 0; // set q to 0
		end
		else if (q == 28'd99999999) // ...otherwise if q is the maximum counter value
		begin	
			Enable <= 1;
			q <= 0; // reset q to 0
		end
		else // ...otherwise update q (only when Enable is 1)
		begin
			Enable <= 0;
			q <= q + 1'b1; // increment q
		end
	end
endmodule

module drawUp(clk, count, x, y, writeEn, direction);
    input [3:0] count;
	 input clk;
	 output reg [7:0] x;
	 output reg [6:0] y;
	 output reg writeEn;
	 output [1:0] direction;
	 
	 assign direction = 2'b00;
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

module drawDown(clk, count, x, y, writeEn, direction);
     input [3:0] count;
	 input clk;
	 output reg [7:0] x;
	 output reg [6:0] y;
	 output reg writeEn;
	 output [1:0] direction;
	 assign direction = 2'b01;
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

module drawLeft(clk, count, x, y, writeEn, direction);
    input [3:0] count;
	 input clk;
	 output reg [7:0] x;
	 output reg [6:0] y;
	 output reg writeEn;
	 output [1:0] direction;
	 assign direction = 2'b11;
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

module drawRight(clk, count, x, y, writeEn, direction);
    input [3:0] count;
	 input clk;
	 output reg [7:0] x;
	 output reg [6:0] y;
	 output reg writeEn;
	 output [1:0] direction;
	 assign direction = 2'b10;
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



//module control(go, resetN, yIncrement, xIncrement, plot, clock);
//	input go;
//	input resetN;
//	input clock;
//	output reg  plot;
//	output reg [1:0] yIncrement, xIncrement;
//
//	reg [4:0] current_state, next_state;
//	// Note FSM basically a counter that halts on stop until go is recieved again
//	localparam  Y_0_Y_0 = 5'd0,
//					Y_0_X_1 = 5'd1,
//					Y_0_X_2 = 5'd2,
//					Y_0_X_3 = 5'd3,
//					Y_1_Y_0 = 5'd4,
//					Y_1_X_1 = 5'd5,
//					Y_1_X_2 = 5'd6,
//					Y_1_X_3 = 5'd7,
//					Y_2_Y_0 = 5'd8,
//					Y_2_X_1 = 5'd9,
//					Y_2_X_2 = 5'd10,
//					Y_2_X_3 = 5'd11,
//					Y_3_Y_0 = 5'd12,
//					Y_3_X_1 = 5'd13,
//					Y_3_X_2 = 5'd14,
//					Y_3_X_3 = 5'd15,
//					STOP = 5'd16;
//
//	// Next state logic aka our state table
//	always@(posedge clock)
//	begin: state_table
//			case (current_state)
//				STOP: begin
//						if (go) next_state = Y_0_Y_0;
//						else next_state = STOP;
//						end
//				default: next_state = current_state + 1'b1;  // Since states are linear move to next state
//			endcase
//	end // state_table
//
//
//	// Output logic aka all of our datapath control signals
//	always @(*)
//	begin: enable_signals
//			// By default make all our signals 0
//			// plot = 1'b0;
//			// yIncrement = 2'd0;
//			// xIncrement = 2'd0;
//			case (current_state)
//					STOP: begin // Do R <- A + C
//						plot = 1'b0;
//						yIncrement = 2'd0;
//						xIncrement = 2'd0;
//					end
//					default: begin
//						plot = 1'b1;
//						yIncrement = current_state[3:2];
//						xIncrement = current_state[1:0];
//					end
//			endcase
//	end // enable_signals
//
//	// current_state registers
//	always@(posedge clock)
//	begin: state_FFs
//			if(!resetN)
//				begin
//					current_state <= STOP;
//				end
//			else
//					current_state <= next_state;
//	end // state_FFS
//endmodule
