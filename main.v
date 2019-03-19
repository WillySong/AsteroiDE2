// a counter for drawing the spaceship
module counter(CLOCK_50, count);
	input CLOCK_50;
	output reg [3:0] count;
	always@(posedge CLOCK_50)
	begin
		if (count == 4'b1111)
			count <= 4'b0000;
		else
			count = count + 1'b1;
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
	 reg [3:0] current;
	 always@(posedge clk)
	 begin
		if (current != key_press)
		begin
			colour = 3'b000;
			if (count < 4'b1111)
			begin
				x = 8'b1001111 + count[1:0];
				y = 7'b111100 + count[3:2];
			end 
			else if (count == 4'b1111)	
				current = key_press;
		end
		
		else
		begin
			if (key_press == 4'b0100) //if w is pressed, draw ship in up direction
			begin
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
				colour = 3'b111;
		     direction = 2'b01;
			  case (count[3:0])
					4'b0000:
					begin
						 x = 8'b1001111;
						 y = 7'b111100;
						 writeEn = 1'b1;
					end
					4'b0001: writeEn = 1'b0;
					4'b0010:
					begin
						 x = 8'b1010001;
						 y = 7'b111100;
						 writeEn = 1'b1;
					end
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
					4'b0110: writeEn = 1'b0;
					4'b0111:
					begin
						 x = 8'b1010000;
						 y = 7'b111110;
						 writeEn = 1'b1;
					end
					4'b1000: writeEn = 1'b0;
					default: writeEn = 1'b0;
				endcase
			end
			else if (key_press == 4'b0001) // if a key is pressed, draw ship in left direction
			begin
				colour = 3'b111;
		     direction = 2'b10;
			  case (count[3:0])
					4'b0000: writeEn = 1'b0;
					4'b0001:
					begin
						 x = 8'b1010000;
						 y = 7'b111100;
						 writeEn = 1'b1;
					end				
					4'b0010:
					begin
						 x = 8'b1010001;
						 y = 7'b111100;
						 writeEn = 1'b1;
					end
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
					4'b0101: writeEn = 1'b0;				
					4'b0110: writeEn = 1'b0;
					4'b0111:
					begin
						 x = 8'b1010000;
						 y = 7'b111110;
						 writeEn = 1'b1;
					end
					4'b1000:
					begin
						 x = 8'b1010001;
						 y = 7'b111110;
						 writeEn = 1'b1;
					end
					default: writeEn = 1'b0;
				endcase
			end
			else if (key_press == 4'b0010) // if d key is pressed, draw ship in right direction
			begin
				colour = 3'b111;
			  direction = 2'b11;
			  case (count[3:0])
					4'b0000:
					begin
						 x = 8'b1001111;
						 y = 7'b111100;
						 writeEn = 1'b1;
					end
					4'b0001:
					begin
						 x = 8'b1010000;
						 y = 7'b111100;
						 writeEn = 1'b1;
					end				
					4'b0010: writeEn = 1'b0;
					4'b0011: writeEn = 1'b0;
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
					4'b0111:
					begin
						 x = 8'b1010000;
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