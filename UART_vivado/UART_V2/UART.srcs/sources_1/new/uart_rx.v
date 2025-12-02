`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2025 03:24:24 PM
// Design Name: 
// Module Name: uart_rx
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


module uart_rx(
    input clk, reset_n,
    input s_tick, rx,
    output reg rx_done_tick,
    output [7:0] rx_out
    );
    
    localparam idle = 0, start = 1,
               data = 2, stop = 3;
    
    reg [1:0] state_reg , state_next;
    reg [3:0] s_reg, s_next; // keep track of the baud rate ticks
    reg [2:0] n_reg, n_next; // keep track of the number of data bits recieved
    reg [7:0] b_reg, b_next; // stores the recieved data bits
    
    // state logic
    always @(posedge clk or negedge reset_n)
    begin
        if(!reset_n) begin
            state_reg <= 0;
            s_reg <= 0;
            n_reg <= 0;
            b_reg <= 0;
        end
        else begin
            state_reg <= state_next;
            s_reg <= s_next;
            n_reg <= n_next;
            b_reg <= b_next;
        end
    end
   
   // next state logic
   always @(*)
   begin
       state_next = state_reg;
       s_next = s_reg;
       n_next = n_reg;
       b_next = b_reg;
       rx_done_tick = 0;
       case(state_reg)
            idle:
                if(!rx) begin
                    s_next = 0;
                    state_next = start;
                end
            start:
                 if(s_tick) begin
                    if(s_reg == 7) begin
                        s_next = 0;
                        n_next = 0;
                        state_next = data;
                    end
                    else begin
                        s_next = s_reg + 1;
                    end
                 end
            data:
                if(s_tick) begin
                    if(s_reg == 15) begin
                        s_next = 0;
                        b_next = {rx,b_reg[7:1]};
                        if(n_reg == 7) begin
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
            stop:
                if(s_tick) begin
                    if(s_reg == (15)) begin
                        rx_done_tick = 1;
                        state_next = idle;
                    end
                    else begin
                        s_next = s_reg + 1;
                    end
                end
            default:
                state_next = idle;                  
       endcase
   end
   
   //output logic
   assign rx_out = b_reg;   
   
endmodule
