module top (
    input clk,
    input rst_n,
    input stop,
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue,
    output hsync,
    output vsync,
    output wire [1:0] left_rotate,
    output [3:0] a,
    inout PS2_DATA,
    inout PS2_CLK
);

wire [11:0] pixel;
wire valid, isReach, clear;
wire [11:0] data, last_data;
wire [9:0] h_cnt, v_cnt;
wire [8:0] grid_addr, last_pos, current_pos;
wire clk_1, clk_25M;

///////////////////////////////////////////////////新增定義

    wire [511:0] key_down;
    wire [8:0] last_change;
    wire key_valid;
    wire [1:0] left_block_move;
    wire [1:0] right_block_move;
    //wire [1:0] left_rotate;
    wire [1:0] right_rotate;
    wire debounce,pulse;
    wire clk_10;
    wire [1:0] ctl;

///////////////////////////////////////////////////新增定義    
    
assign {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel: 12'h0;

clock_divisor clk_div (
    .clk(clk),
    .rst_n(rst_n),
    .clk_1(clk_1),
    .clk_25M(clk_25M)
);

vga_controller vga_inst(
    .pclk(clk_25M),
    .reset(~rst_n),
    .hsync(hsync),
    .vsync(vsync),
    .valid(valid),
    .h_cnt(h_cnt),
    .v_cnt(v_cnt)
);

mem_addr_gen mag (
    .h_cnt(h_cnt),
    .v_cnt(v_cnt),
    .grid_addr(grid_addr)
);

tetris_mem_gen tetris_mem_gen_inst (
    .clk(clk_25M),
    .clk_1(clk_1), //有修
    .rst_n(rst_n),
    .we(1),
    .addr_w(current_pos + 10),
    .addr_e(last_pos + 10),
    .addr_r(grid_addr + 10),
    .din(data[11:0]),
    .din_e(last_data[11:0]),
    .dout(pixel),
    .isReach(isReach),
    .clear(clear)
);

tetris_update tetris_update_inst (
    .clk(clk),
    .clk_1(clk_1),
    .clk_10(clk_10),
    .rst_n(rst_n),
    .isReach(isReach),
    .clear(clear),
    .left_block_move(left_block_move),          ///本次新增
    .right_block_move(right_block_move),        ///本次新增
    .current_pos(current_pos),
    .last_pos(last_pos),
    .color(data[11:0]),
    .last_color(last_data[11:0])
);



/////////////////////////////////////////////////////////////////////////////////////// 以下是新增的部分

assign a=current_pos%10;


    KeyboardDecoder U0(
        .key_down(key_down),
        .last_change(last_change),
        .key_valid(key_valid),
        .PS2_DATA(PS2_DATA),
        .PS2_CLK(PS2_CLK),
        .rst(~rst_n),
        .clk(clk)
        );    
        
    press_control(
        .key_down(key_down),
        .type(data[11:0]),
        .key_valid(key_valid),
        .left_now(a),
        .right_now(a),
        .clk1(clk),
        .rst_n(rst_n),
        .left_block_move(left_block_move),
        .right_block_move(right_block_move),
        .left_rotate(left_rotate),
        .right_rotate(right_rotate)
        );
        
    onepulse(
        .onepulse(pulse),
        .clk(clk),
        .rst(rst_n),
        .debounce(debounce)
        );
        
    debounce(            
        .debounce(debounce),
        .clk(clk),
        .rst(rst_n),
        .bottom(stop)
        );
        
        
    freq(
        .clk_out(clk_10),
        .ctl(ctl),
        .clk(clk),
        .rst(rst_n)
        );
    
endmodule