`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/21/2026 01:12:15 PM
// Design Name: 
// Module Name: top1
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


module top1(
    input  logic clk,
    input  logic RsRx,

    output logic [6:0] seg,
    output logic [3:0] an,
    output logic RsTx,
    output logic [15:0] led
);

    // Outputs from RX module
    logic [7:0] rx_data;
    logic       rx_data_valid;

    // Number 0-9 that we want to display
    logic [3:0] digit;


    // UART Receiver and Transmitter

    Rx receiver (
        .RsRX(RsRx),
        .clk(clk),
        .data(rx_data),
        .data_valid(rx_data_valid)
    );
    
    Tx transmitter (
    .clk(clk),
    .sent_data(rx_data),
    .rx_data_valid(rx_data_valid),
    .RsTx(RsTx),
    .led(led)
);

    // ---------------------------------------
    // Convert ASCII '0'-'9' into number 0-9
    // ---------------------------------------

    always_ff @(posedge clk) begin

        if(rx_data_valid) begin

            // Only accept ASCII digits
            if(rx_data >= 8'h30 && rx_data <= 8'h39)
                digit <= rx_data - 8'h30;

        end

    end


    always_comb begin
        an = 4'b1110;
    end


    // Seven-segment decoder

    always_comb begin

        case(digit)

            4'd0: seg = 7'b1000000;
            4'd1: seg = 7'b1111001;
            4'd2: seg = 7'b0100100;
            4'd3: seg = 7'b0110000;
            4'd4: seg = 7'b0011001;
            4'd5: seg = 7'b0010010;
            4'd6: seg = 7'b0000010;
            4'd7: seg = 7'b1111000;
            4'd8: seg = 7'b0000000;
            4'd9: seg = 7'b0010000;

            default: seg = 7'b1111111;

        endcase

    end

endmodule
