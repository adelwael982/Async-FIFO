module fifo_r #(
    parameter n=4
) (
    input rclk,rrst,rinc,
    input [n-1:0]rq2_wptr,
    output empty,
    output [n-2:0] raddr,
    output [n-1:0] rptr
);
gray #(.n(n))d1(
.clk(rclk),
.rst(rrst),
.flag(empty),
.ptr(rptr),
.inc(rinc),
.addr(raddr)) ; 
assign empty=(rq2_wptr==rptr); 
endmodule
