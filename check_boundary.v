`include "definitions.vh"

  module check_boundary(
	 input wire [127:0] board,
	 input wire [7:0]	block_xpos,	
	 input wire [7:0]	block_ypos,		
	 input wire [7:0]	block_type,		
    output reg can_move_down,
    output reg can_move_left,
    output reg can_move_right,
	 output reg can_rotate
	 );

	always @ (*) 
	begin
		if (block_type == `BLOCK_SINGLE) 
		begin
			can_move_down <= 1;
			can_move_left <= 1;
			can_move_right <= 1;
			can_rotate <= 0;
			
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
		else if (block_type == `BLOCK_I_VERTICAL) 
		begin
			can_move_down <= 1;
			can_move_left <= 1;
			can_move_right <= 1;
			can_rotate <= 1;
			
			if (block_xpos == 0)
			begin
				can_move_left <= 0;
				can_rotate <= 0;
			end
			else if ((board[block_xpos-1 + `BOARD_BLOCK_W*block_ypos]) == 1)
			begin
				can_move_left <= 0;
				can_rotate <= 0;
			end
			else if ((board[block_xpos-1 + `BOARD_BLOCK_W*(block_ypos-1)]) == 1)
			begin
				can_move_left <= 0;
			end
			else if ((board[block_xpos-1 + `BOARD_BLOCK_W*(block_ypos+1)]) == 1)
			begin
				can_move_left <= 0;
			end
			
			if (block_xpos == `BOARD_BLOCK_W-1)
			begin
				can_move_right <= 0;
				can_rotate <= 0;
			end
			else if ((board[block_xpos+1 + `BOARD_BLOCK_W*block_ypos]) == 1)
			begin
				can_move_right <= 0;
				can_rotate <= 0;
			end
			else if ((board[block_xpos+1 + `BOARD_BLOCK_W*(block_ypos-1)]) == 1)
			begin
				can_move_right <= 0;
			end
			else if ((board[block_xpos+1 + `BOARD_BLOCK_W*(block_ypos+1)]) == 1)
			begin
				can_move_right <= 0;
			end
			
			if (block_ypos == `BOARD_BLOCK_H-2)
			begin
				can_move_down <= 0;
			end
			else if ((board[block_xpos + `BOARD_BLOCK_W*(block_ypos+2)]) == 1)
			begin
				can_move_down <= 0;
			end
		end
		else if (block_type == `BLOCK_I_HORRIZONTAL) 
		begin
			can_move_down <= 1;
			can_move_left <= 1;
			can_move_right <= 1;
			can_rotate <= 1;
			
			if (block_xpos == 1)
			begin
				can_move_left <= 0;
			end
			else if ((board[block_xpos-2 + `BOARD_BLOCK_W*block_ypos]) == 1)
			begin
				can_move_left <= 0;
			end
			
			if (block_xpos == `BOARD_BLOCK_W-2)
			begin
				can_move_right <= 0;
			end
			else if ((board[block_xpos+2 + `BOARD_BLOCK_W*block_ypos]) == 1)
			begin
				can_move_right <= 0;
			end
			
			if (block_ypos == `BOARD_BLOCK_H-1)
			begin
				can_move_down <= 0;
				can_rotate <= 0;
			end
			else if ((board[block_xpos + `BOARD_BLOCK_W*(block_ypos+1)]) == 1)
			begin
				can_move_down <= 0;
				can_rotate <= 0;
			end
			else if ((board[block_xpos-1 + `BOARD_BLOCK_W*(block_ypos+1)]) == 1)
			begin
				can_move_down <= 0;
			end
			else if ((board[block_xpos+1 + `BOARD_BLOCK_W*(block_ypos+1)]) == 1)
			begin
				can_move_down <= 0;
			end
		end
	end
endmodule
