module clock_divisor(
        input clk,
        input rst_n,
        output clk_1,
        output clk_25M
);

parameter HALF_PERIOD = (100_000_000 / 2) - 1;
wire tick;
reg [26:0] q_reg, q_next; // 50M counter
reg t_reg, t_next;
reg [1:0] vgaclk;

always @(posedge clk) 
begin
    if (~rst_n)
    begin
        q_reg <= 27'b0;
        t_reg <= 1'b1;
        vgaclk <= 0;
    end
    else
    begin
        q_reg <= q_next;    
        t_reg <= t_next;
        vgaclk <= vgaclk + 1;
    end
end

// next state logic
always @(*) 
begin
    q_next = tick? 27'b0: (q_reg + 27'b1);
    t_next = tick ^ t_reg;    
end

// output logic
assign tick = (q_reg == HALF_PERIOD);
assign clk_1 = t_reg;
assign clk_25M = vgaclk[1];

endmodule

