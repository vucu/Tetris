`include "definitions.vh"

module tetris(
	input wire clk_in,
	output wire [7:0] rgb,
	output wire hsync,
	output wire vsync
	);

	wire clk_play;
	reg clk_play_rst;
	reg pause=0;
	wire clk;
	 
	// Board: 1 - Has block, 0 - No block
	reg [255:0] board;
	 
	// Define current block
	reg [7:0] block_xpos;
	reg [7:0] block_ypos;
	reg [7:0] block_type;
	 
	clock ck (
		.clk_in(clk_in),
		.rst(clk_play_rst),
		.pause(pause),
		.clk_out(clk),
		.clk_playable(clk_play)
	);
	
	wire can_move_down;
	wire can_move_left;
	wire can_move_right;
	check_boundary cb (
		.board(board),
		.block_xpos(block_xpos),
		.block_ypos(block_ypos),
		.block_type(block_type),
		.can_move_down(can_move_down),
		.can_move_left(can_move_left),
		.can_move_right(can_move_right)
	);

	vga_display display_ (
		.clk(clk),
		.board(board),
		.block_xpos(block_xpos),
		.block_ypos(block_ypos),
		.block_type(block_type),
		.rgb(rgb),
		.hsync(hsync),
		.vsync(vsync)
	);
	 
	// Test data
	initial 
	begin
		block_type = `BLOCK_SINGLE;
		block_xpos = 2;
		block_ypos = 0;
		board[43]=1;
		board[44]=1;
		board[57]=1;
	end
	
	// Test block going down
	always @ (posedge clk_play) 
	begin
		block_ypos <= block_ypos+1;
	end
	 
endmodule
