`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/22/2025 07:50:01 PM
// Design Name: 
// Module Name: TX
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


module TX(
    input clk,
    input areset_n,rst_n,
    input [7:0] data_in,
    input tx_en,
    output busy,
    output done,
    output tx
    );
    
    wire tick_done;
    
    Baudrate uut1(
        .clk(clk),
        .areset_n(areset_n),
        .rst_n(rst_n),
        .en(tx_en),
        .tick_tx(tick_done),
        .tick_rx()
    );
    
    TX_FSM uut2(
        .clk(clk),
        .areset_n(areset_n),
        .rst_n(rst_n),
        .tx_en(tx_en),
        .data_in(data_in),
        .baud_tick(tick_done),
        .busy(busy),
        .done(done),
        .tx(tx)
    );
    
    
endmodule
