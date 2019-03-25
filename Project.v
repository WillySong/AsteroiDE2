// Screen size is 160x120

module drawAsteroidXX(x, y, writeEn, clk, count);
	output reg [7:0] x;
	output reg [6:0] y;
	output reg writeEn;
	input clk;
	input [3:0] count;
	always@ (posedge clk)
	begin
		case (count[3:0])
			default: writeEn = 1'b1;
		endcase
	end
endmodule

module Project(HEX7, HEX6, HEX5, HEX4, KEY, SW);
	output [7:0] HEX7;
	output [7:0] HEX6;
	output [7:0] HEX5;
	output [7:0] HEX4;
	input [3:0] KEY;
	input [17:0] SW;
	wire clk;
	assign clk = !KEY[0] || !KEY[1] || !KEY[2] || !KEY[3];
	wire [7:0] x;
	wire [6:0] y;
	
	moveAsteroid(x, y, x, y, SW[1:0], SW[3:2], clk);
	hex_display(HEX7, x[7:4]);
	hex_display(HEX6, x[3:0]);
	hex_display(HEX5, y[6:4]);
	hex_display(HEX4, y[3:0]);
endmodule

module moveAsteroid(new_x, new_y, x, y, direction, speed, clk);
	output reg [7:0] new_x;
	output reg [6:0] new_y;
	input [7:0] x;
	input [6:0] y;
	input [1:0] direction;
	input [1:0] speed;
	input clk;
	always@(posedge clk)
	begin
	case (direction[1:0])
		2'b00:
		begin 
			new_y <= y + speed;
			new_x <= x;
		end
		2'b01:
		begin
			new_y <= y - speed;
			new_x <= x;
		end
		2'b11:
		begin
			new_x <= x + speed;
			new_y <= y;
		end
		2'b10:
		begin
			new_x <= x - speed;
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

module hex_display(OUT, IN);
	input [3:0] IN;
	output reg [7:0] OUT;
	
	always @(*)
	begin
		case(IN[3:0])
			4'b0000: OUT = 7'b1000000;
			4'b0001: OUT = 7'b1111001;
			4'b0010: OUT = 7'b0100100;
			4'b0011: OUT = 7'b0110000;
			4'b0100: OUT = 7'b0011001;
			4'b0101: OUT = 7'b0010010;
			4'b0110: OUT = 7'b0000010;
			4'b0111: OUT = 7'b1111000;
			4'b1000: OUT = 7'b0000000;
			4'b1001: OUT = 7'b0011000;
			4'b1010: OUT = 7'b0001000;
			4'b1011: OUT = 7'b0000011;
			4'b1100: OUT = 7'b1000110;
			4'b1101: OUT = 7'b0100001;
			4'b1110: OUT = 7'b0000110;
			4'b1111: OUT = 7'b0001110;
			
			default: OUT = 7'b0111111;
		endcase
	end
endmodule
