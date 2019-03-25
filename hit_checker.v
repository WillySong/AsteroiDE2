module hit_single_asteroid_ship(result, asteroid, ship):
	output reg result;
	input asteroid, ship;
	assign result = asteroid == ship;
	for (i = 0; i < 160; i = i + 1) begin
   	  	result = result || [179+i*180:i*180] == asteroid[179+i*180:i*180];
   	end
endmodule

module hit_asteroid_bullet(result, asteroid, ship):
	output reg result;
	input asteroid, ship;
	assign result = asteroid == ship;
	for (i = 0; i < 160; i = i + 1) begin
   	  	result = result || [179+i*180:i*180] == asteroid[179+i*180:i*180];
   	end
endmodule

# Pass in all asteroids and ship get out a value
module dead_ship(OUT, ship, asteroid00, asteroid01, asteroid02, asteroid03, asteroid04, asteroid05, asteroid06, asteroid07, asteroid08,  asteroid09, asteroid10, asteroid11, asteroid12,  asteroid13, asteroid14, asteroid15):
	output OUT;
	input ship, asteroid00, asteroid01, asteroid02, asteroid03, asteroid04, asteroid05, asteroid06, asteroid07, asteroid08,  asteroid09, asteroid10, asteroid11, asteroid12,  asteroid13, asteroid14, asteroid15;
	wire result [15:0];
	hit_single_asteroid_ship(result[0], asteroid00, ship);
	hit_single_asteroid_ship(result[1], asteroid01, ship);
	hit_single_asteroid_ship(result[2], asteroid02, ship);
	hit_single_asteroid_ship(result[3], asteroid03, ship);
	hit_single_asteroid_ship(result[4], asteroid04, ship);
	hit_single_asteroid_ship(result[5], asteroid05, ship);
	hit_single_asteroid_ship(result[6], asteroid06, ship);
	hit_single_asteroid_ship(result[7], asteroid07, ship);
	hit_single_asteroid_ship(result[8], asteroid08, ship);
	hit_single_asteroid_ship(result[9], asteroid09, ship);
	hit_single_asteroid_ship(result[10], asteroid10, ship);
	hit_single_asteroid_ship(result[11], asteroid11, ship);
	hit_single_asteroid_ship(result[12], asteroid12, ship);
	hit_single_asteroid_ship(result[13], asteroid13, ship);
	hit_single_asteroid_ship(result[14], asteroid14, ship);
	hit_single_asteroid_ship(result[15], asteroid15, ship);
	or(OUT, result[15:0]);
endmodule
	