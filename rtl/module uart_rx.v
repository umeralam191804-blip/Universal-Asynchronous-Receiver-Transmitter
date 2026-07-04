module uart_rx(
    input clk,
    input rst,

    input baud_tick,
    input rx,

    output reg [7:0] data_out,
    output reg rx_done,
    output reg parity_error
);

    parameter IDLE   = 3'd0;
    parameter START  = 3'd1;
    parameter DATA   = 3'd2;
    parameter PARITY = 3'd3;
    parameter STOP   = 3'd4;
    parameter DONE   = 3'd5;

    reg [2:0] state;

    reg [7:0] shift_reg;
    reg [2:0] bit_count;

    reg received_parity;
    reg calc_parity;

    always @(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            data_out <= 0;
            rx_done <= 0;
            parity_error <= 0;
            received_parity <= 0;
        end

        else
        begin
            case(state)

            IDLE:
            begin
                rx_done <= 0;

                if(rx == 0)
                    state <= START;
            end

            START:
            begin
                if(baud_tick)
                begin
                    bit_count <= 0;
                    state <= DATA;
                end
            end


            DATA:
            begin
                if(baud_tick)
                begin
                    shift_reg[bit_count] <= rx;

                    if(bit_count == 7)
                        state <= PARITY;
                    else
                        bit_count <= bit_count + 1;
                end
            end

            PARITY:
            begin
                if(baud_tick)
                begin
                    received_parity <= rx;
                    state <= STOP;
                end
            end

            STOP:
            begin
                if(baud_tick)
                begin
                    calc_parity = ^shift_reg;

                    if(calc_parity != received_parity)
                        parity_error <= 1;
                    else
                        parity_error <= 0;

                    data_out <= shift_reg;

                    state <= DONE;
                end
            end

            DONE:
            begin
                rx_done <= 1;
                state <= IDLE;
            end

            default:
                state <= IDLE;

            endcase
        end
    end

endmodule