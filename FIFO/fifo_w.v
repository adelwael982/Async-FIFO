module fifo_w #(
    parameter n=4
) (
    input wclk,wrst,winc,
    input [n-1:0]wq2_rptr,
    output full,
    output [n-2:0] waddr,
    output [n-1:0] wptr
);
gray #(.n(n))d1(
.clk(wclk),
.rst(wrst),
.flag(full),
.ptr(wptr),
.inc(winc),
.addr(waddr)) ; 
assign full=(wq2_rptr[n-1]!==wptr[n-1])&&(wq2_rptr[n-2]!==wptr[n-2])&&(wq2_rptr[n-3:0]==wptr[n-3:0]); 
endmodule
