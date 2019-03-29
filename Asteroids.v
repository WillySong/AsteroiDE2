// Asteroid Arrangment Origin
//		1		2		3
//							4
//	8
//		7		6		5

module asteroid01(clock, reset, asteroid_state, asteroid_x, asteroid_y);
	input clock, asteroid_state, reset;
	output reg [159:0] asteroid_x;
	output reg [119:0] asteroid_y; 
	localparam up = 4'b0111, right = 4'b1101, down = 4'b1011, left = 4'b1110; // testing using key
	always @(posedge clock)
	begin
		if (asteroid_state == 1 && (reset == 0 || asteroid_x == 0 || asteroid_y == 0)) begin
			asteroid_x[23] = 1'b1;
			asteroid_y[119] = 1'b1;
		end
		asteroid_y = asteroid_y >> 1; // down
	end	
endmodule

module asteroid02(clock, reset, asteroid_state, asteroid_x, asteroid_y);
	input clock, asteroid_state, reset;
	output reg [159:0] asteroid_x;
	output reg [119:0] asteroid_y; 
	localparam up = 4'b0111, right = 4'b1101, down = 4'b1011, left = 4'b1110; // testing using key
	always @(posedge clock)
	begin
		if (asteroid_state == 1 && (reset == 0 || asteroid_x == 0 || asteroid_y == 0)) begin
			asteroid_x[69] = 1'b1;
			asteroid_y[119] = 1'b1;
		end
		asteroid_y = asteroid_y >> 1; // down
	end	
endmodule

module asteroid03(clock, reset, asteroid_state, asteroid_x, asteroid_y);
	input clock, asteroid_state, reset;
	output reg [159:0] asteroid_x;
	output reg [119:0] asteroid_y; 
	localparam up = 4'b0111, right = 4'b1101, down = 4'b1011, left = 4'b1110; // testing using key
	always @(posedge clock)
	begin
		if (asteroid_state == 1 && (reset == 0 || asteroid_x == 0 || asteroid_y == 0)) begin
			asteroid_x[115] = 1'b1;
			asteroid_y[119] = 1'b1;
		end
		asteroid_y = asteroid_y >> 1; // down
	end	
endmodule

module asteroid04(clock, reset, asteroid_state, asteroid_x, asteroid_y);
	input clock, asteroid_state, reset;
	output reg [159:0] asteroid_x;
	output reg [119:0] asteroid_y; 
	localparam up = 4'b0111, right = 4'b1101, down = 4'b1011, left = 4'b1110; // testing using key
	always @(posedge clock)
	begin
		if (asteroid_state == 1 && (reset == 0 || asteroid_x == 0 || asteroid_y == 0)) begin
			asteroid_x[0] = 1'b1;
			asteroid_y[40] = 1'b1;
		end
		asteroid_x = asteroid_x << 1; // left
	end	
endmodule

module asteroid05(clock, reset, asteroid_state, asteroid_x, asteroid_y);
	input clock, asteroid_state, reset;
	output reg [159:0] asteroid_x;
	output reg [119:0] asteroid_y; 
	localparam up = 4'b0111, right = 4'b1101, down = 4'b1011, left = 4'b1110; // testing using key
	always @(posedge clock)
	begin
		if (asteroid_state == 1 && (reset == 0 || asteroid_x == 0 || asteroid_y == 0)) begin
			asteroid_x[138] = 1'b1;
			asteroid_y[0] = 1'b1;
		end
		asteroid_y = asteroid_y << 1; // up
	end	
endmodule

module asteroid06(clock, reset, asteroid_state, asteroid_x, asteroid_y);
	input clock, asteroid_state, reset;
	output reg [159:0] asteroid_x;
	output reg [119:0] asteroid_y; 
	localparam up = 4'b0111, right = 4'b1101, down = 4'b1011, left = 4'b1110; // testing using key
	always @(posedge clock)
	begin
		if (asteroid_state == 1 && (reset == 0 || asteroid_x == 0 || asteroid_y == 0)) begin
			asteroid_x[92] = 1'b1;
			asteroid_y[0] = 1'b1;
		end
		asteroid_y = asteroid_y << 1; // up
	end	
endmodule

module asteroid07(clock, reset, asteroid_state, asteroid_x, asteroid_y);
	input clock, asteroid_state, reset;
	output reg [159:0] asteroid_x;
	output reg [119:0] asteroid_y; 
	localparam up = 4'b0111, right = 4'b1101, down = 4'b1011, left = 4'b1110; // testing using key
	always @(posedge clock)
	begin
		if (asteroid_state == 1 && (reset == 0 || asteroid_x == 0 || asteroid_y == 0)) begin
			asteroid_x[46] = 1'b1;
			asteroid_y[0] = 1'b1;
		end
		asteroid_y = asteroid_y << 1; // up
	end	
endmodule

module asteroid08(clock, reset, asteroid_state, asteroid_x, asteroid_y);
	input clock, asteroid_state, reset;
	output reg [159:0] asteroid_x;
	output reg [119:0] asteroid_y; 
	localparam up = 4'b0111, right = 4'b1101, down = 4'b1011, left = 4'b1110; // testing using key
	always @(posedge clock)
	begin
		if (asteroid_state == 1 && (reset == 0 || asteroid_x == 0 || asteroid_y == 0)) begin
			asteroid_x[159] = 1'b1;
			asteroid_y[80] = 1'b1;
		end
		asteroid_x = asteroid_x >> 1; // right
	end	
endmodule

