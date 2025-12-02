`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2025 02:33:06 PM
// Design Name: 
// Module Name: FIFO_tb
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


module FIFO_tb(

    );
    
     //1- Declare local wire and reg
     reg clk;
     reg reset_n;
     reg wr_en;
     reg rd_en;
     reg [7:0] data_in;
     wire [7:0] data_out;
     wire full;
     wire empty;
    
    //2- Instantiate the module under test
        FIFO uut(
        .clk(clk),
        .reset_n(reset_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)      
    );
    
    
    //2- General stimuli using always and initial
    localparam T = 10; // clock is 10 ns as frequency = 100 MHZ
    always 
    begin
        clk = 1'b0;
        #(T / 2);
        clk = 1'b1;
        #(T / 2);    
    end
    
    // Task to write in FIFO
    task write_data(input [7:0] d_in);
    begin
        @(posedge clk)
            wr_en = 1'b1;
            data_in = d_in;
        @(posedge clk)
            wr_en = 1'b0;
    
    end 
    endtask
    
    // Task to read from FIFO
    task read_data;
    begin
        @(posedge clk)
            rd_en = 1'b1;
        @(posedge clk)
            rd_en = 1'b0;
    end 
    endtask
    
    integer i;
    
    initial 
    begin
        #1;
        reset_n = 0; rd_en = 0; wr_en = 0;
        
        @(posedge clk)
        reset_n = 1;       
        
        // scenario 1
        
        for(i = 0; i < 8; i = i+1)
        begin
            write_data(2**i+2);
        end
        
        for(i = 0; i < 8; i = i+1)
        begin
            read_data();
        end
      
        // scenario 2
        for(i = 0; i < 8; i = i+1)
        begin
            write_data(2**i);
            read_data();
        end
        
         // scenario 3
        write_data(1);
        write_data(10);
        write_data(100);
        
        read_data();
        read_data();
        read_data();
        
        #40 $finish;
    end
    
endmodule
