`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2025 02:13:27 PM
// Design Name: 
// Module Name: FIFO
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


module FIFO(
    input clk,
    input reset_n,
    input wr_en,
    input rd_en,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output full,
    output empty
    );
    
    reg [7:0] fifo [0:8];
    
    reg [3:0] rd_ptr, wr_ptr;
    
    //write operation
    always @(posedge clk or negedge reset_n)
    begin
        if(!reset_n)
            wr_ptr <= 0;    
        else if(wr_en && !full) begin
            fifo[wr_ptr[2:0]] <= data_in;
            wr_ptr <= wr_ptr + 1;
        end
    end
    
    //read operation
    always @(posedge clk or negedge reset_n)
    begin
        if(!reset_n)
            rd_ptr <= 0;    
        else if(rd_en && !empty) begin
            data_out <=  fifo[rd_ptr[2:0]];
            rd_ptr <= rd_ptr + 1;
        end
    end
    
    assign full = (rd_ptr == {~wr_ptr[3],wr_ptr[2:0]});
    assign empty = (rd_ptr == wr_ptr);
    
endmodule
