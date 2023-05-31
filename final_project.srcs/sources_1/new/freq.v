`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/05 15:08:09
// Design Name: 
// Module Name: freq
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
//////////////////////////////////////////////////////////////////////////////////`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/08 13:42:41
// Design Name: 
// Module Name: freqdiv
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


module freq(
    output reg clk_out,
    output reg [1:0] ctl,
    input clk,
    input rst
    );
        
reg [25:0] q,tmp;
//for 1hz
     always@*
     begin
         if(q==26'd 5000000) tmp=26'd 0;
         else tmp=q+1'b 1;
     end
     
     always@(posedge clk or posedge rst)
     begin
     if(rst) 
     begin
         q<=26'd 0;
         clk_out<=1'b 0;
     end
     else 
     begin
         q<=tmp;
         ctl<=q[16:15];
         if(q==26'd 5000000) clk_out=~clk_out;
         else clk_out=clk_out;
     end 
     end
            


endmodule