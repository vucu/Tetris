`include "definitions.vh"

module vga_display(
	input wire clk,
	input wire [127:0] board,
	input wire [7:0]	block_xpos,	
	input wire [7:0]	block_ypos,		
	input wire [7:0]	block_type,			 
	output reg [7:0] rgb,
	output wire hsync,
	output wire vsync
	);

	reg [9:0] pixel_x = 0;
	reg [9:0] pixel_y = 0;
 
	assign hsync = ~(pixel_x >= (`W + `HSYNC_FRONT_PORCH) &&
                     pixel_x < (`W + `HSYNC_FRONT_PORCH + `HSYNC_PULSE_WIDTH));
	assign vsync = ~(pixel_y >= (`H + `VSYNC_FRONT_PORCH) &&
                     pixel_y < (`H + `VSYNC_FRONT_PORCH + `VSYNC_PULSE_WIDTH));

	wire [7:0] board_xpos = (pixel_x-`BOARD_XSTART)/`BLOCK_SIZE;
	wire [7:0] board_ypos = (pixel_y-`BOARD_YSTART)/`BLOCK_SIZE;
	wire [7:0] board_position = board_xpos + `BOARD_BLOCK_W*board_ypos;
	reg [2:0] cur_vid_mem;
	always @ (*) 
	begin
		if (pixel_x > `BOARD_XSTART && pixel_y > `BOARD_YSTART &&
            pixel_x < `BOARD_XSTART + `BOARD_WIDTH && pixel_y < `BOARD_YSTART + `BOARD_HEIGHT) 
		begin
			begin			
				// Drawing board
				if (board[board_position]==1)
				begin
					rgb = `BLUE;
				end
				else
				begin
					rgb = `ORANGE;
				end
					
				// Drawing block
				if (block_type == `BLOCK_SINGLE) 
				begin
					if ((board_xpos==block_xpos)&&(board_ypos==block_ypos)) 
					begin
						rgb = `GREEN;
					end
				end
				else if (block_type == `BLOCK_I_VERTICAL) 
				begin
					if ((board_xpos==block_xpos)&&(board_ypos==block_ypos)) 
					begin
						rgb = `GREEN;
					end
					if ((board_xpos==block_xpos)&&(board_ypos==block_ypos-1)) 
					begin
						rgb = `GREEN;
					end
					if ((board_xpos==block_xpos)&&(board_ypos==block_ypos+1)) 
					begin
						rgb = `GREEN;
					end
				end
				else if (block_type == `BLOCK_I_HORRIZONTAL) 
				begin
					if ((board_xpos==block_xpos)&&(board_ypos==block_ypos)) 
					begin
						rgb = `GREEN;
					end
					if ((board_xpos==block_xpos-1)&&(board_ypos==block_ypos)) 
					begin
						rgb = `GREEN;
					end
					if ((board_xpos==block_xpos+1)&&(board_ypos==block_ypos)) 
					begin
						rgb = `GREEN;
					end
				end
			end 
		end 
		else 
		begin
			rgb = `BLACK;
		end
	end

   always @ (posedge clk) 
	begin
       if (pixel_x >= `W + `HSYNC_FRONT_PORCH + `HSYNC_PULSE_WIDTH + `HSYNC_BACK_PORCH) 
		 begin
           pixel_x <= 0;
           if (pixel_y >= `H + `VSYNC_FRONT_PORCH + `VSYNC_PULSE_WIDTH + `VSYNC_BACK_PORCH) 
			  begin
               pixel_y <= 0;
           end 
			  else 
			  begin
               pixel_y <= pixel_y + 1;
           end
       end 
		 else 
		 begin
           pixel_x <= pixel_x + 1;
       end
   end

endmodule
