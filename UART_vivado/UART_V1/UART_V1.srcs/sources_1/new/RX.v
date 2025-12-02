`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/22/2025 09:35:00 PM
// Design Name: 
// Module Name: RX
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


module RX(
    input clk,
    input reset_n,rst_n,
    input rx_en,
    input rx,
    
    output  [7:0] data_out,
    output  done,
    output  busy,
    output  error
    );
    
    wire tickrx_done;
    wire baud_en;
    
    Baudrate uut1(
        .clk(clk),
        .areset_n(reset_n),
        .rst_n(rst_n),
        .en(rx_en | baud_en),
        .tick_rx(tickrx_done),
        .tick_tx()
    );
    
    
    RX_FSM uut2(
        .clk(clk),
        .areset_n(reset_n),
        .rst_n(rst_n),
        .rx_en(rx_en),
        .baud_tick(tickrx_done),
        .rx(rx),
     
        .data_out(data_out),
        .busy(busy),
        .done(done),
        .baud_en(baud_en),
        .error(error)
    );
    
    
endmodule
