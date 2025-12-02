`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2025 01:38:41 PM
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


module Baudrate_tb(

    );
    
    //1- Declare local wire and reg
     reg clk;
     reg en;
    wire tick;
    
    //2- Instantiate the module under test
    Baudrate uut(
        .clk(clk),
        .en(en),
        .tick(tick)      
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
    
    // Task to wait for tick and report timing
    task wait_for_tick;
        integer count;
        begin
            count = 0;
            forever begin
                @(posedge tick);
                count = count + 1;
                $display("Tick #%0d generated at time = %0t ns", count, $time);
                if(count == 4) begin
                    $display("4 ticks detected, stopping simulation at %0t ns", $time);
                    $finish;
                end
            end
        end
    endtask
    
    
    
    initial 
    begin
        en = 1'b0;
        #10;
        en = 1'b1;
        
        wait_for_tick();
    end
    
endmodule
