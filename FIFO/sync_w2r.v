 module sync_w2r #(parameter n =4 ) (
    input rclk,rrst,
    input [n-1:0] wptr,
    output reg [n-1:0] rq2_wptr
);
    reg [n-1:0] q1;
    always @(posedge rclk or negedge rrst) begin
        if (!rrst) begin
            rq2_wptr<=0;q1<=0;
        end else begin
     q1<=wptr; rq2_wptr<=q1;end
    end
endmodule
