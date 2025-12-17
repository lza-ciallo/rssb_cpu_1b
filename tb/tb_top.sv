`timescale 1ns/1ps

module tb_top;

logic   clk, clk0, clk1, clk2, rst;
logic   result;

top u_top (
    .clk0   (clk0   ),
    .clk1   (clk1   ),
    .clk2   (clk2   ),
    .rst    (rst    ),
    .result (result )
);

logic   [2:0]   count;

initial begin
    clk     =   0;
    count   =   0;
    clk0    =   0;
    clk1    =   0;
    clk2    =   0;
    rst     =   1;
    forever #5 clk = ~clk;
end

always_ff @( clk ) begin
    count   <=  count + 1;
    clk0    <=  (count == 2)? 1 : 0;
    clk1    <=  (count == 4)? 1 : 0;
    clk2    <=  (count == 6)? 1 : 0;
end

logic token = 0;

initial begin
    @(negedge clk1) rst = 0;
    @(negedge clk1) rst = 1;
    while(~(u_top.u_cpu.data[0] & u_top.u_cpu.data[1] & token)) begin
        @(negedge clk1);
        if (u_top.u_cpu.data[0] & u_top.u_cpu.data[1]) begin
            token = 1;
            @(negedge clk1);
        end
    end
    @(negedge clk1);
    if      (u_top.u_mem.dmem[2] == 1 && u_top.u_mem.dmem[3] == 0 && u_top.u_mem.dmem[4] == 0) $display("Mem[1] < Mem[0]");
    else if (u_top.u_mem.dmem[2] == 0 && u_top.u_mem.dmem[3] == 1 && u_top.u_mem.dmem[4] == 0) $display("Mem[1] = Mem[0]");
    else if (u_top.u_mem.dmem[2] == 0 && u_top.u_mem.dmem[3] == 0 && u_top.u_mem.dmem[4] == 1) $display("Mem[1] > Mem[0]");
    else $display("Error!");
    $finish(0);
end

endmodule