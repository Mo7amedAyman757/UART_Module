`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2025 01:31:26 PM
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
    input en,
    output tick
    );
    
    localparam CLK_FREQ = 100_000_000;
    localparam BAUDRATE = 9600;
    localparam oversampling = 16;
    localparam DIVISOR = (CLK_FREQ / (BAUDRATE * oversampling)) -1;
    
    reg [13:0] counter;
    
    always @(posedge clk)
    begin
       if(en) begin
          if(counter == DIVISOR -1) begin
                counter <= 0;
          end
          else begin
                counter <= counter + 1;
          end
       end
       else begin
          counter <= 0;
       end
    end
    
    assign tick = (counter == DIVISOR -1);

endmodule
