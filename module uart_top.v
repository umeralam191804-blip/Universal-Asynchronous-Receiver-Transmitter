module uart_top(

    input clk,
    input rst,
    input tx_start,
    input [7:0] data_in,

    input rx,

    output tx,

    output [7:0] data_out,
    output rx_done,
    output parity_error,

    output tx_busy

);

    wire baud_tick_tx;
    wire baud_tick_rx;

    baud_gen BAUD(

        .clk(clk),
        .rst(rst),

        .baud_tick_tx(baud_tick_tx),
        .baud_tick_rx(baud_tick_rx)

    );

    uart_tx TX(

        .clk(clk),
        .rst(rst),

        .baud_tick(baud_tick_tx),

        .tx_start(tx_start),

        .data_in(data_in),

        .tx(tx),

        .tx_busy(tx_busy)

    );


    uart_rx RX(

        .clk(clk),
        .rst(rst),

        .baud_tick(baud_tick_rx),

        .rx(rx),

        .data_out(data_out),

        .rx_done(rx_done),

        .parity_error(parity_error)

    );

endmodule