`include "definitions.vh"

module tetris(
	input wire clk_in,
	input wire btnL,
   input wire btnR,
   input wire btnD,
	output wire [7:0] rgb,
	output wire hsync,
	output wire vsync
	);

	wire clk_play;
	reg clk_play_rst;
	reg pause=0;
	wire clk;
	
	/*****************************************************
	* 	DEFINITIONS
	**/
	// Board: 1 - Has block, 0 - No block
	reg [255:0] board;
	 
	// Define current block
	reg [7:0] block_xpos;
	reg [7:0] block_ypos;
	reg [7:0] block_type;
	
	// Score
	reg [15:0] score;
	
	// Helper variables
	wire can_move_down;
	wire can_move_left;
	wire can_move_right;
	
	/*****************************************************
	* 	MODULES
	**/	
	clock ck (
		.clk_in(clk_in),
		.rst(clk_play_rst),
		.pause(pause),
		.clk_out(clk),
		.clk_playable(clk_play)
	);
	
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
	
	
	/*****************************************************
	* 	HELPER FUNCTIONS
	**/	
	task move_left;
		if (can_move_left) 
		begin
			block_xpos <= block_xpos-1;
		end
	endtask
	
	task move_right;
		if (can_move_right) 
		begin
			block_xpos <= block_xpos+1;
		end
	endtask
	
	task move_down;
		if (can_move_down) 
		begin
			block_ypos <= block_ypos+1;
		end
		else
		begin
			// Stick it to board
			board[block_xpos + `BOARD_BLOCK_W*block_ypos] <= 1;
			
			// New block
			block_type <= `BLOCK_SINGLE;
			block_xpos <= 2;
			block_ypos <= 0;
		end
	endtask
	
	reg flag_row_full;
	reg [7:0] board_xpos;
	reg [7:0] board_ypos;
	task check_full_row;
		for (board_ypos=0;board_ypos<`BOARD_BLOCK_H;board_ypos=board_ypos+1)
		begin
			// Check if this row is full
			flag_row_full <= 1;
			for (board_xpos=0;board_xpos<`BOARD_BLOCK_W;board_xpos=board_xpos+1)
			begin
				if (!board[board_xpos + `BOARD_BLOCK_W*board_ypos])
				begin
					flag_row_full <= 0;
				end
			end
			
			// This row is full, remove
			if (flag_row_full)
			begin
				for (board_xpos=0;board_xpos<`BOARD_BLOCK_W;board_xpos=board_xpos+1)
				begin
					board[board_xpos + `BOARD_BLOCK_W*board_ypos] <= 0;
				end
			end
		end
	endtask
	
	/*****************************************************
	* 	MAIN FUNCTION
	**/	
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
	always @ (posedge clk) 
	begin
		if (clk_play) 
		begin
			move_down();
			check_full_row();
		end
		
		if (btnL) 
		begin
			move_left();
		end
		else if (btnR)
		begin
			move_right();
		end
		else if (btnD)
		begin
			move_down();
		end
	end
	 
endmodule
