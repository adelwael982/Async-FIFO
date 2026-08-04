module gray #(parameter n = 4) (
    input  inc, clk, rst, flag,       
    output reg [n-1:0] ptr,            
    output     [n-2:0] addr            
);
    reg  [n-1:0] bin;                  
    wire [n-1:0] bnext, gnext;

    wire inc_en = inc && !flag;

    assign bnext = bin + inc_en;
    assign gnext = bnext ^ (bnext >> 1);
    assign addr  = bin[n-2:0];

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            bin <= 0;
            ptr <= 0;
        end else begin
            bin <= bnext;
            ptr <= gnext;
        end
    end
endmodule