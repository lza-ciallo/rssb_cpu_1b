module top #(
    BW  =   1   ,   // data width
    IW  =   4   ,   // imem pc width
    IM  =   16  ,   // imem capacity
    DW  =   4   ,   // dmem idx width
    DM  =   16      // dmem capacity
)(
    input   logic               clk0    ,
    input   logic               clk1    ,
    input   logic               clk2    ,
    input   logic               rst     ,
    output  logic   [BW-1:0]    result
);

logic               ena, flag;
logic   [BW-1:0]    data[1:0];

cpu #(
    .BW     (BW     )
) u_cpu (
    .clk1   (clk1   ),
    .clk2   (clk2   ),
    .rst    (rst    ),
    .ena    (ena    ),
    .data   (data   ),
    .flag   (flag   ),
    .result (result )
);

mem #(
    .BW     (BW     ),
    .IW     (IW     ),
    .IM     (IM     ),
    .DW     (DW     ),
    .DM     (DM     )
) u_mem (
    .clk    (clk0   ),
    .rst    (rst    ),
    .flag   (flag   ),
    .result (result ),
    .ena    (ena    ),
    .data   (data   )
);

endmodule