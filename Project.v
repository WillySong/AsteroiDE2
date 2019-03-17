// Module taken from Joe Armitage & co
module ps2_rx
	(
		input wire clk, reset, 
		input wire ps2d, ps2c, rx_en,    // ps2 data and clock inputs, receive enable input
		output reg rx_done_tick,         // ps2 receive done tick
		output wire [7:0] rx_data        // data received 
	);
	
	// FSMD state declaration
	localparam 
		idle = 1'b0,
		rx   = 1'b1;
		
	// internal signal declaration
	reg state_reg, state_next;          // FSMD state register
	reg [7:0] filter_reg;               // shift register filter for ps2c
	wire [7:0] filter_next;             // next state value of ps2c filter register
	reg f_val_reg;                      // reg for ps2c filter value, either 1 or 0
	wire f_val_next;                    // next state for ps2c filter value
	reg [3:0] n_reg, n_next;            // register to keep track of bit number 
	reg [10:0] d_reg, d_next;           // register to shift in rx data
	wire neg_edge;                      // negative edge of ps2c clock filter value
	
	// register for ps2c filter register and filter value
	always @(posedge clk, posedge reset)
		if (reset)
			begin
			filter_reg <= 0;
			f_val_reg  <= 0;
			end
		else
			begin
			filter_reg <= filter_next;
			f_val_reg  <= f_val_next;
			end

	// next state value of ps2c filter: right shift in current ps2c value to register
	assign filter_next = {ps2c, filter_reg[7:1]};
	
	// filter value next state, 1 if all bits are 1, 0 if all bits are 0, else no change
	assign f_val_next = (filter_reg == 8'b11111111) ? 1'b1 :
			    (filter_reg == 8'b00000000) ? 1'b0 :
			    f_val_reg;
	
	// negative edge of filter value: if current value is 1, and next state value is 0
	assign neg_edge = f_val_reg & ~f_val_next;
	
	// FSMD state, bit number, and data registers
	always @(posedge clk, posedge reset)
		if (reset)
			begin
			state_reg <= idle;
			n_reg <= 0;
			d_reg <= 0;
			end
		else
			begin
			state_reg <= state_next;
			n_reg <= n_next;
			d_reg <= d_next;
			end
	
	// FSMD next state logic
	always @*
		begin
		
		// defaults
		state_next = state_reg;
		rx_done_tick = 1'b0;
		n_next = n_reg;
		d_next = d_reg;
		
		case (state_reg)
			
			idle:
				if (neg_edge & rx_en)                 // start bit received
					begin
					n_next = 4'b1010;             // set bit count down to 10
					state_next = rx;              // go to rx state
					end
				
			rx:                                           // shift in 8 data, 1 parity, and 1 stop bit
				begin
				if (neg_edge)                         // if ps2c negative edge...
					begin
					d_next = {ps2d, d_reg[10:1]}; // sample ps2d, right shift into data register
					n_next = n_reg - 1;           // decrement bit count
					end
			
				if (n_reg==0)                         // after 10 bits shifted in, go to done state
                                        begin
					 rx_done_tick = 1'b1;         // assert dat received done tick
					 state_next = idle;           // go back to idle
					 end
				end
		endcase
		end
		
	assign rx_data = d_reg[8:1]; // output data bits 
endmodule

// Module taken from Joe Armitage & co
module keyboard

    (
	input wire clk, reset,
        input wire ps2d, ps2c,               // ps2 data and clock lines
        output wire [7:0] scan_code,         // scan_code received from keyboard to process
        output wire scan_code_ready,         // signal to outer control system to sample scan_code
        output wire letter_case_out          // output to determine if scan code is converted to lower or upper ascii code for a key
    );
	
    // constant declarations
    localparam  BREAK    = 8'hf0, // break code
                SHIFT1   = 8'h12, // first shift scan
                SHIFT2   = 8'h59, // second shift scan
                CAPS     = 8'h58; // caps lock

    // FSM symbolic states
    localparam [2:0] lowercase          = 3'b000, // idle, process lower case letters
                     ignore_break       = 3'b001, // ignore repeated scan code after break code -F0- reeived
                     shift              = 3'b010, // process uppercase letters for shift key held
                     ignore_shift_break = 3'b011, // check scan code after F0, either idle or go back to uppercase
		     capslock           = 3'b100, // process uppercase letter after capslock button pressed
		     ignore_caps_break  = 3'b101; // check scan code after F0, either ignore repeat, or decrement caps_num
                     
               
    // internal signal declarations
    reg [2:0] state_reg, state_next;           // FSM state register and next state logic
    wire [7:0] scan_out;                       // scan code received from keyboard
    reg got_code_tick;                         // asserted to write current scan code received to FIFO
    wire scan_done_tick;                       // asserted to signal that ps2_rx has received a scan code
    reg letter_case;                           // 0 for lower case, 1 for uppercase, outputed to use when converting scan code to ascii
    reg [7:0] shift_type_reg, shift_type_next; // register to hold scan code for either of the shift keys or caps lock
    reg [1:0] caps_num_reg, caps_num_next;     // keeps track of number of capslock scan codes received in capslock state (3 before going back to lowecase state)
   
    // instantiate ps2 receiver
    ps2_rx ps2_rx_unit (.clk(clk), .reset(reset), .rx_en(1'b1), .ps2d(ps2d), .ps2c(ps2c), .rx_done_tick(scan_done_tick), .rx_data(scan_out));
	
	// FSM stat, shift_type, caps_num register 
    always @(posedge clk, posedge reset)
        if (reset)
			begin
			state_reg      <= lowercase;
			shift_type_reg <= 0;
			caps_num_reg   <= 0;
			end
        else
			begin    
                        state_reg      <= state_next;
			shift_type_reg <= shift_type_next;
			caps_num_reg   <= caps_num_next;
			end
			
    //FSM next state logic
    always @*
        begin
       
        // defaults
        got_code_tick   = 1'b0;
	letter_case     = 1'b0;
	caps_num_next   = caps_num_reg;
        shift_type_next = shift_type_reg;
        state_next      = state_reg;
       
        case(state_reg)
			
	    // state to process lowercase key strokes, go to uppercase state to process shift/capslock
            lowercase:
                begin  
                if(scan_done_tick)                                                                    // if scan code received
		    begin
		    if(scan_out == SHIFT1 || scan_out == SHIFT2)                                      // if code is shift    
		        begin
			shift_type_next = scan_out;                                                   // record which shift key was pressed
			state_next = shift;                                                           // go to shift state
			end
					
		    else if(scan_out == CAPS)                                                         // if code is capslock
		        begin
			caps_num_next = 2'b11;                                                        // set caps_num to 3, num of capslock scan codes to receive before going back to lowecase
			state_next = capslock;                                                        // go to capslock state
			end

		    else if (scan_out == BREAK)                                                       // else if code is break code
			state_next = ignore_break;                                                    // go to ignore_break state
	 
		    else                                                                              // else if code is none of the above...            
			got_code_tick = 1'b1;                                                         // assert got_code_tick to write scan_out to FIFO
		    end	
                end
            
	    // state to ignore repeated scan code after break code FO received in lowercase state
            ignore_break:
                begin
                if(scan_done_tick)                                                                    // if scan code received, 
                    state_next = lowercase;                                                           // go back to lowercase state
                end
            
	    // state to process scan codes after shift received in lowercase state
            shift:
                begin
                letter_case = 1'b1;                                                                   // routed out to convert scan code to upper value for a key
               
                if(scan_done_tick)                                                                    // if scan code received,
			begin
			if(scan_out == BREAK)                                                             // if code is break code                                            
			    state_next = ignore_shift_break;                                              // go to ignore_shift_break state to ignore repeated scan code after F0

			else if(scan_out != SHIFT1 && scan_out != SHIFT2 && scan_out != CAPS)             // else if code is not shift/capslock
			    got_code_tick = 1'b1;                                                         // assert got_code_tick to write scan_out to FIFO
			end
		end
				
	     // state to ignore repeated scan code after break code F0 received in shift state 
	     ignore_shift_break:
	         begin
		 if(scan_done_tick)                                                                // if scan code received
		     begin
		     if(scan_out == shift_type_reg)                                                // if scan code is shift key initially pressed
		         state_next = lowercase;                                                   // shift/capslock key unpressed, go back to lowercase state
		     else                                                                          // else repeated scan code received, go back to uppercase state
			 state_next = shift;
		     end
		 end  
				
	     // state to process scan codes after capslock code received in lowecase state
	     capslock:
	         begin
		 letter_case = 1'b1;                                                               // routed out to convert scan code to upper value for a key
					
		 if(caps_num_reg == 0)                                                             // if capslock code received 3 times, 
		     state_next = lowercase;                                                   // go back to lowecase state
						
		 if(scan_done_tick)                                                                // if scan code received
		     begin 
		     if(scan_out == CAPS)                                                          // if code is capslock, 
		         caps_num_next = caps_num_reg - 1;                                         // decrement caps_num
						
		     else if(scan_out == BREAK)                                                    // else if code is break, go to ignore_caps_break state
			 state_next = ignore_caps_break;
						
		     else if(scan_out != SHIFT1 && scan_out != SHIFT2)                             // else if code isn't a shift key
			 got_code_tick = 1'b1;                                                     // assert got_code_tick to write scan_out to FIFO
		     end
		 end
				
		 // state to ignore repeated scan code after break code F0 received in capslock state 
		 ignore_caps_break:
		     begin
		     if(scan_done_tick)                                                                // if scan code received
		         begin
			 if(scan_out == CAPS)                                                          // if code is capslock
			     caps_num_next = caps_num_reg - 1;                                         // decrement caps_num
			 state_next = capslock;                                                        // return to capslock state
			 end
		     end
					
        endcase
        end
		
    // output, route letter_case to output to use during scan to ascii code conversion
    assign letter_case_out = letter_case; 
	
    // output, route got_code_tick to out control circuit to signal when to sample scan_out 
    assign scan_code_ready = got_code_tick;
	
    // route scan code data out
    assign scan_code = scan_out;
	
endmodule

// Module modified from key2ascii by Joe Armitage & co
module key2ascii
    (
        input wire letter_case,
        input wire [7:0] scan_code,
        output reg [3:0] ship_control
    );
    
always @*
  begin
  case(scan_code)
	/* Player movement*/
	8'h1c: ship_control = 4'd1;   // a
	8'h23: ship_control = 4'd2;   // d
	8'h1b: ship_control = 4'd3;   // s
	8'h1d: ship_control = 4'd4;   // w
	8'h29: ship_control = 4'd5;   // space
	/* Player movement alternates for possible player 2 implementation*/
	8'h75: ship_control = 4'd6;   // DC1: Up Arrow
	8'h6B: ship_control = 4'd7;   // DC2: Left Arrow
	8'h72: ship_control = 4'd8;   // DC3: Down Arrow
	8'h74: ship_control = 4'd9;   // DC4: Right Arrow
	default: ship_control = 4'd0; // NUL
  endcase
  end
endmodule

module Project(
	  input PS2_KBCLK,                            // Keyboard clock
	  input PS2_KBDAT,                            // Keyboard input data
	  input CLOCK_50,                             //    On Board 50 MHz
	  input [0:0] KEY,                            // Reset key
	  output [6:0] HEX0
		CLOCK_50,						//	On Board 50 MHz
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input		CLOCK_50;				//	50 MHz


	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]


	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;
	wire [3:0] count;
	wire resetn;
	wire [1:0] direction;
	assign colour = 3'b111;
	assign resetn = KEY[0];

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
		.ship_control(ship_control),
		.scan_code(kb_scan_code),
		.letter_case(kb_letter_case)
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
	hex_display_direction(ship_control, HEX0);
	counter(CLOCK_50, count);
	// control the spaceship
	wire [1:0] direction;
	wire Enable;
	spaceship(CLOCK_50, x, y, count, ship_control, writeEn, direction);
	clock_divider(CLOCK_50, resetn, Enable);
endmodule

module spaceship(CLOCK_50, x, y, count, ship_control, writeEn, direction);
	input [3:0] ship_control;
	input [3:0] count;
	input CLOCK_50;
	input [7:0] x;
	input [6:0] y;
	output writeEn;
	output count;
	output reg [1:0] direction;
	always @(posedge CLOCK_50)
	begin
		case(ship_control[3:0])
			4'b0001: drawLeft(CLOCK_50, count, x, y, writeEn, direction);	// a
			4'b0010: drawRight(CLOCK_50, count, x, y, writeEn, direction); // d
			4'b0011: drawDown(CLOCK_50, count, x, y, writeEn, direction);	// s
			4'b0100: drawUp(CLOCK_50, count, x, y, writeEn, direction); // w
			4'b0101: shoot(Enable, direction, x, y); // space
		endcase
	end
	
endmodule

module hex_display_direction(IN, OUT);
    input [3:0] IN;
	 output reg [7:0] OUT;
	 
	 always @(*)
	 begin
		case(IN[3:0])
			4'b0001: OUT = 7'b1011111;	// a
			4'b0010: OUT = 7'b1111101; // d
			4'b0011: OUT = 7'b0111111;	// s
			4'b0100: OUT = 7'b1111110; // w
			4'b0101: OUT = 7'b1110111; // space
			
			default: OUT = 7'b1101011;
		endcase

	end
endmodule
