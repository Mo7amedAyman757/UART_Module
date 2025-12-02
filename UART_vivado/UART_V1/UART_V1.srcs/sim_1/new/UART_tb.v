`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/25/2025 10:26:08 PM
// Design Name: 
// Module Name: UART_tb
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


module  UART_tb();

//1- Delcare local reg and wire
    reg clk, areset_n,rst_n;
    reg [7:0] data_in;
    reg tx_en, rx_en;
    reg rx;
    wire tx;
    wire [7:0] data_out;
    wire tx_busy, tx_done, rx_busy, rx_done, rx_error;
    
//2- Instantiate the module under test
    UART uart_instance (
    .clk(clk),
    .areset_n(areset_n),
    .rst_n(rst_n),
    
    // TX Interface
    .data_in(data_in),
    .tx_en(tx_en),
    .tx_busy(tx_busy),
    .tx_done(tx_done),
    .tx(tx),
    
    // RX Interface
    .rx_en(rx_en),
    .rx(rx),
    .data_out(data_out),
    .rx_busy(rx_busy),
    .rx_done(rx_done),
    .rx_error(rx_error)
);

 //3- General stimuli using always and initial
 localparam T = 20;
 always begin
    clk = 1'b0; #(T / 2);
    clk = 1'b1; #(T / 2);
 end
    
    // Task to send one UART byte
    task send_uart_byte;
        input [7:0] data;
        integer i;
        begin
            // Start bit (0)
            rx = 1'b0;
            #104166; // 1/9600 ≈ 104.166us per bit
            
            // Data bits (LSB first)
            for (i = 0; i < 8; i = i + 1) begin
                rx = data[i];
                #104166;
            end
            
            // Stop bit (1)
            rx = 1'b1;
            #104166;
        end
    endtask
    
    task write_data;
    input [7:0] data; 
    input txen;
    begin
        tx_en = txen;
        data_in = data;
    end
 endtask
 
    
    initial begin
     // Initialize all inputs
        areset_n = 0;
        rst_n = 0;
        rx_en = 0;
        rx = 1'b1;
        write_data(8'b0,0);
        
     // Apply reset
        #100;
        areset_n = 1;
        #100;
        
    // Enable receiver
        rx_en = 1;
       
        // Test 1: Send 0x55 (01010101)
        #1000;
        $display("\nSending 0x55...");
        send_uart_byte(8'h55);       
        #20;
        rx_en = 0;
        #20;
        write_data(8'b01010101,1);
        #20 $stop;
    end

endmodule
