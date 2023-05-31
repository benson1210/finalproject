`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/08 15:54:57
// Design Name: 
// Module Name: pulse
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


module onepulse(
    output reg onepulse,
    input clk,
    input rst,
    input debounce
    );
    
     reg debounce_delay,onepulse_next;
           
           always@*
           onepulse_next = debounce & ~debounce_delay;
           
           always@(posedge clk or negedge rst)
           begin
               if(~rst)
               begin
                   onepulse<=1'b 0;
                   debounce_delay<= 1'b 0;
               end
               else
               begin
                   onepulse<=onepulse_next;
                   debounce_delay<=debounce;
               end
           end
    
endmodule
