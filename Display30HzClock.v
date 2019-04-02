`timescale 1ns / 1ns // `timescale time_unit/time_precision

module asteroid_clock(out, clock);
	output out;
	input clock;
	reg [27:0] q;
	
	always@(posedge clock)     // triggered every time clock rises
	begin
		if(q == 28'd69999999)    // reset at slower hz
			q <= 0;                 // reset q to 0
		else  // ...otherwise update q (only when Enable is 1)
			q <= q + 1'b1;          // increment q
	end
	
	assign out = q == 0;
endmodule

module clock30Hz(out, clock);
	output out;
	input clock;
	reg [27:0] q;                // declare q

	always@(posedge clock)     // triggered every time clock rises
	begin
		if(q == 21'b1_1001_0110_1110_0110_1010)    // reset at 30hz
			q <= 0;                 // reset q to 0
		else  // ...otherwise update q (only when Enable is 1)
			q <= q + 1'b1;          // increment q
	end
	
	assign out = q == 0;
endmodule

module clock1sec(out, clock_30);
	input clock_30;
	output reg out;
	
	wire [5:0] count_30;
	countto30(count_30, clock_30);
	
	always@(*)
		if(count_30 == 6'd30)
			out <= 1'b1;
		else
			out <= 0;
endmodule

module countto30(out, clock);
	output reg [5:0] out;
	input clock;

	always@ (posedge clock)     // triggered every time clock rises
	begin
		if(out == 6'd30)    // ...otherwise if q is the maximum counter value
			out <= 0;                 // reset q to 0
		else  // ...otherwise update q (only when Enable is 1)
			out <= out + 1'b1;          // increment q
	end
endmodule

module Display30HzClock(HEX0, HEX1, LEDR, CLOCK_50);
	output [7:0] HEX0;
	output [7:0] HEX1;
	output [17:0] LEDR;
	input CLOCK_50;
	wire [4:0] out;
	wire clock;
	
	assign LEDR[4:0] = out[4:0];
	countto30(out, clock);
	clock30Hz(clock, CLOCK_50);
	
	hex_display(HEX0, out[3:0]);
	hex_display(HEX1, out[4]);
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
	
module timer_display(dig0, dig1, dig2, dig3, game_state, clk);
	input clk;
	input game_state;
	output reg [3:0] dig0, dig1, dig2, dig3;		
			
	always@(posedge clk) begin
		if (game_state == 1) begin
			dig0 <= 0;
			dig1 <= 0;
			dig2 <= 0;
			dig3 <= 0;
		end
		else if (dig0 == 4'd9 && dig1 != 4'd9) begin
			dig0 <= 0;
			dig1 <= dig1 + 1;
		end
		else if (dig1 == 4'd9 && dig0 == 4'd9 && dig2 != 4'd9) begin
			dig0 <= 4'd0;
			dig1 <= 4'd0;
			dig2 <= dig2 + 1;
		end
		else if (dig2 == 4'd9 && dig1 == 4'd9 && dig0 == 4'd9 && dig3 != 4'd9) begin
			dig0 <=
			dig2 <= 0;
			dig3 <= dig3 + 1;
		end
		else if (dig3 == 4'd9 && dig2 == 4'd9 && dig1 == 4'd9 && dig0 == 4'd9) begin
			dig0 <= 0;
			dig1 <= 0;
			dig2 <= 0;
			dig3 <= 0;
		end
		else
			dig0 <= dig0 + 1;
	end 
endmodule 

module score_display(dig0, dig1, game_state, hit);
	input hit;
	input game_state;
	output reg [3:0] dig0, dig1;		
			
	always@(posedge hit) begin
		if (game_state == 1) begin
			dig0 <= 0;
			dig1 <= 0;
		end
		else if (dig0 == 4'd9 && dig1 != 4'd9) begin
			dig0 <= 0;
			dig1 <= dig1 + 1;
		end
		else if (dig1 == 4'd9 && dig0 == 4'd9) begin
			dig0 <= 4'd0;
			dig1 <= 4'd0;
		end
		else
			dig0 <= dig0 + 1;
	end 
endmodule


module game_over_hold(hold, game_state, clk);
	input clk, game_state;
	output reg hold;
	
	always@(*) begin
		if(game_state) hold <= 1;
		else if (clk == 1) hold <= 0;
	end 
endmodule 