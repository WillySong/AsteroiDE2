module bullet_hit_checker(hit, ax, ay, bx, by, clock);
	output reg hit;
	input [159:0] ax, bx;
	input [119:0] ay, by;
	input clock;
	reg [159:0] sumx;
	reg [119:0] sumy;
	integer x;
	integer y;
	reg hitx, hity;
	always @(posedge clock) begin
		sumx[159:0] = ax[159:0] + bx[159:0];
		sumy[119:0] = ay[119:0] + by[119:0];
		for (x=0; x<160; x=x+1)
			 hitx = hitx ^ sumx[x];
		for (y=0; y<120; y=y+1)
			 hity = hity ^ sumy[y];
		hit = hitx && hity;
	end
endmodule
