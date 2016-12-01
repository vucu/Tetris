module debouncer(
    input wire clk,
    input wire btn_in,
    output wire btn_out
    );

    reg signal;
    reg signal_prev;
    reg [15:0] counter;

    initial begin
        signal = 0;
        signal_prev = 0;
        counter = 0;
    end

    always @ (posedge clk) begin
        if (counter == 10000) begin
            counter <= 0;
            signal <= btn_in;
        end else begin
            counter <= counter + 1;
        end

        signal_prev <= signal;
    end

    assign btn_out = signal && !signal_prev;
endmodule
