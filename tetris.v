`include "definitions.vh"

module tetris(
	input wire clk_in,
	input wire btnL,
   input wire btnR,
   input wire btnD,
	input wire btnS,
	output wire [7:0] rgb,
	output wire hsync,
	output wire vsync,
	output wire [7:0] segment,
   output wire [3:0] an
	);

	
	/*****************************************************
	* 	DEFINITIONS
	**/
	// Board: 1 - Has block, 0 - No block
	reg [127:0] board;
	 
	// Define current block
	reg [7:0] block_xpos;
	reg [7:0] block_ypos;
	reg [7:0] block_type;
	
	// Score
	reg [3:0] score1;
	reg [3:0] score2;
	reg [3:0] score3;
	reg [3:0] score4;
	assign score = 1000*score4 + 100*score3 + 10*score2 + score1;
	
	// Helper variables
	wire can_move_down;
	wire can_move_left;
	wire can_move_right;
	wire can_rotate;
	reg should_create_new_block;
	reg should_check_full_row;
	reg should_check_game_over;
	assign is_game_over = |board[0+:`BOARD_BLOCK_W];
	reg [7:0] next_block;
	
	// System
	wire clk_play;
	wire clk_segment;
	reg rst=0;
	reg pause=0;
	wire clk;
	wire btnL_out;
	wire btnR_out;
	wire btnD_out;
	wire btnS_out;
	
	/*****************************************************
	* 	MODULES
	**/	
	clock ck (
		.clk_in(clk_in),
		.rst(rst),
		.pause(pause),
		.clk_out(clk),
		.clk_playable(clk_play),
		.clk_segment(clk_segment)
	);
	
	check_boundary cb (
		.board(board),
		.block_xpos(block_xpos),
		.block_ypos(block_ypos),
		.block_type(block_type),
		.can_move_down(can_move_down),
		.can_move_left(can_move_left),
		.can_move_right(can_move_right),
		.can_rotate(can_rotate)
	);

	vga_display vd (
		.clk(clk),
		.board(board),
		.block_xpos(block_xpos),
		.block_ypos(block_ypos),
		.block_type(block_type),
		.rgb(rgb),
		.hsync(hsync),
		.vsync(vsync)
	);
	
	debouncer dbl (
		.clk(clk),
		.btn_in(btnL),
		.btn_out(btnL_out)
	);
	
	debouncer dbr (
		.clk(clk),
		.btn_in(btnR),
		.btn_out(btnR_out)
	);
	
	debouncer dbd (
		.clk(clk),
		.btn_in(btnD),
		.btn_out(btnD_out)
	);
	
	debouncer dbs (
		.clk(clk),
		.btn_in(btnS),
		.btn_out(btnS_out)
	);
	
	segment_display sd (
		.clk(clk_segment), 
		.score4(score4), 
		.score3(score3), 
		.score2(score2), 
		.score1(score1), 
		.segment(segment), 
		.an(an)
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
			should_create_new_block <= 1;
		end
	endtask
	
	task rotate;
		if (can_rotate)
		begin
			if (block_type==`BLOCK_I_VERTICAL)
			begin
				block_type <= `BLOCK_I_HORRIZONTAL;
			end
			else if (block_type==`BLOCK_I_HORRIZONTAL)
			begin
				block_type <= `BLOCK_I_VERTICAL;
			end
		end 
	endtask
	
	task create_new_block;
		begin
			// Stick old block to board
			if (block_type == `BLOCK_SINGLE) 
			begin
				board[block_xpos + `BOARD_BLOCK_W*block_ypos] <= 1;
			end
			else if (block_type == `BLOCK_I_VERTICAL) 
			begin
				board[block_xpos + `BOARD_BLOCK_W*(block_ypos-1)] <= 1;
				board[block_xpos + `BOARD_BLOCK_W*block_ypos] <= 1;
				board[block_xpos + `BOARD_BLOCK_W*(block_ypos+1)] <= 1;
			end 
			else if (block_type == `BLOCK_I_HORRIZONTAL) 
			begin
				board[block_xpos-1 + `BOARD_BLOCK_W*block_ypos] <= 1;
				board[block_xpos + `BOARD_BLOCK_W*block_ypos] <= 1;
				board[block_xpos+1 + `BOARD_BLOCK_W*block_ypos] <= 1;
			end
			
			// New block
			block_type <= next_block;
			case (block_type)
				`BLOCK_SINGLE: next_block <= `BLOCK_I_VERTICAL;
				`BLOCK_I_VERTICAL: next_block <= `BLOCK_I_HORRIZONTAL;
				`BLOCK_I_HORRIZONTAL: next_block <= `BLOCK_SINGLE;
			endcase
		  
			block_xpos <= 2;
			block_ypos <= 0;
		end
	endtask
	
	reg [7:0] board_ypos;
	task check_full_row;
		for (board_ypos=0;board_ypos<`BOARD_BLOCK_H;board_ypos=board_ypos+1)
		begin
			if (&board[board_ypos*`BOARD_BLOCK_W +: `BOARD_BLOCK_W] == 1)
			begin
				board[board_ypos*`BOARD_BLOCK_W +: `BOARD_BLOCK_W] <= 6'b000000;
				increase_score();
			end
		end
	endtask
	
	task increase_score;
		if (score1 == 9) 
		begin
			if (score2 == 9) 
			begin
				if (score3 == 9) 
				begin
					if (score4 != 9) 
					begin
						score4 <= score4 + 1;
						score3 <= 0;
						score2 <= 0;
						score1 <= 0;
					end
				end 
				else 
				begin
					score3 <= score3 + 1;
					score2 <= 0;
					score1 <= 0;
				end
			end 
			else 
			begin
				score2 <= score2 + 1;
				score1 <= 0;
			end
		end 
		else 
		begin
			score1 <= score1 + 1;
		end
	endtask;
	
	/*****************************************************
	* 	MAIN FUNCTION
	**/
	task reset;
	begin
		block_type <= `BLOCK_I_VERTICAL;
		next_block <= `BLOCK_I_HORRIZONTAL;
		block_xpos <= 2;
		block_ypos <= 0;
		should_create_new_block <= 0;
		should_check_full_row <= 0;
		should_check_game_over <= 0;
		board <= 0;
		
		// test data
		board[43] <= 1;
		board[44] <= 1;
		board[57] <= 1;
		
		score1 <= 0;
		score2 <= 0;
		score3 <= 0;
		score4 <= 0;
	end
	endtask;
	
	initial 
	begin
		reset();
	end
	
	always @ (posedge clk) 
	begin
		if (clk_play) 
		begin
			move_down();
		end
		else if (should_create_new_block)
		begin
			create_new_block();
			should_create_new_block <= 0;
			should_check_full_row <= 1;
		end
		else if (should_check_full_row)
		begin
			check_full_row();
			should_check_full_row <= 0;
			should_check_game_over <= 1;
		end
		else if (should_check_game_over)
		begin
			if (is_game_over)
			begin
				reset();
			end
			should_check_game_over <= 0;
		end
		
		if (btnL_out) 
		begin
			move_left();
		end
		else if (btnR_out)
		begin
			move_right();
		end
		else if (btnD_out)
		begin
			move_down();
		end
		else if (btnS_out)
		begin
			rotate();
		end
	end
	 
endmodule
