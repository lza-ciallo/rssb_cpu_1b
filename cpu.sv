module cpu #(
    BW  =   1   // data width
)(
    input   logic               clk1            ,
    input   logic               clk2            ,
    input   logic               rst             ,
    input   logic               ena             ,
    input   logic   [BW-1:0]    data    [1:0]   ,
    output  logic               flag            ,
    output  logic   [BW-1:0]    result
);

logic   [BW-1:0]    data_r  ;
logic   [BW-1:0]    result_r;

// ==================== CLK1 STAGE  ====================
always_ff @( posedge clk1 or negedge rst ) begin
    if (~rst) begin
        data_r          <=  '0;
        result_r        <=  '0;
    end
    else begin
        if (~ena) begin
            data_r      <=  data_r;
            result_r    <=  result_r;
        end
        else begin
            data_r      <=  flag? data[1] : data[0];
            result_r    <=  result;
        end
    end
end

// ==================== CLK2 STAGE  ====================
always_ff @( posedge clk2 or negedge rst ) begin
    if (~rst) begin
        {flag, result}      <=  '0;
    end
    else begin
        if (~ena) begin
            {flag, result}  <=  {flag, result};
        end
        else begin
            {flag, result}  <=  {1'b0, data_r} - {1'b0, result};
        end
    end
end

endmodule