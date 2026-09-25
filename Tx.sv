`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2026 11:49:49 PM
// Design Name: 
// Module Name: Tx
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
//RsRX gets data from the PC 
//RsTx sends data to the PC  


//structure: startbit (0) DATA endbit(1)
module Tx(input clk, input [7:0] sent_data, input logic rx_data_valid, output logic RsTx, output logic[15:0] led);
    typedef enum logic [1:0]{
        IDLE,
        SENDING
    } states;
    
    states current_state;
    
    
    localparam [16:0] SENDING_BIT_WAIT_VALUE = 10416;
    reg [16:0] SENDING_BIT_COUNT;
    reg[3:0] CURRENT_BIT;//Will send 10 bits
    
    
    logic [1:0] first_cycle = 1;
    
    
    logic [7:0] data;
    
    
   
    
    always @(posedge clk) 
    
    begin
    
        if(first_cycle == 1)
        begin
        
            first_cycle<=0;
            SENDING_BIT_COUNT <=0;
            CURRENT_BIT <= 0;
            current_state <=IDLE;
            RsTx <=1;
            led[15] <=1;
        end
        
        case(current_state)
        
        IDLE:
            begin
                RsTx<=1;
                if(rx_data_valid)
                
                begin
                    current_state <= SENDING;
                    data <= sent_data;
                    
                    led[15] <= ~led[15];
                    
                end
                
            end
        
        
        SENDING:
            begin
            
                if(SENDING_BIT_COUNT == SENDING_BIT_WAIT_VALUE)
                begin
                
                    case(CURRENT_BIT)
                    
                    0://Send the start bit
                    begin
                        RsTx<=0;
                        CURRENT_BIT<=CURRENT_BIT+1;

                    end
                    
                    9:
                    begin//Stop bit
                        RsTx<=1;
                        CURRENT_BIT<=0;
                        current_state <=IDLE;
                    end
                    
                    default//This is for all other bits
                    begin
                    
                        RsTx <= data[CURRENT_BIT-1];//This should be bits 1-8
                        CURRENT_BIT<=CURRENT_BIT+1;

                    end
                        
                    endcase
                    SENDING_BIT_COUNT <= 0;
                end

                else
                begin
                    SENDING_BIT_COUNT <= SENDING_BIT_COUNT+1;
                end

            end
        
        
        
        
    endcase

    end


endmodule
