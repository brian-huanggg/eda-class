`timescale 1ns/1ps
module adder_tb;
    localparam W = 4;
    reg  [W-1:0] a, b;
    reg          cin;
    wire [W-1:0] sum;
    wire         cout;
    integer i, j, k, errors;

    adder #(W) dut (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

    initial begin
        $dumpfile("adder.vcd");
        $dumpvars(0, adder_tb);
        errors = 0;
        // exhaustive: 16 * 16 * 2 = 512 cases
        for (i = 0; i < (1<<W); i = i + 1)
            for (j = 0; j < (1<<W); j = j + 1)
                for (k = 0; k < 2; k = k + 1) begin
                    a = i; b = j; cin = k;
                    #1;
                    if ({cout, sum} !== i + j + k) begin
                        errors = errors + 1;
                        $display("FAIL a=%0d b=%0d cin=%0d -> cout=%b sum=%0d", a, b, cin, cout, sum);
                    end
                end
        if (errors == 0) $display("PASS: all 512 cases");
        else             $display("FAILED: %0d errors", errors);
        $finish;
    end
endmodule
