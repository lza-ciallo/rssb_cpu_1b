`timescale 1ns/1ps

module tb_cpu;

logic   clk, clk1, clk2, rst, ena;
logic   data[1:0];
logic   flag, result;

always_comb begin
    data[1] = result;
end

cpu u_cpu (
    .clk1   (clk1   ),
    .clk2   (clk2   ),
    .rst    (rst    ),
    .ena    (ena    ),
    .data   (data   ),
    .flag   (flag   ),
    .result (result )
);

logic   [1:0]   count;

initial begin
    clk     =   0;
    count   =   0;
    clk1    =   0;
    clk2    =   0;
    ena     =   0;
    rst     =   1;
    forever #5 clk = ~clk;
end

always_ff @( clk ) begin
    count   <=  count + 1;
    clk1    <=  (count == 1)? 1 : 0;
    clk2    <=  (count == 3)? 1 : 0;
end

initial begin
    @(negedge clk1) rst = 0;
    @(negedge clk1) rst = 1; ena = 1; data[0] = 1;
    @(negedge clk1) data[0] = 0;
    @(negedge clk1) data[0] = 0;
    @(negedge clk1) data[0] = 1;
    @(negedge clk1) $finish(0);
end

endmodule