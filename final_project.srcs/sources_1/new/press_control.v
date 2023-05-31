`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/27 13:42:11
// Design Name: 
// Module Name: press_control
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

`define COLOR_I 12'h88f
`define COLOR_L1 12'h00f
`define COLOR_L2 12'hf80
`define COLOR_O 12'hff0
`define COLOR_Z1 12'h8f8
`define COLOR_Z2 12'hf00
`define COLOR_T 12'hf0f

module press_control(
	input [511:0] key_down,
	input [11:0] type,
	input [3:0] left_now,
	input [3:0] right_now,
    input key_valid,
    input clk1,
    input rst_n,
    output reg [1:0] left_block_move,
    output reg [1:0] right_block_move,
    output reg [1:0] left_rotate,
    output reg [1:0] right_rotate
    );
    
     
        reg [1:0] left_block_move_tmp;
        reg [1:0] right_block_move_tmp;
        reg [1:0] left_rotate_tmp;
        reg [1:0] right_rotate_tmp;
    
    
    always@*
    begin
        left_block_move_tmp=0;
        right_block_move_tmp=0;
        left_rotate_tmp=left_rotate;
        right_rotate_tmp=right_rotate;
        if(key_down[9'h 1D] == 1)  //左邊旋轉
        begin
            case (left_rotate)
            0:left_rotate_tmp=1;
            1:left_rotate_tmp=2;
            2:left_rotate_tmp=3;
            3:left_rotate_tmp=0;
            default: left_rotate_tmp=0;
            endcase
        end 
        else if(key_down[9'h 1C] == 1) //向左
        begin
            case (left_now)
            1:
            begin
                if(type == `COLOR_Z2) left_block_move_tmp=0;
                else left_block_move_tmp=1;
            end
            2: left_block_move_tmp=1;
            3: left_block_move_tmp=1;
            4: left_block_move_tmp=1;
            5: left_block_move_tmp=1;
            6: left_block_move_tmp=1;
            7: left_block_move_tmp=1;
            8: left_block_move_tmp=1;
            default: left_block_move_tmp=0;
            endcase
        end
        else if(key_down[9'h 1B] == 1) //向下
        begin
        end
        else if(key_down[9'h 23] == 1) //向右
        begin            
            case (left_now)
            0: left_block_move_tmp=2;
            1: left_block_move_tmp=2;
            2: left_block_move_tmp=2;
            3: left_block_move_tmp=2;
            4: left_block_move_tmp=2;
            5: left_block_move_tmp=2;
            6: 
            begin
                if(type == `COLOR_I) left_block_move_tmp=0;
                else left_block_move_tmp=2;
            end
            7: 
            begin
                if(type == `COLOR_O || type == `COLOR_Z2 ) left_block_move_tmp=2;
                else left_block_move_tmp=0;
            end
            default: left_block_move_tmp=0;
            endcase
        end
        if(key_down[9'h 1_75] == 1) //右邊旋轉
        begin
            case (right_rotate)
            0:right_rotate_tmp=right_rotate+1;
            1:right_rotate_tmp=right_rotate+1;
            2:right_rotate_tmp=right_rotate+1;
            3:right_rotate_tmp=0;
            default: right_rotate_tmp=0;
            endcase
        end        
        else if(key_down[9'h 1_6B] == 1) //向左
        begin
            case (right_now)
                1: 
                begin
                    if(type == `COLOR_Z2) right_block_move_tmp=0;
                    else right_block_move_tmp=1;
                end
                2: right_block_move_tmp=1;
                3: right_block_move_tmp=1;
                4: right_block_move_tmp=1;
                5: right_block_move_tmp=1;
                6: right_block_move_tmp=1;
                7: right_block_move_tmp=1;
                8: right_block_move_tmp=1;
                default: right_block_move_tmp=3;
                endcase
        end           
        else if(key_down[9'h 1_72] == 1) //向下
        begin
        end           
        else if(key_down[9'h 1_74] == 1) //向右
        begin
            case (right_now)
                0: right_block_move_tmp=2;
                1: right_block_move_tmp=2;
                2: right_block_move_tmp=2;
                3: right_block_move_tmp=2;
                4: right_block_move_tmp=2;
                5: right_block_move_tmp=2;
                6: 
                begin
                    if(type == `COLOR_I) right_block_move_tmp=0;
                    else right_block_move_tmp=2;
                end
                7: right_block_move_tmp=2;
                /*8:
                begin
                    if(type == `COLOR_O) right_block_move_tmp=0;
                    else if(type == `COLOR_I) right_block_move_tmp=2;
                end*/
                default: right_block_move_tmp=0;
                endcase
        end       
    end
    
    always@(posedge clk1 or negedge rst_n)
    if(~rst_n)
    begin
        left_block_move<=0;
        right_block_move<=0;
        left_rotate<=0;
        right_rotate<=0;
    end
    else
    begin
        left_block_move<=left_block_move_tmp;
        right_block_move<=right_block_move_tmp;
        left_rotate<=left_rotate_tmp;
        right_rotate<=right_rotate_tmp;
    end

    
endmodule
