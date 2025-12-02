`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/22/2025 07:55:39 PM
// Design Name: 
// Module Name: TX_tb
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


module TX_tb();

 //1- Declare local wire and reg
    reg clk_tb, areset_tb,rst_n;
    reg [7:0] data_tb;
    reg txen_tb;
    wire busy_tb;
    wire done_tb;
    wire tx_tb;
    
 //2- Instantiate the module under test
    TX uut(
        .clk(clk_tb),
        .areset_n(areset_tb),
        .rst_n(rst_n),
        .data_in(data_tb),
        .tx_en(txen_tb),
        .busy(busy_tb),
        .done(done_tb),
        .tx(tx_tb)
    );     
    
 //3- General stimuli using always and initial
 localparam T = 20;
 always begin
    clk_tb = 1'b0; #(T / 2);
    clk_tb = 1'b1; #(T / 2);
 end
 
 task write_data;
    input [7:0] data; 
    input txen;
    begin
        txen_tb = txen;
        data_tb = data; 
        $display("Time = %0t, reset=%b, txen=%b, data=%h, busy=%b, done=%b, tx=%b", 
                       $time, areset_tb, txen_tb, data_tb, busy_tb, done_tb, tx_tb);
    end
 endtask
 
 initial begin
    areset_tb = 0;
    rst_n = 0;
    write_data(8'b0,0);
     
    #20;
    areset_tb = 1;
    #(20);
    write_data(8'b01010101,1); 
    // Wait for transmission to complete
    wait(done_tb);
    #2000;
    txen_tb = 0;
    #20;
    write_data(8'b01111101,1); 
    
    #20 $finish;
 end


endmodule
