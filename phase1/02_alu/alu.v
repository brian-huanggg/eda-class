`timescale 1ns/1ps
// Combinational ALU: 3-bit opcode selects the operation.
// Subtraction is done with the adder: a - b = a + (~b) + 1  (two's complement)
module alu #(parameter W = 8) (
    input      [W-1:0] a,
    input      [W-1:0] b,
    input      [2:0]   op,
    output reg [W-1:0] result,
    output             zero,      // result == 0
    output             carry,     // carry out (ADD) / no-borrow (SUB); 0 for other ops
    output             overflow   // signed overflow (ADD/SUB); 0 for other ops
);
    localparam ADD = 3'b000, SUB = 3'b001, AND = 3'b010,
               OR  = 3'b011, XOR = 3'b100, SLT = 3'b101;

    // --- shared adder/subtractor ---
    wire         sub   = (op == SUB) || (op == SLT);
    wire [W-1:0] b_eff = sub ? ~b : b;           // invert b when subtracting
    wire [W:0]   sum   = a + b_eff + sub;        // "+ sub" is the "+1" of two's complement
    wire         ovf   = (a[W-1] == b_eff[W-1]) && (sum[W-1] != a[W-1]);
    wire         less  = sum[W-1] ^ ovf;         // signed a < b

    // --- result select (a multiplexer) ---
    always @(*) begin
        case (op)
            ADD:     result = sum[W-1:0];
            SUB:     result = sum[W-1:0];
            AND:     result = a & b;
            OR:      result = a | b;
            XOR:     result = a ^ b;
            SLT:     result = {{(W-1){1'b0}}, less};
            default: result = {W{1'b0}};
        endcase
    end

    wire is_arith = (op == ADD) || (op == SUB);
    assign zero     = (result == {W{1'b0}});
    assign carry    = is_arith & sum[W];
    assign overflow = is_arith & ovf;
endmodule
