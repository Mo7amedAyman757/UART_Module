`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2025 05:05:49 PM
// Design Name: 
// Module Name: UART
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module UART(
    input clk,reset_n,
    
    // reciver port 
    input rx,
    input rd_uart,
    output rx_empty,
    output [7:0] r_data,
    
    // transmitter port
    input [7:0] w_data,
    input wr_uart,
    output tx_full,
    output tx
    );
    
    wire bd_tick;
    wire rx_done;
    wire [7:0] rx_data;
    wire tx_fifo_empty;
    wire tx_done;
    wire [7:0] tx_data;
    
    Baudrate  buadrate_generator(
     .clk(clk),
     .en(1'b1),
     .tick(bd_tick)
    );
    
    uart_rx rx_uut(
     .clk(clk), 
     .reset_n(reset_n),
     .s_tick(bd_tick), 
     .rx(rx),
     .rx_done_tick(rx_done),
     .rx_out(rx_data)
    );
    
     FIFO rx_fifo(
     .clk(clk),
     .reset_n(reset_n),
     .wr_en(rx_done),
     .rd_en(rd_uart),
     .data_in(rx_data),
     .data_out(r_data),
     .full(),
     .empty(rx_empty)
    );
    
     uart_tx tx_uut(
     .clk(clk), 
     .reset_n(reset_n),
     .tx_start(~tx_fifo_empty),
     .s_tick(bd_tick),
     .tx_din(tx_data),
     .tx_done_tick(tx_done),
     .tx(tx)
    );
    
     FIFO tx_fifo(
     .clk(clk),
     .reset_n(reset_n),
     .wr_en(wr_uart),
     .rd_en(tx_done),
     .data_in(w_data),
     .data_out(tx_data),
     .full(tx_full),
     .empty(tx_fifo_empty)
    );
    
    
endmodule
