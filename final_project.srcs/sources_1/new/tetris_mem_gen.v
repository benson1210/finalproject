`define COLOR_I 12'h88f
`define COLOR_L1 12'h00f
`define COLOR_L2 12'hf80
`define COLOR_O 12'hff0
`define COLOR_Z1 12'h8f8
`define COLOR_Z2 12'hf00
`define COLOR_T 12'hf0f
`define GREY 12'h666

module tetris_mem_gen (
    input clk,
    input clk_1,
    input rst_n,
    input we,
    input [8:0] addr_w, addr_e, addr_r, //write, erase, read
    input [11:0] din, din_e,
    input [1:0] left_rotate,
    output reg [11:0] dout,
    output isReach,
    output reg clear
);

reg [11:0] memory[0:210];
reg [8:0] addr_w1, addr_w2, addr_w3, addr_e1, addr_e2, addr_e3;
integer k;
reg [11:0] din_modified; // ?Åø??? din ?ï∏?ºÈåØË™§Â?éËá¥Â•áÊ?™Á?ÑÁ?êÊ??

always @(*) 
begin
    din_modified = `COLOR_I;

    case (din)
        `COLOR_I: din_modified = `COLOR_I;
        `COLOR_L1: din_modified = `COLOR_L1;
        `COLOR_L2: din_modified = `COLOR_L2;
        `COLOR_O: din_modified = `COLOR_O;
        `COLOR_Z1: din_modified = `COLOR_Z1;
        `COLOR_Z2: din_modified = `COLOR_Z2;
        `COLOR_T: din_modified = `COLOR_T;
    endcase    
end

always @(posedge clk, negedge rst_n) 
begin
    if (~rst_n)
    begin
        memory[210] <= 12'h0;
        for (k = 0; k < 210; k = k + 1)
        begin
            memory[k] <= `GREY;
        end
    end  
    else if (clear)
    begin
        for (k = 0; k < 210; k = k + 1)
        begin
            memory[k] <= `GREY;
        end
    end
    else if (we)
    begin
        if (addr_e == addr_w)
            memory[addr_w] <= din_modified;
        else
        begin
            memory[addr_e] <= `GREY;
            memory[addr_w] <= din_modified;
        end
        if (addr_e1 == addr_w1)
            memory[addr_w1] <= din_modified;
        else
        begin
            memory[addr_e1] <= `GREY;
            memory[addr_w1] <= din_modified;
        end
        if (addr_e2 == addr_w2)
            memory[addr_w2] <= din_modified;
        else
        begin
            memory[addr_e2] <= `GREY;
            memory[addr_w2] <= din_modified;
        end
        if (addr_e3 == addr_w3)
            memory[addr_w3] <= din_modified;
        else
        begin
            memory[addr_e3] <= `GREY;
            memory[addr_w3] <= din_modified;
        end
    end 

    dout <= memory[addr_r]; 
end

always @(*) 
begin
    addr_w1 = addr_w;
    addr_w2 = addr_w;
    addr_w3 = addr_w;
    
    case (din)
        `COLOR_I:
        begin
            if(left_rotate == 0 || left_rotate == 2 )
            begin
                addr_w1 = addr_w + 1;
                addr_w2 = addr_w + 2;
                addr_w3 = addr_w + 3;
            end
            else if(left_rotate == 1 || left_rotate == 3 )
            begin
                addr_w1 = addr_w - 10;
                addr_w2 = addr_w + 10;
                addr_w3 = addr_w + 20;
            end
        end
        `COLOR_L1:
        begin
            if(left_rotate == 0)
            begin
                addr_w1 = addr_w + 1;
                addr_w2 = addr_w + 2;
                addr_w3 = addr_w - 10;
            end
            else if(left_rotate == 1)
            begin
                addr_w1 = addr_w - 9;
                addr_w2 = addr_w - 10;
                addr_w3 = addr_w + 10;
            end
            else if(left_rotate == 2)
            begin
                addr_w1 = addr_w + 1;
                addr_w2 = addr_w + 2;
                addr_w3 = addr_w + 12;
            end
            else
            begin
                addr_w1 = addr_w + 10;
                addr_w2 = addr_w + 9;
                addr_w3 = addr_w - 10;
            end
        end
        `COLOR_L2:
        begin
            addr_w1 = addr_w + 1;
            addr_w2 = addr_w + 2;
            addr_w3 = addr_w - 8;
        end
        `COLOR_O:
        begin
            addr_w1 = addr_w + 1;
            addr_w2 = addr_w - 9;
            addr_w3 = addr_w - 10;
        end
        `COLOR_Z1:
        begin
            addr_w1 = addr_w + 1;
            addr_w2 = addr_w - 9;
            addr_w3 = addr_w - 8;
        end
        `COLOR_Z2:
        begin
            addr_w1 = addr_w + 1;
            addr_w2 = addr_w - 11;
            addr_w3 = addr_w - 10;
        end
        `COLOR_T:  
        begin
            addr_w1 = addr_w + 1;
            addr_w2 = addr_w + 2;
            addr_w3 = addr_w - 9;
        end
        default: // for fear that din goes non-sense
        begin
            addr_w1 = addr_w + 1;
            addr_w2 = addr_w + 2;
            addr_w3 = addr_w + 3;
        end
    endcase
end

always @(*) 
begin
    addr_e1 = addr_e;
    addr_e2 = addr_e;
    addr_e3 = addr_e;

    case (din_e)
        `COLOR_I:
        begin
            if(left_rotate == 0 || left_rotate == 2 )
            begin
                addr_e1 = addr_e + 1;
                addr_e2 = addr_e + 2;
                addr_e3 = addr_e + 3;
            end
            else if(left_rotate == 1 || left_rotate == 3 )
            begin
                addr_e1 = addr_e - 10;
                addr_e2 = addr_e + 10;
                addr_e3 = addr_e + 20;
            end
        end
        `COLOR_L1:
        begin
            if(left_rotate == 0)
            begin
                addr_e1 = addr_e + 1;
                addr_e2 = addr_e + 2;
                addr_e3 = addr_e - 10;
            end
            else if(left_rotate == 1)
            begin
                addr_e1 = addr_e - 9;
                addr_e2 = addr_e - 10;
                addr_e3 = addr_e + 10;
            end
            else if(left_rotate == 2)
            begin
                addr_e1 = addr_e + 1;
                addr_e2 = addr_e + 2;
                addr_e3 = addr_e + 12;
            end
            else
            begin
                addr_e1 = addr_e + 10;
                addr_e2 = addr_e + 9;
                addr_e3 = addr_e - 10;
            end
        end
        `COLOR_L2:
        begin
            addr_e1 = addr_e + 1;
            addr_e2 = addr_e + 2;
            addr_e3 = addr_e - 8;
        end
        `COLOR_O:
        begin
            addr_e1 = addr_e + 1;
            addr_e2 = addr_e - 9;
            addr_e3 = addr_e - 10;
        end
        `COLOR_Z1:
        begin
            addr_e1 = addr_e + 1;
            addr_e2 = addr_e - 9;
            addr_e3 = addr_e - 8;
        end
        `COLOR_Z2:
        begin
            addr_e1 = addr_e + 1;
            addr_e2 = addr_e - 11;
            addr_e3 = addr_e - 10;
        end
        `COLOR_T:  
        begin
            addr_e1 = addr_e + 1;
            addr_e2 = addr_e + 2;
            addr_e3 = addr_e - 9;
        end
        default: // for fear that din goes non-sense
        begin
            addr_e1 = addr_e + 1;
            addr_e2 = addr_e + 2;
            addr_e3 = addr_e + 3;
        end
    endcase
end

reg [4:0] bottom[0:9], bottom_w[0:9];
wire [4:0] h_0, h_1, h_2, h_3, v_0, v_1, v_2, v_3;

always @(posedge clk_1, negedge rst_n)
begin
    if (~rst_n)
    begin
        for (k = 0; k < 10; k = k + 1)
        begin
            bottom[k] <= 21;
        end
    end
    else
    begin
        for (k = 0; k < 10; k = k + 1)
        begin
            bottom[k] <= bottom_w[k];
        end
    end
end

always @(*) 
begin
    for (k = 0; k < 10; k = k + 1)
        bottom_w[k] = bottom[k];

    if (clear)
    begin
        for (k = 0; k < 10; k = k + 1)
            bottom_w[k] = 21;
    end
    else if (isReach)
    begin
        bottom_w[h_0] = v_0;
        bottom_w[h_1] = v_1;
        bottom_w[h_2] = v_2;
        bottom_w[h_3] = v_3;
    end    
end

assign h_0 = addr_w % 10;
assign v_0 = addr_w / 10;
assign h_1 = addr_w1 % 10;
assign v_1 = addr_w1 / 10;
assign h_2 = addr_w2 % 10;
assign v_2 = addr_w2 / 10;
assign h_3 = addr_w3 % 10;
assign v_3 = addr_w3 / 10;

assign isReach = (v_0 + 1 >= bottom[h_0]) || (v_1 + 1 >= bottom[h_1]) || (v_2 + 1 >= bottom[h_2]) || (v_3 + 1 >= bottom[h_3]);

always @(*) 
begin
    clear = 1'b0;

    for (k = 0; k < 10; k = k + 1)
    begin
        if (bottom[k] <= 1)
        begin
            clear = 1'b1;
        end
    end       
end
    
endmodule