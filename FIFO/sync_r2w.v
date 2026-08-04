 module sync_r2w #(parameter n =4 ) (
    input wclk,wrst,
    input [n-1:0] rptr,
    output reg [n-1:0] wq2_rptr
);
    reg [n-1:0] q1;
    always @(posedge wclk or negedge wrst) begin
        if (!wrst) begin
            wq2_rptr<=0;q1<=0;
        end else begin
     q1<=rptr; wq2_rptr<=q1; end
    end
endmodule