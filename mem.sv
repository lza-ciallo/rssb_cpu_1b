module mem #(
    BW  =   1   ,   // data width
    IW  =   4   ,   // imem pc width
    IM  =   16  ,   // imem capacity
    DW  =   4   ,   // dmem idx width
    DM  =   16  ,   // dmem capacity
    LEN =   4   ,   // fifo length
    PTR =   2       // fifo ptr width
)(
    input   logic               clk             ,
    input   logic               rst             ,
    input   logic               flag            ,
    input   logic   [BW-1:0]    result          ,
    output  logic               ena             ,
    output  logic   [BW-1:0]    data    [1:0]
);

typedef struct packed {
    logic   [BW-1:0]    data    ;
    logic   [IW-1:0]    pc      ;
    logic               valid   ;
} fifo_entry;

logic   [DW-1:0]    imem    [ IM-1:0]   ;
logic   [BW-1:0]    dmem    [ DM-1:0]   ;
fifo_entry          fifo    [LEN-1:0]   ;

logic   [ IW-1:0]   pc          ;
logic   [PTR-1:0]   ptr_old     ;
logic   [PTR-1:0]   ptr_young   ;


// ==================== IMEM INIT LUT       ====================
always_comb begin
    
end

// ==================== DMEM INIT & RENEW   ====================
always_ff @( clock ) begin : blockName
    
end

// ==================== FIFO RENEW IN & OUT ====================
always_ff @( clock ) begin : blockName
    
end

endmodule