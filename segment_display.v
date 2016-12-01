`timescale 1ns / 1ps

module segment_display(clk, score4, score3, score2, score1, segment, an);
    
    input clk;
    input [3:0] score4; 
    input [3:0] score3;
    input [3:0] score2;
    input [3:0] score1;
    output [7:0] segment;
    output [3:0] an;
    
    wire [2:0] min1;
    wire [3:0] min0;
    wire [2:0] sec1;
    wire [3:0] sec0;
    
    reg [7:0] segment;
    reg [3:0] an;
    
    reg [3:0] selection;
    
    // mod 4 Counter
    reg [1:0] counter = 0; 
   

    always @ (posedge clk)
    begin
        if (counter == 3)
            counter <= 0;
        else 
            counter <= counter + 1;
            
        case (counter)
          0: an <= 4'b0111;
          1: an <= 4'b1011;
          2: an <= 4'b1101;
          3: an <= 4'b1110;
        endcase
        
        case (counter)
          0: selection <= score3;
          1: selection <= score2;
          2: selection <= score1;
          3: selection <= score4;
        endcase
		
        case (selection)
            4'h0: segment = 8'b00111111;
            4'h1: segment = 8'b00000110;
            4'h2: segment = 8'b01011011;
            4'h3: segment = 8'b01001111;
            4'h4: segment = 8'b01100110;
            4'h5: segment = 8'b01101101;
            4'h6: segment = 8'b01111101;
            4'h7: segment = 8'b00000111;
            4'h8: segment = 8'b01111111;
            4'h9: segment = 8'b01101111;
            default: segment = 8'b00000000;
        endcase
        segment = ~segment;
    end

endmodule
