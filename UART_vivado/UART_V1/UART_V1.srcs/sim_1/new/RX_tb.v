`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/22/2025 09:39:03 PM
// Design Name: 
// Module Name: RX_tb
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


module RX_tb(

    );
    
    //1- Declare local reg and wire
    reg clk_tb;
    reg areset_tb;
    reg rst_tb;
    reg rxen_tb;
    reg rx_tb;
    
    wire  [7:0] data_tb;
    wire  done_tb;
    wire  busy_tb;
    wire  error_tb;
    
    //2- Instantiate the module under test
    RX uut(
        .clk(clk_tb),
        .reset_n(areset_tb),
        .rst_n(rst_tb),
        .rx_en(rxen_tb),
        .rx(rx_tb),
        
        .busy(busy_tb),
        .data_out(data_tb),
        .done(done_tb),
        .error(error_tb)
    );
    
    //3- General stimuli using always and initial
 localparam T = 20;
 always begin
    clk_tb = 1'b0; #(T / 2);
    clk_tb = 1'b1; #(T / 2);
 end
    
    // Task to send one UART byte
    task send_uart_byte;
        input [7:0] data;
        integer i;
        begin
            // Start bit (0)
            rx_tb = 1'b0;
            #104166; // 1/9600 ≈ 104.166us per bit
            
            // Data bits (LSB first)
            for (i = 0; i < 8; i = i + 1) begin
                rx_tb = data[i];
                #104166;
            end
            
            // Stop bit (1)
            rx_tb = 1'b1;
            #104166;
        end
    endtask
    
    initial begin
        // Initialize all inputs
        areset_tb = 0;
        rst_tb = 0;
        rxen_tb = 0;
        rx_tb = 1'b1; // Idle state is high
        
        $display("=== UART Receiver Testbench Started ===");
        $display("Time\t\tData\tBusy\tDone\tError");
        $display("----------------------------------------");
        
        // Apply reset
        #100;
        areset_tb = 1;
        #100;
        
        // Enable receiver
        rxen_tb = 1;
        $display("%0t\t\t-\t%b\t%b\t%b", $time, busy_tb, done_tb, error_tb);
        
        // Test 1: Send 0x55 (01010101)
        #1000;
        $display("\nSending 0x55...");
        send_uart_byte(8'h55);
        
        // Wait for reception to complete
        $display("%0t\t%h\t%b\t%b\t%b", $time, data_tb, busy_tb, done_tb, error_tb);
        #2000;
        send_uart_byte(8'h44);
        #1000;
        $stop;
    end
    

    
endmodule
