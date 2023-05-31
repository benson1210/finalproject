`define I  1
`define L1 2
`define L2 3
`define O  4
`define Z1 5
`define Z2 6
`define T  7
`define COLOR_I 12'h88f
`define COLOR_L1 12'h00f
`define COLOR_L2 12'hf80
`define COLOR_O 12'hff0
`define COLOR_Z1 12'h8f8
`define COLOR_Z2 12'hf00
`define COLOR_T 12'hf0f

module tetris_update (
    input clk,
    input clk_1,
    input clk_10,
    input rst_n,
    input isReach,
    input clear,
    input [1:0] left_block_move,
    input [1:0] right_block_move,
    output reg [8:0] current_pos,
    output reg [8:0] last_pos,
    output reg [11:0] color,
    output reg [11:0] last_color,
    output reg [4:0] count
); 

reg [8:0] current_pos_w, last_pos_w;
wire [2:0] new_type;
reg [11:0] color_w;
reg [4:0] count_tmp;

LFSR U_random (
    .clk(isReach),
    .rst_n(rst_n),
    .q(new_type)
);

always @(posedge clk_1, negedge rst_n) 
begin
    if (~rst_n)
    begin
        color <= `COLOR_I;
        last_color <= `COLOR_I;
    end  
    else if (isReach && ~clear)
    begin
        color <= color_w;
        last_color <= color_w;
    end
    else
    begin
        color <= color;
        last_color <= color;
    end
          
end

always @(*) 
begin
    color_w = color;

    case (new_type)
        `I: color_w = `COLOR_I;
        `L1: color_w = `COLOR_L1;
        `L2: color_w = `COLOR_L2;
        `O: color_w = `COLOR_O;
        `Z1: color_w = `COLOR_Z1;
        `Z2: color_w = `COLOR_Z2;
        `T:  color_w = `COLOR_T;
    endcase
end

always @(posedge clk_1, negedge rst_n) 
begin
    if (~rst_n)
    begin
        current_pos <= 9'd4;
        last_pos <= 9'd4;
    end    
    else
    begin
        current_pos <= current_pos_w;
        last_pos <= last_pos_w;
    end
end

always @(*) 
begin
    last_pos_w = current_pos;
    if(count == 0)
    begin
        if(left_block_move == 1) current_pos_w = current_pos+9;
        else if(left_block_move == 2) current_pos_w = current_pos+11;
        else current_pos_w = current_pos+10;
    end
    else 
    begin
        if(left_block_move == 1) current_pos_w = current_pos-1;
        else if(left_block_move == 2) current_pos_w = current_pos+1;
        else current_pos_w = current_pos;
    end
    if (isReach || clear)
    begin
        current_pos_w = 4;
        last_pos_w = 4;
    end 
end

always@*
begin
    if(count == 5'd 9) count_tmp=5'b 0;
    else count_tmp=count+1;
end
    
always@(posedge clk_10 or negedge rst_n)   
begin
    if(~rst_n)
    begin
        count<=5'd 0;
    end
    else
    begin
        count<=count_tmp;
    end
end 
endmodule