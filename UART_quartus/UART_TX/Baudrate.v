`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2025 02:33:02 PM
// Design Name: 
// Module Name: Baudrate
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


module Baudrate(
    input clk,
    input areset_n,
    input rst_n,
    input en,
    output tick_tx,
    output tick_rx
    );
    
    localparam CLK_FRQ  = 50_000_000; //50MHZ
    localparam BAUDRATE = 9600; // 9600 bits / seconds
    localparam DIVISOR_tx = CLK_FRQ / BAUDRATE;
    localparam DIVISOR_rx = CLK_FRQ / (BAUDRATE * 16);
    
    reg [12:0] counter_tx;
    reg [9:0] counter_rx;
    
    always @(posedge clk or negedge areset_n)
    begin
        if(!areset_n)
            counter_tx <= 1'b0;
        else if(rst_n)
            counter_tx <= 1'b0;
        else begin
            if(en) begin
                if( counter_tx ==  DIVISOR_tx -1)
                counter_tx <= 1'b0;
            else
                counter_tx <= counter_tx + 1;
            end
        end                  
    end
    
    always @(posedge clk or negedge areset_n)
    begin
        if(!areset_n)
            counter_rx <= 1'b0;
        else if(rst_n)
            counter_rx <= 1'b0;
        else begin
            if(en) begin
                if( counter_rx ==  DIVISOR_rx -1)
                counter_rx <= 1'b0;
            else
                counter_rx <= counter_rx + 1;
            end
        end                  
    end
   
   assign tick_tx = (counter_tx ==  DIVISOR_tx -1);
   assign tick_rx = (counter_rx ==  DIVISOR_rx -1);
endmodule
