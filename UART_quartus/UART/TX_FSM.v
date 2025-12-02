`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2025 02:32:26 PM
// Design Name: 
// Module Name: TX_FSM
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


module TX_FSM(
    input clk,
    input areset_n,rst_n,
    input [7:0] data_in,
    input tx_en,
    input baud_tick,
    output reg busy,
    output reg done,
    output tx 
    );
    
    localparam idle = 0, start = 1,
               data = 2, stop = 3;
               
    reg [1:0] current_state, next_state;
    reg [2:0] nbit_reg,nbit_next;
    reg tx_reg,tx_next;
    
    //Sequential logic                         
    always @(posedge clk or negedge areset_n)
    begin
        if(!areset_n) begin
            current_state <= idle;
            tx_reg <= 1'b1;
            nbit_reg <= 3'b0;
        end
        else if(rst_n) begin
            current_state <= idle;
            tx_reg <= 1'b1;
            nbit_reg <= 3'b0;
        end
        else begin
            current_state <= next_state;  
            tx_reg <= tx_next;
            nbit_reg <= nbit_next;
        end          
    end

    //next state logic
    always @(*)
    begin
        next_state = current_state;
        tx_next = tx_reg;
        nbit_next = nbit_reg;
        done = 0;
        busy = 0;
        case(current_state)
            idle : begin
                tx_next = 1'b1;
                nbit_next = 3'b0;
                if(tx_en) begin
                    next_state = start;  
                    busy = 1;
                end    
                else
                    next_state = idle;   
            end 
            start : begin
                tx_next = 1'b0; //start bit 
                busy = 1;
                if(baud_tick) begin                   
                    next_state = data;  
                end                 
                else
                 next_state = start;
            end
            data: begin
                tx_next = data_in[nbit_reg];
                busy = 1'b1;
                if(baud_tick) begin                
                    if(nbit_reg == 7) 
                        next_state = stop;
                    else
                        nbit_next = nbit_reg + 1;             
                end     
            end  
            stop: begin
                tx_next = 1'b1;
                busy = 1;
                if(baud_tick) begin
                    next_state = idle;
                    done = 1;
                    busy = 0;  
                end 
                else begin
                    next_state = stop;
                    done = 0;
                end                           
            end        
            default: begin
                next_state = idle; 
             end   
        endcase
    end
  
  //output logic
  assign tx = tx_reg;
  
endmodule
