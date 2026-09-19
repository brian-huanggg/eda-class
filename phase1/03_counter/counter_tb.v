`timescale 1ns/1ps
module counter_tb;
    localparam W = 4;

    reg          clk = 0;
    reg          rst = 0;
    reg          en  = 0;
    wire [W-1:0] count;
    wire         wrap;

    counter #(W) dut (.clk(clk), .rst(rst), .en(en), .count(count), .wrap(wrap));

    // 10 ns clock period
    always #5 clk = ~clk;

    // reference model: same behaviour written independently
    reg [W-1:0] exp;
    reg         known = 0;           // model is valid only after the first reset
    integer     errors = 0, checks = 0;

    always @(posedge clk) begin
        if (rst)      begin exp <= 0;       known <= 1; end
        else if (en)  exp <= exp + 1;
    end

    // check on the falling edge: outputs have settled, inputs not yet changed
    always @(negedge clk) if (known) begin
        checks = checks + 1;
        if (count !== exp || wrap !== (exp == {W{1'b1}})) begin
            errors = errors + 1;
            $display("FAIL t=%0t rst=%b en=%b count=%0d exp=%0d wrap=%b",
                     $time, rst, en, count, exp, wrap);
        end
    end

    // stimulus is applied on the falling edge, away from the sampling edge
    integer n;
    initial begin
        $dumpfile("counter.vcd");
        $dumpvars(0, counter_tb);

        // 1) reset
        rst = 1; en = 0;
        repeat (2) @(negedge clk);
        rst = 0;

        // 2) count freely for 20 cycles (wraps 15 -> 0 once)
        en = 1;
        repeat (20) @(negedge clk);

        // 3) pause: count must hold
        en = 0;
        repeat (5) @(negedge clk);

        // 4) resume, then reset in the middle of counting
        en = 1;
        repeat (6) @(negedge clk);
        rst = 1;
        @(negedge clk);
        rst = 0;
        repeat (4) @(negedge clk);

        // 5) random rst / en
        for (n = 0; n < 500; n = n + 1) begin
            rst = ($urandom % 10 == 0);
            en  = $urandom % 2;
            @(negedge clk);
        end

        if (errors == 0) $display("PASS: %0d checks", checks);
        else             $display("FAILED: %0d errors", errors);
        $finish;
    end
endmodule
