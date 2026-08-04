module ram_fifo #(
    parameter data=8,n=4
) (
    input wclk,winc,full,
    input [data-1:0] wdata,
    input [n-2:0] raddr,waddr,
    output [data-1:0] rdata
);
    wire wen;
    assign wen=winc&&!full;
    reg [data-1:0] mem [0:(1<<n)-1];
    integer j;
    always @(posedge wclk) begin
        if(wen)
        mem[waddr]<=wdata;
        else 
        mem[waddr]<=mem[waddr];
    end
  assign rdata=mem[raddr];
endmodule