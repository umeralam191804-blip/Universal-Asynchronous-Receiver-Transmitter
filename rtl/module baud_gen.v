module baud_gen(

    input clk,
    input rst,

    output reg baud_tick_tx,
    output reg baud_tick_rx

);


    reg [12:0] tx_count;
    reg [8:0]  rx_count;

    always @(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            tx_count <= 13'd0;
            rx_count <= 9'd0;

            baud_tick_tx <= 1'b0;
            baud_tick_rx <= 1'b0;
        end
        else
        begin

            baud_tick_tx <= 1'b0;
            baud_tick_rx <= 1'b0;

            if(tx_count == 5207)
            begin
                tx_count <= 13'd0;
                baud_tick_tx <= 1'b1;
            end
            else
            begin
                tx_count <= tx_count + 1;
            end

            if(rx_count == 324)
            begin
                rx_count <= 9'd0;
                baud_tick_rx <= 1'b1;
            end
            else
            begin
                rx_count <= rx_count + 1;
            end

        end
    end

endmodule
