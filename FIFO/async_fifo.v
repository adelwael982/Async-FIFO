module async_fifo #(
    parameter n=4,data=8
) (
    input wclk,rclk,rinc,winc,rrst,wrst,
    input [data-1:0] wdata,
    output [data-1:0]rdata,
    output full,empty
);
wire [n-1:0] wptr, rptr;          // Gray pointers
    wire [n-1:0] wq2_rptr, rq2_wptr;  // synchronized pointers
    wire [n-2:0] waddr, raddr;
fifo_r #(.n(n))d1(
.rclk(rclk),
.rrst(rrst),
.empty(empty),
.rptr(rptr),
.rinc(rinc),
.rq2_wptr(rq2_wptr),
.raddr(raddr)) ; 
fifo_w #(.n(n))d2(
.wclk(wclk),
.wrst(wrst),
.full(full),
.wptr(wptr),
.winc(winc),
.wq2_rptr(wq2_rptr),
.waddr(waddr)) ; 
sync_r2w #(.n(n)) sync1 (
.wclk(wclk),
.wrst(wrst),
.rptr(rptr),
.wq2_rptr(wq2_rptr) );
sync_w2r #(.n(n)) sync2 ( 
.rclk(rclk),
.rrst(rrst),
.wptr(wptr),
.rq2_wptr(rq2_wptr) );
ram_fifo #(.data(data),.n(n)) ram(
.waddr(waddr),
.raddr(raddr),
.full(full),
.wclk(wclk),
.winc(winc),
.wdata(wdata),
.rdata(rdata)  );
endmodule
