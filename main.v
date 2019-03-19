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

module draw(key_press, clk, count, x, y, writeEn, direction, colour);
    input [3:0] count;
	 output reg [2:0] colour;
	 input clk;
	 input [3:0] key_press;
	 output reg [7:0] x;
	 output reg [6:0] y;
	 output reg writeEn;
	 output reg [1:0] direction;
	 reg [7:0] i;
	 reg [6:0] j;
	 reg [3:0] current;
	 always@(posedge clk)
	 if (current != key_press)
	 begin
		colour = 3'b000;	
		current = key_press;
   	end
	end
		else
		begin
	     if (key_press == 4'b0100) //if w is pressed, draw ship in up direction
		  begin
			current = key_press;
			colour = 3'b111;
		     direction = 2'b00;
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
			else if (key_press == 4'b0011) // if s key is pressed, draw ship in down direction
		   begin
				current = key_press;
				colour = 3'b111;
		     direction = 2'b01;
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
			else if (key_press == 4'b0001) // if a key is pressed, draw ship in left direction
			begin
				current = key_press;
				colour = 3'b111;
		     direction = 2'b10;
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
			else if (key_press == 4'b0010) // if d key is pressed, draw ship in right direction
			begin
				current = key_press;
				colour = 3'b111;
			  direction = 2'b11;
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
			else if (key_press == 4'b0101) // if space is pressed, shoot
			begin
			colour = 3'b111;
				writeEn = 1'b1;
				x = 7'b1010000;
				y = 6'b111100;
				if (direction == 2'b00) // up
					begin
						if (y >= 1'b0)
							y = y - 1'b1;	
					end
				else if (direction == 2'b01) // down
					begin
						if (y <= 3'd120)
							y = y + 1'b1;
					end		
				else if (direction == 2'b11) // left
					begin
						if (x >= 1'b0)
							x <= x - 1'b1;	
					end
				else if (direction == 2'b10) // right
					begin
						if (y <= 3'd160)
							x <= x + 1'b1;
					end
			end
			
			else
			begin
				
			end
		end
endmodule

//module drawDown(key_press, clk, count, x, y, writeEn, direction);
//     input [3:0] count;
//	 input clk;
//	 input [3:0] key_press;
//	 output reg [7:0] x;
//	 output reg [6:0] y;
//	 output reg writeEn;
//	 output reg [1:0] direction;
//
//	 always@(posedge clk)
//	 begin
//	     