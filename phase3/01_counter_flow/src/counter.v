`timescale 1ns/1ps
// Synchronous up-counter with enable and synchronous active-high reset.
// First sequential circuit: state (count) is stored in flip-flops and
// only changes on the rising edge of clk.
module counter #(parameter W = 4) (
    input              clk,
    input              rst,     // synchronous reset, active high
    input              en,      // count enable
    output reg [W-1:0] count,
    output             wrap     // high while count is at its max value
);
    always @(posedge clk) begin
        if (rst)
            count <= {W{1'b0}};
        else if (en)
            count <= count + 1'b1;   // wraps to 0 by itself after 2^W - 1
    end

    assign wrap = &count;            // reduction AND: all bits are 1
endmodule
