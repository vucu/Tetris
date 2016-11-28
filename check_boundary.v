`include "definitions.vh"

module check_boundary(
	 input wire [255:0] board,
	 input wire [7:0]	block_xpos,	
	 input wire [7:0]	block_ypos,		
	 input wire [7:0]	block_type,		
    output reg can_move_down,
    output reg can_move_left,
    output reg can_move_right
	 );

	always @ (*) 
	begin
		if (block_type == `BLOCK_SINGLE) 
		begin
			can_move_down <= 1;
			can_move_left <= 1;
			can_move_right <= 1;
			
			if (block_xpos == 0)
			begin
				can_move_left <= 0;
			end
			else if ((board[block_xpos-1 + `BOARD_BLOCK_W*block_ypos]) == 1)
			begin
				can_move_left <= 0;
			end
			
			if (block_xpos == `BOARD_BLOCK_W-1)
			begin
				can_move_right <= 0;
			end
			else if ((board[block_xpos+1 + `BOARD_BLOCK_W*block_ypos]) == 1)
			begin
				can_move_right <= 0;
			end
			
			if (block_ypos == `BOARD_BLOCK_H-1)
			begin
				can_move_down <= 0;
			end
			else if ((board[block_xpos + `BOARD_BLOCK_W*(block_ypos+1)]) == 1)
			begin
				can_move_down <= 0;
			end
		end
	end
endmodule
