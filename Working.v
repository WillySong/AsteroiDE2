module Working(
	  input PS2_KBCLK,                            // Keyboard clock
	  input PS2_KBDAT,                            // Keyboard input data
	  input CLOCK_50,                             //    On Board 50 MHz
	  input [17:0] SW,
	  input [3:0] KEY,                            // Reset key
	  output [6:0] HEX0,
	  output [6:0] HEX1,
	  output [6:0] HEX2,
	  output [6:0] HEX3,
	  output [6:0] HEX4,
	  output [6:0] HEX5,
	  output [6:0] HEX6,
	  output [6:0] HEX7,
	  output [17:0] LEDR,
		// The ports below are for the VGA output.  Do not change.
		output VGA_CLK,   						//	VGA Clock
		output VGA_HS,							//	VGA H_SYNC
		output VGA_VS,							//	VGA V_SYNC
		output VGA_BLANK_N,						//	VGA BLANK
		output VGA_SYNC_N,						//	VGA SYNC
		output [9:0] VGA_R,   						//	VGA Red[9:0]
		output [9:0] VGA_G,	 						//	VGA Green[9:0]
		output [9:0] VGA_B   						//	VGA Blue[9:0]
	);

	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;
	wire [3:0] count;
	wire clock_30, a_clock;
	wire resetn;
	wire [1:0] bullet_state;
	wire [3:0] direction;
	wire [159:0] bullet_x;
	wire [119:0] bullet_y;
	wire [159:0] ship_x;
	wire [119:0] ship_y;
	assign resetn = SW[17];

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
				
						
	wire [3:0] ship_control;
   wire [7:0] kb_scan_code;
	wire kb_sc_ready, kb_letter_case;
	key2ascii SC2A (
		.letter_case(kb_letter_case),
		.scan_code(kb_scan_code),
		.ship_control(ship_control)
	);
	keyboard kd (
		.clk(CLOCK_50),
		.reset(~resetn),
		.ps2d(PS2_KBDAT),
		.ps2c(PS2_KBCLK),
		.scan_code(kb_scan_code),
		.scan_code_ready(kb_sc_ready),
		.letter_case_out(kb_letter_case)
	);

	wire [7:0] a_state;
	assign a_state[7:0] = SW[8:1];
	counter(CLOCK_50, x, y);
	//shoot_state(ship_control, bullet_state);
	shoot_state(!KEY[3] || !KEY[2] || !KEY[1] || !KEY[0], bullet_state);
	clock30Hz(clock_30, CLOCK_50);
	ship(ship_control, clock_30, ship_x, ship_y, direction, ship_hit);
	bullet(clock_30, direction, bullet_state, bullet_x, bullet_y, ship_x, ship_y);
	wire [159:0] a1_x, a2_x, a3_x, a4_x, a5_x, a6_x, a7_x, a8_x;
	wire [119:0] a1_y, a2_y, a3_y, a4_y, a5_y, a6_y, a7_y, a8_y;
	asteroid01(clock_30, a1_hit, a_state[0], a1_x, a1_y);
	asteroid02(clock_30, a2_hit, a_state[1], a2_x, a2_y);
	asteroid03(clock_30, a3_hit, a_state[2], a3_x, a3_y);
	asteroid04(clock_30, a4_hit, a_state[3], a4_x, a4_y);
	asteroid05(clock_30, a5_hit, a_state[4], a5_x, a5_y);
	asteroid06(clock_30, a6_hit, a_state[5], a6_x, a6_y);
	asteroid07(clock_30, a7_hit, a_state[6], a7_x, a7_y);
	asteroid08(clock_30, a8_hit, a_state[7], a8_x, a8_y);
	draw(CLOCK_50, x, y, bullet_x, bullet_y, ship_x, ship_y, a1_x, a1_y, a2_x, a2_y, a3_x, a3_y, a4_x, a4_y, a5_x, a5_y, a6_x, a6_y, a7_x, a7_y, a8_x, a8_y, direction, colour, writeEn);
	wire a1_hit, a2_hit, a3_hit, a4_hit, a5_hit, a6_hit, a7_hit, a8_hit;
	bullet_hit_checker(a1_hit, a1_x, a1_y, bullet_x, bullet_y, clock_30);
	bullet_hit_checker(a2_hit, a2_x, a2_y, bullet_x, bullet_y, clock_30);
	bullet_hit_checker(a3_hit, a3_x, a3_y, bullet_x, bullet_y, clock_30);
	bullet_hit_checker(a4_hit, a4_x, a4_y, bullet_x, bullet_y, clock_30);
	bullet_hit_checker(a5_hit, a5_x, a5_y, bullet_x, bullet_y, clock_30);
	bullet_hit_checker(a6_hit, a6_x, a6_y, bullet_x, bullet_y, clock_30);
	bullet_hit_checker(a7_hit, a7_x, a7_y, bullet_x, bullet_y, clock_30);
	bullet_hit_checker(a8_hit, a8_x, a8_y, bullet_x, bullet_y, clock_30);
	wire ship_hit, s1_hit, s2_hit, s3_hit, s4_hit, s5_hit, s6_hit, s7_hit, s8_hit;
	bullet_hit_checker(s1_hit, a1_x, a1_y, ship_x, ship_y, clock_30);
	bullet_hit_checker(s2_hit, a2_x, a2_y, ship_x, ship_y, clock_30);
	bullet_hit_checker(s3_hit, a3_x, a3_y, ship_x, ship_y, clock_30);
	bullet_hit_checker(s4_hit, a4_x, a4_y, ship_x, ship_y, clock_30);
	bullet_hit_checker(s5_hit, a5_x, a5_y, ship_x, ship_y, clock_30);
	bullet_hit_checker(s6_hit, a6_x, a6_y, ship_x, ship_y, clock_30);
	bullet_hit_checker(s7_hit, a7_x, a7_y, ship_x, ship_y, clock_30);
	bullet_hit_checker(s8_hit, a8_x, a8_y, ship_x, ship_y, clock_30);
	assign ship_hit = s1_hit || s2_hit || s3_hit || s4_hit || s5_hit || s6_hit || s7_hit || s8_hit;
	
	// seconds alive
	wire ship_hit_hold;
	game_over_hold(ship_hit_hold, ship_hit, clock_1s);
	wire clock_1s;
	wire [3:0] dig0, dig1, dig2, dig3;
	clock1sec(clock_1s, clock_30);
	timer_display(dig0, dig1, dig2, dig3, ship_hit_hold, clock_1s);
	hex_display(HEX0, dig0);
	hex_display(HEX1, dig1);
	hex_display(HEX2, dig2);
	hex_display(HEX3, dig3);
	
	// asteroids
	wire [3:0] h4;
	wire [3:0] h5;
	wire any_asteroid_hit;
	assign any_asteroid_hit = a1_hit || a2_hit || a3_hit || a4_hit || a5_hit || a6_hit || a7_hit || a8_hit;
	score_display(h4, h5, ship_hit_hold, any_asteroid_hit);
	hex_display(HEX4, h4);
	hex_display(HEX5, h5);
	
	// Ship deaths
	wire [3:0] h6;
	wire [3:0] h7;
	score_display(h6, h7, 0, ship_hit);
	hex_display(HEX6, h6);
	hex_display(HEX7, h7);
endmodule


module bullet(clock, ship_direction, bullet_state, bullet_x, bullet_y, ship_x, ship_y);
	input clock, bullet_state;
	input [3:0] ship_direction;
	input [159:0] ship_x;
	input [119:0] ship_y;
	reg [3:0] direction;
	output reg [159:0] bullet_x;
	output reg [119:0] bullet_y; 
	localparam up = 4'b0100, right = 4'b0010, down = 4'b0011, left = 4'b0001;

	always @(posedge clock)
	begin
		// if the space is pressed, a bullet is drawn
		if (bullet_state == 1'b1 && (bullet_y == 1'b0 || bullet_x == 1'b0)) begin
			direction[3:0] = ship_direction[3:0];
			bullet_x = ship_x;
			bullet_y = ship_y;
		end
		if (direction == up) // up
			bullet_y = bullet_y >> 2;
		else if (direction == right) // right
			bullet_x = bullet_x << 2;
		else if (direction == down) //down
			bullet_y = bullet_y << 2;
		else if (direction == left) //left
			bullet_x = bullet_x >> 2;
	end	
endmodule

module counter(clock, x, y);
	input clock;
	output reg [7:0] x;
	output reg [6:0] y;
	// check every pixel of the screen
	always@(posedge clock)
	begin
		if (x < 8'd160 && y < 7'd120) begin // if insbulletide the screen
			x <= x + 1'b1;
			y <= y;
		end
		else if (x == 8'd160 && y < 7'd120) begin// if reaches the right boarder
			x <= 0;
			y <= y + 1'b1;
		end
		else begin // if reaches the bottom right of the screen
			x <= 0;
			y <= 0;
		end
	end
endmodule

module shoot_state(IN, OUT);
	input IN;
	output reg OUT;
	always @(*)
	 begin
		case(IN)
			1'b1: OUT = 1'b1;
			default: OUT = 1'b0;
		endcase//
	 end	
endmodule

module ship(ship_control, clock, ship_x, ship_y, direction, hit);
	input [3:0] ship_control;
	input clock, hit;
	output reg [159:0] ship_x;
	output reg [119:0] ship_y;
	output reg [3:0] direction;
	reg start;
	localparam up = 4'b0100, right = 4'b0010, down = 4'b0011, left = 4'b0001;
	always@(posedge clock)
	begin
		if (hit || (ship_x == 1'b0 && ship_y == 1'b0)) begin
			if (hit) begin
				ship_x = 1'b0;
				ship_y = 1'b0;
			end
			ship_x[80] <= 1'b1;
			ship_y[60] <= 1'b1;
			start <= 1'b1;
			direction <= up;
		end
		
		else begin
			if (ship_y[0] == 1'b0 && ship_control == up) begin // up
				ship_y = ship_y >> 1;
				direction <= ship_control;
			end
			else if (ship_x[159] == 1'b0 && ship_control == right) begin// right
				ship_x = ship_x << 1;
				direction <= ship_control;
			end
			else if (ship_y[119] == 1'b0 && ship_control == down) begin //down
				ship_y = ship_y << 1;
				direction <= ship_control;
			end
			else if (ship_x[0] == 1'b0 && ship_control == left) begin //left
				ship_x = ship_x >> 1;
				direction <= ship_control;
			end
		end
	end
	
endmodule

module draw(clock50, x, y, bullet_x, bullet_y, ship_x, ship_y,  a1_x, a1_y, a2_x, a2_y, a3_x, a3_y, a4_x, a4_y, a5_x, a5_y, a6_x, a6_y, a7_x, a7_y, a8_x, a8_y, direction, colour, writeEn);
	input clock50;
	input [7:0] x;
	input [6:0] y;
	input [159:0] bullet_x;
	input [119:0] bullet_y;
	input [159:0] ship_x;
	input [119:0] ship_y;
	input [159:0] a1_x, a2_x, a3_x, a4_x, a5_x, a6_x, a7_x, a8_x;
	input [119:0] a1_y, a2_y, a3_y, a4_y, a5_y, a6_y, a7_y, a8_y;
	input [3:0] direction;
	output reg [2:0] colour;
	output reg writeEn;
	localparam up = 4'b0100, right = 4'b0010, down = 4'b0011, left = 4'b0001;
	always @(posedge clock50)
	begin
		writeEn <= 1;
		//once we get the pixel position, check which colour it needs to send
		// Ship: 123 |					X	 X 	XX 	X X	 XX
		//       456 |					X	XXX	 XX	XXX	XX
		//       789 V lower y		X	X X	XX		 X 	 XX
		//lower x-->						up		rig	dow	lef
		// 1
		if (x != 119 && ship_x[x+1] == 1'b1 && y != 159 && ship_y[y+1] == 1'b1) begin
			if (direction == right || direction == down)
				colour <= 3'b111;
			else
				colour <= 3'b000;
		end
		// 2
		else if (y != 159 && ship_x[x] == 1'b1 && ship_y[y+1] == 1'b1) begin
			if (direction != down)
				colour <= 3'b111;
			else
				colour <= 3'b000;
		end
		// 3
		else if (x != 0 && ship_x[x-1] == 1'b1 && y != 159 && ship_y[y+1] == 1'b1) begin
			if (direction == left || direction == down)
				colour <= 3'b111;
			else
				colour <= 3'b000;
		end
		// 4
		else if (x != 159 && ship_x[x+1] == 1'b1 && ship_y[y] == 1'b1) begin
			if (direction != right)
				colour <= 3'b111;
			else
				colour <= 3'b000;
		end
		// 5
		else if (ship_x[x] == 1'b1 && ship_y[y] == 1'b1)
			colour <= 3'b111;
		// 6
		else if (x != 0 && ship_x[x-1] == 1'b1 && ship_y[y] == 1'b1) begin
			if (direction != left)
				colour <= 3'b111;
			else
				colour <= 3'b000;
		end
		// 7
		else if (x != 119 && ship_x[x+1] == 1'b1 && y != 0 && ship_y[y-1] == 1'b1) begin
			if (direction == right || direction == up)
				colour <= 3'b111;
			else
				colour <= 3'b000;
		end
		// 8
		else if (y != 0 && ship_x[x] == 1'b1 && ship_y[y-1] == 1'b1) begin
			if (direction != up)
				colour <= 3'b111;
			else
				colour <= 3'b000;
		end
		// 9
		else if (x != 0 && ship_x[x-1] == 1'b1 && y != 0 && ship_y[y-1] == 1'b1) begin
			if (direction == left || direction == up)
				colour <= 3'b111;
			else
				colour <= 3'b000;
		end
		// Bullet, a lot easier to render
		else if (bullet_x[x] == 1'b1 && bullet_y[y] == 1'b1)
			colour <= 3'b101;
		// Asteroid		XXX  X   XX XX 
		//             XXX XXX XXX XXX
		//              X  XXX  XX XX 
		//					up  dow rig lef
		// 1
		else if (x != 119 && y != 159 && ((a4_x[x+1] == 1 && a4_y[y+1] == 1) || (a5_x[x+1] == 1 && a5_y[y+1] == 1) || (a6_x[x+1] == 1 && a6_y[y+1] == 1) || (a7_x[x+1] == 1 && a7_y[y+1] == 1)))
			colour <= 3'b011;
		// 2
		else if (y != 159 && ((a1_x[x] == 1 && a1_y[y+1] == 1) || (a2_x[x] == 1 && a2_y[y+1] == 1) || (a3_x[x] == 1 && a3_y[y+1] == 1) || (a4_x[x] == 1 && a4_y[y+1] == 1) || (a5_x[x] == 1 && a5_y[y+1] == 1) || (a6_x[x] == 1 && a6_y[y+1] == 1) || (a7_x[x] == 1 && a7_y[y+1] == 1) || (a8_x[x] == 1 && a8_y[y+1] == 1)))
			colour <= 3'b011;
		// 3
		else if (x != 0 && y != 159 && ((a5_x[x-1] == 1 && a5_y[y+1] == 1) || (a6_x[x-1] == 1 && a6_y[y+1] == 1) || (a7_x[x-1] == 1 && a7_y[y+1] == 1) || (a8_x[x-1] == 1 && a8_y[y+1] == 1)))
			colour <= 3'b011;
		// 4
		else if (x != 159 && ((a1_x[x+1] == 1 && a1_y[y] == 1) || (a2_x[x+1] == 1 && a2_y[y] == 1) || (a3_x[x+1] == 1 && a3_y[y] == 1) || (a4_x[x+1] == 1 && a4_y[y] == 1) || (a5_x[x+1] == 1 && a5_y[y] == 1) || (a6_x[x+1] == 1 && a6_y[y] == 1) || (a7_x[x+1] == 1 && a7_y[y] == 1) || (a8_x[x+1] == 1 && a8_y[y] == 1)))
			colour <= 3'b011;
		// 5
		else if ((a1_x[x] == 1 && a1_y[y] == 1) || (a2_x[x] == 1 && a2_y[y] == 1) || (a3_x[x] == 1 && a3_y[y] == 1) || (a4_x[x] == 1 && a4_y[y] == 1) || (a5_x[x] == 1 && a5_y[y] == 1) || (a6_x[x] == 1 && a6_y[y] == 1) || (a7_x[x] == 1 && a7_y[y] == 1) || (a8_x[x] == 1 && a8_y[y] == 1))
			colour <= 3'b011;
		// 6
		else if (x != 0 && ((a1_x[x-1] == 1 && a1_y[y] == 1) || (a2_x[x-1] == 1 && a2_y[y] == 1) || (a3_x[x-1] == 1 && a3_y[y] == 1) || (a4_x[x-1] == 1 && a4_y[y] == 1) || (a5_x[x-1] == 1 && a5_y[y] == 1) || (a6_x[x-1] == 1 && a6_y[y] == 1) || (a7_x[x-1] == 1 && a7_y[y] == 1) || (a8_x[x-1] == 1 && a8_y[y] == 1)))
			colour <= 3'b011;
		// 7
		else if (x != 119 && y != 0 && ((a1_x[x+1] == 1 && a1_y[y-1] == 1) || (a2_x[x+1] == 1 && a2_y[y-1] == 1) || (a3_x[x+1] == 1 && a3_y[y-1] == 1) || (a4_x[x+1] == 1 && a4_y[y-1] == 1)))
			colour <= 3'b011;
		// 8
		else if (y != 0 && ((a1_x[x] == 1 && a1_y[y-1] == 1) || (a2_x[x] == 1 && a2_y[y-1] == 1) || (a3_x[x] == 1 && a3_y[y-1] == 1) || (a4_x[x] == 1 && a4_y[y-1] == 1) || (a5_x[x] == 1 && a5_y[y-1] == 1) || (a6_x[x] == 1 && a6_y[y-1] == 1) || (a7_x[x] == 1 && a7_y[y-1] == 1) || (a8_x[x] == 1 && a8_y[y-1] == 1)))
			colour <= 3'b011;
		// 9
		else if (x != 0 && y != 0 && ((a1_x[x-1] == 1 && a1_y[y-1] == 1) || (a2_x[x-1] == 1 && a2_y[y-1] == 1) || (a3_x[x-1] == 1 && a3_y[y-1] == 1) || (a8_x[x-1] == 1 && a8_y[y-1] == 1)))
			colour <= 3'b011;
		// None
		else
			colour <= 3'b000;
	end
endmodule 

module bullet_hit_checker(hit, ax, ay, bx, by, clock);
	output reg hit;
	input [159:0] ax, bx;
	input [119:0] ay, by;
	input clock;
	reg hitx, hity;
	reg [159:0] axL, axR;
	reg [119:0] ayU, ayD;
	always @(posedge clock) begin
		if (bx != 0 && by != 0) begin
			axL = ax * 2;
 			axR = ax / 2;
			ayU = ay * 2;
			ayD = ay / 2;
			hitx = ax == bx || axL == bx || axR == bx;
			hity = ay == by || ayU == by || ayD == by;
			hit = hitx && hity;
		end
	end
endmodule
