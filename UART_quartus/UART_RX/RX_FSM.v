`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2025 02:36:08 PM
// Design Name: 
// Module Name: RX_FSM
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


module RX_FSM(
    input clk,
    input areset_n,rst_n,
    input rx_en,
    input baud_tick,
    input rx,
    
    output reg [7:0] data_out,
    output reg done,
    output reg busy,
    output reg baud_en,
    output reg error
    );
    
    localparam idle = 0, start = 1,
               data = 2, stop = 3;
               
    reg [1:0] current_state,next_state; // keep track of the state
    reg [3:0] s_reg, s_next; // keep track of the sampling
    reg [2:0] nbit_reg, nbit_next;
    reg [7:0] data_reg, data_next;
    
    
    //reg PISO_en; // enable for parallel input serial output register 
    
    // Falling edge detector
    reg rx_delay;
    wire start_detect;
    always @(posedge clk or negedge areset_n)
    begin
    if(!areset_n) 
        rx_delay <= 1'b1;
    else if(rst_n) 
        rx_delay <= 1'b1;
    else
         rx_delay <= rx;    
    end
    
    assign start_detect = rx_delay && !rx ;
    
    //FSM for RX
    
    //Sequential logic
    always @(posedge clk)
    begin
        if(!areset_n) begin
            current_state <= idle;  
            s_reg <= 4'b0;    
            nbit_reg <= 3'b0;
            data_reg <= 8'b0;
            data_out <= 8'b0;
            busy <= 0;
            baud_en <= 0;
        end
        else if(rst_n) begin
            current_state <= idle;  
            s_reg <= 4'b0;    
            nbit_reg <= 3'b0;
            data_reg <= 8'b0;
            data_out <= 8'b0;
            busy <= 0;
            baud_en <= 0;
        end
        else begin
            current_state <= next_state;
            s_reg <= s_next;
            nbit_reg <= nbit_next;
            data_reg <= data_next;    
            
            busy <= (current_state != idle);
            baud_en <= (current_state != idle);
            
            if (done)
                data_out <= data_reg;
        end
    end
    
    //Next state logic
    always @(*)
    begin
        next_state = current_state ;
        s_next = s_reg;    
        nbit_next = nbit_reg;
        data_next = data_reg; 
        done = 1'b0;
        error = 1'b0;
        
        case(current_state) 
            idle: begin
                s_next = 4'b0;
                nbit_next = 3'b0;
                if(start_detect && rx_en) begin 
                    next_state = start;         
                end              
            end
            
            start: begin
                if(baud_tick) begin  
                    if(s_reg == 7) begin
                        if(rx == 0)
									next_state = data;
                   end
                   else 
                      s_next = s_reg + 1; 
                end  
            end
            
            data: begin
                if(baud_tick) begin
                    if(s_reg == 15) begin 
                        data_next[nbit_reg] = rx;
                        s_next = 4'b0;
                        if(nbit_reg == 7) begin
                            next_state = stop;
                            nbit_next = 0;
                        end
                        else
                            nbit_next = nbit_reg + 1;    
                    end 
                    else
                        s_next = s_reg + 1;           
                end
            end
            
            stop: begin
                if(baud_tick) begin
                    if(s_reg == 15) begin 
                        if(rx) begin 
                            done = 1'b1;
                            next_state = idle;
                            s_next = 0;
                            nbit_next = 0;
                        end
                        else begin
                            error = 1;
                            next_state = idle;
                        end    
                    end
                    else
                        s_next = s_reg + 1;    
                end
            end
            default: next_state = idle; 
        
        endcase
    end
    
endmodule
