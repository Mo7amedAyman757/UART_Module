`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2025 04:28:34 PM
// Design Name: 
// Module Name: uart_tx
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


module uart_tx(
    input clk,reset_n,
    input tx_start, s_tick,
    input [7:0] tx_din,
    output reg tx_done_tick,
    output tx
    );
    
    localparam idle = 0, start = 1,
               data = 2, stop = 3;
    
    reg [1:0] state_reg , state_next;
    reg [3:0] s_reg, s_next; // keep track of the baud rate ticks
    reg [2:0] n_reg, n_next; // keep track of the number of data bits recieved
    reg [7:0] b_reg, b_next; // shift the data bits
    reg tx_reg, tx_next; // keep track of the transmitted data
    
    // state logic
    always @(posedge clk or negedge reset_n)
    begin
        if(!reset_n) begin
            state_reg <= 0; 
            s_reg <= 0;
            n_reg <= 0;
            b_reg <= 0;
            tx_reg <= 1'b1;
        end
        else begin
            state_reg <= state_next;
            s_reg <= s_next;
            n_reg <= n_next;
            b_reg <= b_next;
            tx_reg <= tx_next;
        end
    end
    
     always @(*)
   begin
       state_next = state_reg;
       s_next = s_reg;
       n_next = n_reg;
       b_next = b_reg;
       tx_next = tx_reg;
       tx_done_tick = 1'b0;
       case(state_reg)
            idle:
                if (tx_start) begin
                    s_next = 0;
                    b_next = tx_din; 
                    state_next = start;   
                end
            start:
            begin
                tx_next = 1'b0;
                if (s_tick) begin 
                    if (s_reg == 15) begin
                        s_next = 0; 
                        n_next = 0;
                        state_next = data;    
                    end
                    else begin
                         s_next = s_reg + 1; 
                    end
                end
            end    
            data:
            begin
                tx_next = b_reg[0];
                if (s_tick) begin
                    if (s_reg == 15) begin
                        s_next = 0;
                        b_next = {1'b0,b_reg[7:1]};
                        if (n_reg == 7) begin
                            state_next = stop;     
                        end 
                        else begin
                            n_next = n_reg + 1;
                        end
                    end
                    else begin
                        s_next = s_reg + 1; 
                    end
                end
            end
            stop: 
            begin
                tx_next = 1'b1;
                if (s_tick) begin 
                    if (s_reg == 15) begin
                        tx_done_tick = 1'b1;
                        state_next = idle;
                    end 
                    else begin
                        s_next = s_reg + 1; 
                    end
                end
            end
            default: 
                state_next = idle;        
       endcase
    end
    
    //output case
    assign tx = tx_reg;
    
endmodule
