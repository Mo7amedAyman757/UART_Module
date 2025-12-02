`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2025 02:33:30 PM
// Design Name: 
// Module Name: Baudrate_tb
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


module Baudrate_tb();


//1- Declare local wire and reg

    reg clk_tb;
    reg areset_tb;
    reg rst_tb;
    reg en_tb;
    wire ticktx_tb;
    wire tickrx_tb;

//2- Instantiate the module under test
    Baudrate uut(
        .clk(clk_tb),
        .areset_n(areset_tb),
        .rst_n(rst_tb),
        .en(en_tb),
        .tick_rx(tickrx_tb),
        .tick_tx(ticktx_tb)
    );
    
 //3- General stimuli using always and initial
    localparam T  = 20;
    
    always 
    begin
        clk_tb = 1'b0;
        #(T/2);
        clk_tb = 1'b1;
        #(T/2);
    end  
    
    task tick_assert;
        input en;
        begin
            if(en) begin
                @(posedge en);
                $monitor("Time %0t: TICK asserted!", $time);
            end
            else begin
                $monitor("Time %0t: TICK skipped!", $time);
            end
        end
    endtask
    
    initial begin
        areset_tb = 0;
        en_tb = 0;
        rst_tb = 0;
        #20;
        
        areset_tb = 1;
        en_tb = 1;
        
        tick_assert(en_tb);
        #200;
        $stop;
    
    end
    
endmodule