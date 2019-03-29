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

module countto30(out, clock);
	output reg [5:0] out;
	input clock;

	always@ (posedge clock)     // triggered every time clock rises
	begin
		if(out == 4'd30)    // ...otherwise if q is the maximum counter value
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
	