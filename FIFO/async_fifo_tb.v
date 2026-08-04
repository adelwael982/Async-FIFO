module tb_async_fifo;

    parameter N = 4;
    parameter DATA = 8;

    reg wclk, rclk, wrst, rrst, winc, rinc;
    reg [DATA-1:0] wdata;
    wire [DATA-1:0] rdata;
    wire full, empty;

    async_fifo #(.n(N), .data(DATA)) dut (
        .wclk(wclk), .rclk(rclk),
        .winc(winc), .rinc(rinc),
        .wrst(wrst), .rrst(rrst),
        .wdata(wdata), .rdata(rdata),
        .full(full), .empty(empty)
    );

    always #5   wclk = ~wclk;
    always #3.5 rclk = ~rclk;

    integer i;

    initial begin
        wclk = 0; rclk = 0;
        wrst = 0; rrst = 0;
        winc = 0; rinc = 0; wdata = 0;

        #20;
        wrst = 1;
        rrst = 1;

        // ---- TEST 1: write-only fill test ----
        @(posedge wclk);
        for (i = 0; i < 9; i = i + 1) begin   // 9 tries on an 8-deep FIFO
            @(posedge wclk);
            winc  <= 1;
            wdata <= i;
        end
        @(posedge wclk);
        winc <= 0;

        #20;
        if (full)
            $display("TEST 1 PASS: full asserted after 8 writes. full=%b", full);
        else
            $display("TEST 1 FAIL: full not asserted. full=%b", full);

        #50; // let flags settle across domains

        // ---- TEST 2: read-only drain test ----
        @(posedge rclk);
        for (i = 0; i < 9; i = i + 1) begin   // 9 tries to drain 8 words
            @(posedge rclk);
            rinc <= 1;
        end
        @(posedge rclk);
        rinc <= 0;

        #20;
        if (empty)
            $display("TEST 2 PASS: empty asserted after 8 reads. empty=%b", empty);
        else
            $display("TEST 2 FAIL: empty not asserted. empty=%b", empty);

        #50
                @(posedge wclk);
        for (i = 0; i < 4; i = i + 1) begin   // 9 tries on an 8-deep FIFO
            @(posedge wclk);
            winc  <= 1;
            wdata <= i;
        end
        @(posedge wclk);
        winc <= 0;

        #20;
                @(posedge rclk)
                @(posedge wclk);
        for (i = 0; i < 22; i = i + 1) begin   // 9 tries on an 8-deep FIFO
            @(posedge wclk);
            winc  <= 1;
            wdata <= i;
            rinc<=1;
            $display("empty=%b , full=%b",empty,full);
        end
#20;
        @(posedge wclk);
        winc <= 0;
        @(posedge rclk);
        rinc <= 0;

        #20;

        wrst=0;rrst=0;
        #20;
        wrst=1;rrst=1;#20;
// Step 1: fill to 7/8
@(posedge wclk);
for (i = 0; i < 7; i = i + 1) begin
    @(posedge wclk);
    winc <= 1; wdata <= i;
end
@(posedge wclk);
winc <= 0;
#20;
$display("after 7 writes: full=%b empty=%b", full, empty);

// Step 2: the 8th write (should trigger full) and a near-simultaneous read
@(posedge wclk);
winc <= 1; wdata <= 8'hFF;
@(posedge rclk);      // as close to the same instant as the two clocks allow
rinc <= 1;

@(posedge wclk);
winc <= 0;
$display("right after 8th write: full=%b", full);   // expect full=1 here

@(posedge rclk);
rinc <= 0;

// Step 3: watch full deassert as the synchronizer catches up
repeat (5) begin
    @(posedge wclk);
    $display("wclk settle: full=%b", full);
end

        #100 $stop;
    end

endmodule