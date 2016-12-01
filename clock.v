module clock(clk_in, rst, pause, clk_out, clk_playable, clk_segment);
	input clk_in;
	input rst;
	input pause;
	output clk_out;
	output clk_playable;
	output clk_segment;
	
	wire clk_in;
	wire rst;
	wire pause;
	reg clk_out=0;
	reg clk_playable=0;
	reg clk_segment=0;
	
	reg clk_count = 0;
	
	
	// clk_out: 25 MHz
	reg [2:0] out_counter=0;
	always @ (posedge clk_in)
	begin
		  out_counter <= out_counter+1;
		  if (out_counter[0]==1)
		  begin
            clk_out <= ~clk_out;
        end
    end
	 
	// clk_segment
	reg [15:0] segment_counter=0;
	always @ (posedge clk_in) 
	begin
		if (segment_counter == 20000) 
		begin 
			segment_counter <= 0;
			clk_segment <= 1;
		end 
		else 
		begin
			segment_counter <= segment_counter + 1;
			clk_segment <= 0;
		end
	end
	 
	// clk_playable
	reg [31:0] playable_counter=0;
	always @ (posedge clk_in) 
	begin
		if (!pause) 
		begin
			if (rst) 
			begin
			playable_counter <= 0;
			clk_playable <= 0;
			end 
			else 
			begin
				if (playable_counter == 20000000) 
				begin 
					playable_counter <= 0;
					clk_playable <= 1;
				end 
				else 
				begin
					playable_counter <= playable_counter + 1;
					clk_playable <= 0;
				end
			end
		end
	end
	
endmodule
