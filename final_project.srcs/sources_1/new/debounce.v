/*`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/08 14:21:21
// Design Name: 
// Module Name: debounce
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


module debounce(
    output reg pb_de,
    input clk,
    input rst_n,
    input pb_in
    );
    reg [3:0] debounce_window;
    reg pb_de_tmp;
    
    always@(posedge clk or negedge rst_n)
    if(~rst_n)
        debounce_window <= 4'b0000;
    else
        debounce_window = {debounce_window[2],debounce_window[1],debounce_window[0],pb_in};
        
    always@*
        pb_de_tmp = debounce_window[3] & debounce_window[2] & debounce_window[1] & debounce_window[0];
        
    always@(posedge clk or negedge rst_n)
    if(~rst_n)
        pb_de <= 1'b0;
    else
        pb_de <= pb_de_tmp;
        
endmodule*/


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/22 20:34:36
// Design Name: 
// Module Name: lab5_1_4
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


module debounce(            
    output reg debounce,
    input clk,
    input rst,
    input bottom
    );
    reg[3:0] debounce_tmp;
    
    always@(posedge clk or negedge rst)
    begin
        if(~rst) 
            begin
                debounce_tmp<=4'b 0;
                debounce<=1'b 0;
            end
        else
            begin 
                debounce_tmp<={bottom,debounce_tmp[3:1]};
                
                if(debounce_tmp == 4'b 1111) debounce<=1'b 1;
                else debounce<=1'b 0;
            end
    end
    
    
    
endmodule
