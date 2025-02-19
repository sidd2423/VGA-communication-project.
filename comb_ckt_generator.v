//============================================================================
// comb_ckt_generator.v
//============================================================================

module comb_ckt_generator (
	// VGA-related signals
   input vga_clk,              // Clock signal
	input slow_clk,
	input [9:0] col,					// Slowed down clock from clkdiv module   input  [9:0]  col,      // VGA column
   input  [8:0]  row,      // VGA row
   output [3:0]  red,      // 4-bit color output for red
   output [3:0]  green,    // 4-bit color output for green
   output [3:0]  blue,     // 4-bit color output for blue
   // input push buttons and switches
   input  [1:0]  KEY,      // Two board-level push buttons KEY1 - KEY0
   input  [9:0]  SW,       // Ten board-level switches SW9 - SW0
   // output LEDs and 7-segment displays
   output [9:0]  LEDR,     // Ten board-level LEDs LEDR9 - LEDR0
   output [7:0]  HEX0,     // Board-level 7-segment display
   output [7:0]  HEX1,     // Board-level 7-segment display
   output [7:0]  HEX2,     // Board-level 7-segment display
   output [7:0]  HEX3,     // Board-level 7-segment display
   output [7:0]  HEX4,     // Board-level 7-segment display
   output [7:0]  HEX5      // Board-level 7-segment display
   );

//============================================================================
//  reg/wire declarations
//============================================================================
// More complex implementations will likely declare RGB outputs as regs
// rather than wires
//wire [3:0]    red, green, blue; 
wire [3:0] tv_red, tv_green, tv_blue;   


//============================================================================
// Board-LED related circuits
//============================================================================			

// Temporary simple logic
// The 10 LEDs will light depending on the position of the adjacent 10 switches
assign LEDR = SW;      // ten LEDs assigned to ten switches

// Temporary simple logic
// This block sets the 7-segment HEX displays
// HEX4 - HEX0 are set to all dark
// HEX5 lights segments based on SW9 - SW2
assign HEX0 = 8'b1111_1111;

assign HEX5 = 8'b1111_1111;
assign HEX3 = 8'b1111_1111;
assign HEX4 = 8'b1111_1111;



tv_pattern tvPattern_inst (
    .vga_clk(vga_clk),
	 .slow_clk(slow_clk),
	 .x(col),       // Connect col input of comb_ckt_generator to x input of tvPattern
    .y(row),       // Connect row input of comb_ckt_generator to y input of tvPattern
    .red(tv_red),    // Output red of tvPattern
    .green(tv_green),  // Output green of tvPattern
    .blue(tv_blue),    // Output blue of tvPattern
    .SW(SW),
	 .KEY1(KEY[1]), // Pass KEY1 from the KEY input to the tv_pattern module
	 );
//==============================================================
// VGA display related circuits
//==============================================================
  reg [6:0] hex_value1;
      always@(*) begin
        case(SW[3:0])
            4'b0000: hex_value1 <= 7'b1111111;
				4'b0011: hex_value1 <= 7'b0000110;
				4'b0111: hex_value1 <= 7'b0000110;
            4'b1010 : hex_value1 <= 7'b0000110;
            4'b1100 : hex_value1 <= 7'b0000110;
            4'b0110: hex_value1 <= 7'b0000110;
            4'b1000 : hex_value1 <=7'b1111111;
            4'b0100 : hex_value1 <= 7'b1111111;
            4'b0010: hex_value1 <= 7'b1111111;
				4'b1110:hex_value1 <= 7'b0000110;
				4'b1101:hex_value1 <=  7'b0000110;
				 4'b1111 : hex_value1 <= 7'b0000110;
            default : hex_value1 <= 7'b1111111;
        endcase
    end
	 assign HEX2 = hex_value1;
	   
		
		reg [6:0] hex_value2;
      always@(*) begin
        case(SW[3:0])
            4'b0000: hex_value2 <= 7'b1111111;
				4'b0011: hex_value2 <= 7'b0101111;
				4'b0111: hex_value2 <= 7'b0101111;
            4'b1010 : hex_value2 <=  7'b0101111;
            4'b1100 : hex_value2 <=  7'b0101111;
            4'b0110: hex_value2 <=  7'b0101111;
            4'b1000 : hex_value2 <=7'b1111111;
            4'b0100 : hex_value2 <=  7'b1111111;
            4'b0010: hex_value2 <=  7'b1111111;
				4'b1110:hex_value2 <=  7'b0101111;
				4'b1101:hex_value2 <=  7'b0101111;
				4'b1111: hex_value2 <=  7'b0101111;
            default : hex_value2 <= 7'b1111111;
        endcase
    end
	 assign HEX1 = hex_value2;

// Connect outputs of tvPattern module to outputs of comb_ckt_generator
assign red = tv_red;
assign green = tv_green;
assign blue = tv_blue;


endmodule
