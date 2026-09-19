`timescale 1ns/1ps
// 4-bit adder with carry in/out (purely combinational)
module adder #(parameter W = 4) (
    input  [W-1:0] a,
    input  [W-1:0] b,
    input          cin,
    output [W-1:0] sum,
    output         cout
);
    assign {cout, sum} = a + b + cin;
endmodule
