`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2025 03:22:58 PM
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
    input clk,
    input areset_n,
    input rst_n,
    
    // TX Interface
    input [7:0] data_in,
    input tx_en,
    output tx_busy,
    output tx_done,
    output tx,
    
    // RX Interface
    input rx_en,
    input rx,
    output  [7:0] data_out,
    output rx_busy,
    output rx_done,
    output  rx_error 
    );
       
    wire ticktx_done;
    wire tickrx_done;
    wire baud_en;
    
    Baudrate Baud_uut(
        .clk(clk),
        .areset_n(areset_n),
        .rst_n(rst_n),
        .en(tx_en || (rx_en && baud_en)),
        .tick_tx(ticktx_done),
        .tick_rx(tickrx_done)
    );
    
    TX_FSM TX_uut(
        .clk(clk),
        .areset_n(areset_n),
        .rst_n(rst_n),
        .tx_en(tx_en),
        .data_in(data_in),
        .baud_tick(ticktx_done),
        .busy(tx_busy),
        .done(tx_done),
        .tx(tx)
    );   
      
    RX_FSM RX_uut(
        .clk(clk),
        .areset_n(areset_n),
        .rst_n(rst_n),
        .rx_en(rx_en),
        .baud_tick(tickrx_done),
        .rx(rx),
     
        .data_out(data_out),
        .busy(rx_busy),
        .done(rx_done),
        .baud_en(baud_en),
        .error(rx_error)
    );  
    
endmodule
