module mem_addr_gen (
    input [9:0] h_cnt,
    input [9:0] v_cnt,
    output reg [8:0] grid_addr
);

parameter GRID = 15;
parameter LEFT = 250;
parameter TOP = 90;
integer k, h, v;


always @(*) 
begin
    grid_addr = 0;
    if ((h_cnt <= LEFT || h_cnt >  LEFT + 10 * GRID) || (v_cnt <= TOP || v_cnt > TOP + 20 * GRID))
        grid_addr = 200;
    else
    begin
        for (k = 0; k < 200; k = k + 1)
        begin
            h = k % 10;
            v = k / 10; 
            if ((h_cnt > LEFT + h * GRID && h_cnt <= LEFT + (h+1) * GRID) && (v_cnt > TOP + v * GRID && v_cnt <= TOP + (v+1) * GRID))
                grid_addr = k;
        end
    end
end
    
endmodule