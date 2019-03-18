// Screen size is 160x120

module drawAsteroidXX(clk, count, x, y, writeEn, direction);
    input [3:0] count;
	input clk;
	output reg [7:0] x;
	output reg [6:0] y;
	output reg writeEn;
	output [1:0] direction;
	assign direction = 2'b11;
	// TODO: Complete later
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

module moveAsteroid(new_x, new_y, old_x, old_y, direction);
	output reg [7:0] new_x;
	output reg [6:0] new_y;
	input [7:0] x;
	input [6:0] y;
	input [1:0] direction;
	always@(posedge clk)
	begin
	case (direction[1:0])
		2'b00:
		begin 
			new_y <= y + 1;
			new_x <= x;
		end
		2'b01:
		begin
			new_y <= y - 1;
			new_x <= x;
		end
		2'b11:
		begin
			new_x <= x + 1;
			new_y <= y;
		end
		2'b10:
		begin:
			new_x <= x - 1;
			new_y <= y;
		end
		default:
		begin
			new_x <= x;
			new_y <= y;
		end
	endcase
	end
endmodule
