`timescale 1ns/1ps
module alu_tb;
    localparam W = 4;                 // small width => exhaustive test is cheap
    localparam M = (1 << W);

    reg  [W-1:0] a, b;
    reg  [2:0]   op;
    wire [W-1:0] result;
    wire         zero, carry, overflow;

    alu #(W) dut (.a(a), .b(b), .op(op),
                  .result(result), .zero(zero), .carry(carry), .overflow(overflow));

    // reference model uses plain integers (independent of how the DUT is built)
    function integer sgn(input [W-1:0] x);   // interpret x as two's complement
        sgn = x[W-1] ? x - M : x;
    endfunction

    integer i, j, o, errors;
    integer e_full;                          // exact (unbounded) result
    reg [W-1:0] e_res;
    reg e_carry, e_ovf;

    initial begin
        $dumpfile("alu.vcd");
        $dumpvars(0, alu_tb);
        errors = 0;
        for (o = 0; o < 8; o = o + 1)
            for (i = 0; i < M; i = i + 1)
                for (j = 0; j < M; j = j + 1) begin
                    op = o; a = i; b = j;
                    #1;
                    e_carry = 0; e_ovf = 0;
                    case (o)
                        0: begin
                            e_full  = i + j;
                            e_res   = e_full % M;
                            e_carry = (e_full >= M);
                            e_ovf   = (sgn(a) + sgn(b) > M/2 - 1) || (sgn(a) + sgn(b) < -M/2);
                        end
                        1: begin
                            e_full  = i - j;
                            e_res   = (e_full + M) % M;
                            e_carry = (i >= j);
                            e_ovf   = (sgn(a) - sgn(b) > M/2 - 1) || (sgn(a) - sgn(b) < -M/2);
                        end
                        2: e_res = i & j;
                        3: e_res = i | j;
                        4: e_res = i ^ j;
                        5: e_res = (sgn(a) < sgn(b)) ? 1 : 0;
                        default: e_res = 0;
                    endcase
                    if (result !== e_res || zero !== (e_res == 0) ||
                        carry !== e_carry || overflow !== e_ovf) begin
                        errors = errors + 1;
                        if (errors <= 10)
                            $display("FAIL op=%0d a=%0d b=%0d -> res=%0d z=%b c=%b v=%b (exp res=%0d c=%b v=%b)",
                                     o, a, b, result, zero, carry, overflow, e_res, e_carry, e_ovf);
                    end
                end
        if (errors == 0) $display("PASS: all %0d cases", 8*M*M);
        else             $display("FAILED: %0d errors", errors);
        $finish;
    end
endmodule
