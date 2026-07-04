module uart_tx(
    input clk,
    input rst,

    input baud_tick,
    input tx_start,
    input [7:0] data_in,

    output reg tx,
    output reg tx_busy
);

    parameter IDLE  = 3'd0;
    parameter START = 3'd1;
    parameter DATA  = 3'd2;
    parameter PARITY= 3'd3;
    parameter STOP  = 3'd4;

    reg [2:0] state;

    reg [7:0] data_reg;
    reg [2:0] bit_count;

    reg parity_bit;

    always @(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            state <= IDLE;
            tx <= 1'b1;
            tx_busy <= 1'b0;

            data_reg <= 8'd0;
            bit_count <= 3'd0;
            parity_bit <= 1'b0;
        end

        else
        begin
            case(state)

            IDLE:
            begin
                tx <= 1'b1;
                tx_busy <= 1'b0;

                if(tx_start)
                begin
                    data_reg <= data_in;
                    parity_bit <= ^data_in;   // Even parity
                    bit_count <= 3'd0;

                    tx_busy <= 1'b1;
                    state <= START;
                end
            end

            START:
            begin
                tx <= 1'b0;

                if(baud_tick)
                    state <= DATA;
            end

            DATA:
            begin
                tx <= data_reg[bit_count];

                if(baud_tick)
                begin
                    if(bit_count == 3'd7)
                        state <= PARITY;
                    else
                        bit_count <= bit_count + 1'b1;
                end
            end

            PARITY:
            begin
                tx <= parity_bit;

                if(baud_tick)
                    state <= STOP;
            end

            STOP:
            begin
                tx <= 1'b1;

                if(baud_tick)
                begin
                    tx_busy <= 1'b0;
                    state <= IDLE;
                end
            end

            default:
                state <= IDLE;

            endcase
        end
    end

endmodule