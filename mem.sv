module mem #(
    BW  =   1   ,   // data width
    IW  =   4   ,   // imem pc width
    IM  =   16  ,   // imem capacity
    DW  =   4   ,   // dmem idx width
    DM  =   16      // dmem capacity
)(
    input   logic               clk         ,
    input   logic               rst         ,
    input   logic               flag        ,
    input   logic   [BW-1:0]    result      ,
    output  logic               ena         ,
    output  logic   [BW-1:0]    data[1:0]
);

logic   [DW-1:0]    imem    [IM-1:0];
logic   [BW-1:0]    dmem    [DM-1:0];

logic   [IW-1:0]    pc, pc1;
logic               flagr;

always_comb pc1     =   pc + 1;
always_comb ena     =   1;
always_comb data[0] =   dmem[imem[pc ]];
always_comb data[1] =   dmem[imem[pc1]];

// ==================== IMEM INIT   ====================

always_comb begin
    for (int i = 0; i < IM; i = i + 1) begin
        imem[i] = '0;
    end
    // ----- a comparison program -----
    imem[0] =   4'h0;   // Acc = Mem[0],            Flag = 0
    imem[1] =   4'h1;   // Acc = Mem[1] - Mem[0],   Flag = Mem[1] < Mem[0]
    imem[2] =   4'h5;   // Mem[5].init(0)
                        // Acc = Mem[0] - Mem[1],   Flag = Mem[1] > Mem[0]
    imem[3] =   4'h2;   // Mem[2].init(0)
                        // if Mem[1] < Mem[0]:  Acc, Mem[2] = 1,    Flag = 1
                        // if Mem[1] = Mem[0]:  Acc, Mem[2] = 0,    Flag = 0
    imem[4] =   4'h4;   // Mem[4].init(0)
                        // if Mem[1] > Mem[0]:  Acc, Mem[4] = 1,    Flag = 1
                        // if Mem[1] = Mem[0]:  Acc, Mem[4] = 0,    Flag = 0
    imem[5] =   4'h7;   // Mem[7].init(0)
                        // if Mem[1] < Mem[0]:  Acc, Mem[7] = 1,    Flag = 1
                        // if Mem[1] = Mem[0]:  Acc, Mem[7] = 0,    Flag = 0
    imem[6] =   4'h6;   // Mem[6].init(1)
                        // if Mem[1] = Mem[0]:  Acc = 1,    Flag = 0
                        // if Mem[1] > Mem[0]:  Acc = 0,    Flag = 0
    imem[7] =   4'h7;   // recall Mem[7]
                        // if Mem[1] < Mem[0]:  Acc = 0,    Flag = 0
                        // if Mem[1] = Mem[0]:  Acc = 1,    Flag = 1
                        // if Mem[1] > Mem[0]:  Acc = 0,    Flag = 0
    imem[8] =   4'h7;   // recall Mem[7] again
                        // if Mem[1] < Mem[0]:  Acc = 0,    Flag = 0
                        // if Mem[1] > Mem[0]:  Acc = 0,    Flag = 0
    imem[9] =   4'h3;   // Mem[3].init(0)
                        // if Mem[1] = Mem[0]:  Mem[3] = 1, Flag = 1
                        // if Mem[1] ^ Mem[0]:  Mem[3] = 0, Flag = 0
    imem[10]=   4'h8;   //  Mem[8].init(1)
    imem[11]=   4'h8;   // Mem[1] = Mem[0] flip Acc = 1 -> 0
    imem[12]=   4'h9;   // 111-pattern, halt in tb
    imem[13]=   4'ha;
    imem[14]=   4'hb;
    imem[15]=   4'h5;
end

// ==================== DMEM RENEW  ====================
always_ff @( posedge clk or negedge rst ) begin
    if (~rst) begin
        pc      <= '1;
        flagr   <=  0;

        dmem[2] <=  0;  // Mem[1] < Mem[0]
        dmem[3] <=  0;  // Mem[1] = Mem[0]
        dmem[4] <=  0;  // Mem[1] > Mem[0]
        dmem[5] <=  0;  // flip inst0x2
        dmem[6] <=  1;  // flip inst0x6
        dmem[7] <=  0;  // flip inst0x5
        dmem[8] <=  1;  // flip inst0xb
        dmem[9] <=  1;  // 111-
        dmem[10]<=  1;  // halt-
        dmem[11]<=  1;  // pattern
        // ----- change your A & B to compare -----
        {dmem[1], dmem[0]} <= 2'b00;
        // {dmem[1], dmem[0]} <= 2'b01;
        // {dmem[1], dmem[0]} <= 2'b10;
        // {dmem[1], dmem[0]} <= 2'b11;
    end
    else begin
        pc      <=  flagr? pc + 2 : pc + 1;
        flagr   <=  flag;
        if (~flagr) begin
            dmem[imem[pc ]] <=  result;
        end
        else begin
            dmem[imem[pc1]] <=  result;
        end
    end
end

endmodule