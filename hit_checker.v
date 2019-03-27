module hit_single_layer1_layer2(led, hit_x, hit_y, hit_result, layer1, layer2, clock);
	output reg hit_result;
	input clock;
	input [19199:0] layer1;
	input [19199:0] layer2;
	
	output reg [7:0] hit_x;
	output reg [6:0] hit_y;
	output reg [14:0] led;
	
	always@(posedge clock)
	begin
		led <= {hit_y, hit_x};
		if (clock % 1666666 == 1'b1) begin
			hit_x <= 0;
			hit_y <= 0;
			hit_result <= 0;
		end
		if (hit_x < 8'd160 && hit_y < 7'd120) begin // if inside the screen
			hit_x <= hit_x + 1'b1;
			hit_y <= hit_y;
		end
		else if (hit_x == 8'd160 && hit_y < 7'd120) begin// if reaches the right boarder
			hit_x <= 0;
			hit_y <= hit_y + 1'b1;
		end
		
		if (layer1[hit_x+hit_y*160] == 1 && layer2[hit_x+hit_y*160] == 1)
			hit_result <= 1;
	end
endmodule

//// Pass in all asteroids and ship get out a value
//module dead_ship(OUT, ship, asteroid00, asteroid01, asteroid02, asteroid03, asteroid04, asteroid05, asteroid06, asteroid07, asteroid08,  asteroid09, asteroid10, asteroid11, asteroid12,  asteroid13, asteroid14, asteroid15);
//	output OUT;
//	input ship, asteroid00, asteroid01, asteroid02, asteroid03, asteroid04, asteroid05, asteroid06, asteroid07, asteroid08,  asteroid09, asteroid10, asteroid11, asteroid12,  asteroid13, asteroid14, asteroid15;
//	wire result [15:0];
//	hit_single_layer1_layer2(result[0], asteroid00, ship);
//	hit_single_layer1_layer2(result[1], asteroid01, ship);
//	hit_single_layer1_layer2(result[2], asteroid02, ship);
//	hit_single_layer1_layer2(result[3], asteroid03, ship);
//	hit_single_layer1_layer2(result[4], asteroid04, ship);
//	hit_single_layer1_layer2(result[5], asteroid05, ship);
//	hit_single_layer1_layer2(result[6], asteroid06, ship);
//	hit_single_layer1_layer2(result[7], asteroid07, ship);
//	hit_single_layer1_layer2(result[8], asteroid08, ship);
//	hit_single_layer1_layer2(result[9], asteroid09, ship);
//	hit_single_layer1_layer2(result[10], asteroid10, ship);
//	hit_single_layer1_layer2(result[11], asteroid11, ship);
//	hit_single_layer1_layer2(result[12], asteroid12, ship);
//	hit_single_layer1_layer2(result[13], asteroid13, ship);
//	hit_single_layer1_layer2(result[14], asteroid14, ship);
//	hit_single_layer1_layer2(result[15], asteroid15, ship);
//endmodule

module countto9(out, clock);
	output reg [3:0] out;
	input clock;

	always@ (posedge clock)     // triggered every time clock rises
	begin
		if(out == 4'd10)    // ...otherwise if q is the maximum counter value
			out <= 0;                 // reset q to 0
		else  // ...otherwise update q (only when Enable is 1)
			out <= out + 1'b1;          // increment q
	end
endmodule

module countto19200(nout, clock);
	output reg nout;
	reg [14:0] out;
	input clock;

	always@ (posedge clock)     // triggered every time clock rises
	begin
		if(out == 15'd19199) begin   // ...otherwise if q is the maximum counter value
			out <= 0;                 // reset q to 0
			nout <= 1;
		end
		else begin // ...otherwise update q (only when Enable is 1)
			out <= out + 1'b1;          // increment q
			nout <= 0;
		end
		
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

//Tester
module Project(LEDR, SW, HEX0, HEX7, HEX6, HEX5, HEX4, CLOCK_50);
	output [17:0] LEDR;
	output [7:0] HEX0;
	output [7:0] HEX7;
	output [7:0] HEX6;
	output [7:0] HEX5;
	output [7:0] HEX4;
	input [17:0] SW;
	input CLOCK_50;
	
	
	wire [19199:0] layer1;
	wire [19199:0] layer2;
	
	assign layer1[0] = 1;
	assign layer2[0] = SW[0];
	wire clk;
	
	countto19200(clk, CLOCK_50);
	
	wire out;
	wire [7:0] hit_x;
	wire [6:0] hit_y;
	hit_single_layer1_layer2(LEDR[15:1], hit_x, hit_y, out, layer1, layer2, clk);
	wire [3:0] counter;
	countto9(counter, out);
	hex_display(HEX0, counter);
	hex_display(HEX7, hit_x[7:4]);
	hex_display(HEX6, hit_x[3:0]);
	hex_display(HEX5, hit_y[6:4]);
	hex_display(HEX4, hit_y[3:0]);
	assign LEDR[0] = out;
	assign LEDR[17] = SW[0];
	
endmodule
	
