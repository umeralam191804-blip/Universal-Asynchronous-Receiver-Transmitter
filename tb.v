`timescale 1ns/1ps

module uart_tb_simple();

    reg clk = 0;
    reg rst;

    always #10 clk = ~clk;   
    wire baud_tick_tx;
    wire baud_tick_rx;

    reg        tx_start;
    reg  [7:0] data_in;
    wire       tx;
    wire       tx_busy;

    wire [7:0] data_out;
    wire       rx_done;
    wire       parity_error;

   
    baud_gen u_baud (
        .clk(clk),
        .rst(rst),
        .baud_tick_tx(baud_tick_tx),
        .baud_tick_rx(baud_tick_rx)
    );

    uart_tx u_tx (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick_tx),
        .tx_start(tx_start),
        .data_in(data_in),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    uart_rx u_rx (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick_tx),   
        .rx(tx),                   
        .data_out(data_out),
        .rx_done(rx_done),
        .parity_error(parity_error)
    );
 
    initial begin
        $dumpfile("uart_tb_simple.vcd");
        $dumpvars(0, uart_tb_simple);
    end

    initial begin

        rst      = 1;
        tx_start = 0;
        data_in  = 8'd0;
        #200;              
        rst = 0;
        #200;              
        data_in  = 8'h55;
        tx_start = 1;
        #20;                     
        tx_start = 0;

        wait (tx_busy == 1);      
        wait (tx_busy == 0);      
        wait (rx_done == 1);      
        if (data_out == 8'h55)
            $display("TEST 1 PASS: sent 0x55, got 0x%02h", data_out);
        else
            $display("TEST 1 FAIL: sent 0x55, got 0x%02h", data_out);

        #200;         
        data_in  = 8'hAA;
        tx_start = 1;
        #20;
        tx_start = 0;

        wait (tx_busy == 1);
        wait (tx_busy == 0);
        wait (rx_done == 1);

        if (data_out == 8'hAA)
            $display("TEST 2 PASS: sent 0xAA, got 0x%02h", data_out);
        else
            $display("TEST 2 FAIL: sent 0xAA, got 0x%02h", data_out);

        #200;

        data_in  = 8'h00;
        tx_start = 1;
        #20;
        tx_start = 0;

        wait (tx_busy == 1);
        wait (tx_busy == 0);
        wait (rx_done == 1);

        if (data_out == 8'h00)
            $display("TEST 3 PASS: sent 0x00, got 0x%02h", data_out);
        else
            $display("TEST 3 FAIL: sent 0x00, got 0x%02h", data_out);

        #200;

        
        data_in  = 8'hFF;
        tx_start = 1;
        #20;
        tx_start = 0;

        wait (tx_busy == 1);
        wait (tx_busy == 0);
        wait (rx_done == 1);

        if (data_out == 8'hFF)
            $display("TEST 4 PASS: sent 0xFF, got 0x%02h", data_out);
        else
            $display("TEST 4 FAIL: sent 0xFF, got 0x%02h", data_out);

        #200;

        $display("All tests done.");
        $finish;
    end

endmodule