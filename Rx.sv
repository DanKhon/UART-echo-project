`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2026 11:49:18 PM
// Design Name: 
// Module Name: Rx
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


//Make a light switching circuit, so that for every data_valid bit, a light turns off or on


module Rx(
input RsRX, input clk, output reg [7:0] data, output logic data_valid);
    

    
typedef enum logic[1:0]{
    IDLE,
    START,
    RECEIVING,
    STOP

} states;

states current_state, next_state;


//this is for 9600 baud

localparam [15:0] IDLE_TO_START_WAIT_VALUE=5208;
reg [15:0] CURRENT_START_BIT;


localparam [16:0] RECEIVING_BIT_WAIT_VALUE=10417;
reg[16:0] RECEIVING_BIT_COUNT;
reg[2:0] BITS_COUNTED;


localparam [16:0] STOP_COUNT_WAIT_VALUE=10417;
reg[16:0] STOP_COUNT;

logic first_cycle = 1'b1;

always @(posedge clk) begin
    
    //For initializing variables
    if(first_cycle)
        begin
        
            current_state <= IDLE;
            
            CURRENT_START_BIT<=0;
            
            RECEIVING_BIT_COUNT <= 0;
            BITS_COUNTED<=0;

            STOP_COUNT<=0;
           
           
           first_cycle <= 0; 
           
           data_valid <=0;
        end
    
    if(data_valid == 1)
        data_valid <=0;
    
    case(current_state)
    
        IDLE: //When IDLE, we check if there is a 0 bit.
            begin
                if(RsRX == 0) 
                    
                    
                        current_state <= START;
                        //Make an LED ON if IDLE and OFF when not IDLE
              
                
             end
           
            
            
        
        START:
            begin
                                   
                // Logic for moving onto RECEIVING
                if(IDLE_TO_START_WAIT_VALUE == CURRENT_START_BIT)
                    begin
                        current_state <= RECEIVING;
                        CURRENT_START_BIT <=0;
                    end
                    
                else 
                    CURRENT_START_BIT<=CURRENT_START_BIT+1;
                   
            end
            
        RECEIVING:
            
            begin
            
            if(RECEIVING_BIT_COUNT == RECEIVING_BIT_WAIT_VALUE)
                begin
                
                    data[BITS_COUNTED] <= RsRX; //Assigning the data value

                        
                    if(BITS_COUNTED == 7)
                        begin
                            
                        
                            BITS_COUNTED <= 0;
                            current_state <= STOP;
                        end
                    else
                        BITS_COUNTED<=BITS_COUNTED+1;
                    
                    
                    RECEIVING_BIT_COUNT <= 0;
                        
                    
                    
                    end
                
                else 
                    RECEIVING_BIT_COUNT<=RECEIVING_BIT_COUNT+1; 
                
            end
            
        STOP:
            begin
                if(STOP_COUNT == STOP_COUNT_WAIT_VALUE)
                    begin
                        data_valid <= 1;
                        current_state <= IDLE;
                        STOP_COUNT <=0;
                    end
                else
                    STOP_COUNT<=STOP_COUNT+1;
            end
        
        
    endcase
            
end



endmodule


