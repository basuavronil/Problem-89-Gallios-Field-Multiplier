`timescale 1ns/1ps
// GF(2^8) multiplier, primitive polynomial x^8 + x^4 + x^3 + x^2 + 1 (0x11D)
// Both cases are handled by the if/else inside the loop:
//   - no overflow : a_tmp[7] = 0 -> plain shift left
//   - overflow    : a_tmp[7] = 1 -> shift left, then XOR with 0x1D
module gf_mult_simple (
    input  wire [7:0] a,
    input  wire [7:0] b,
    output reg  [7:0] product
);

    reg [7:0] a_tmp;
    reg [7:0] b_tmp;
    reg [7:0] p;
    integer i;

    always @(*) begin
        a_tmp = a;
        b_tmp = b;
        p     = 8'h00;

        for (i = 0; i < 8; i = i + 1) begin
            // step 1: add (XOR) if the last bit of b is 1
            if (b_tmp[0] == 1)
                p = p ^ a_tmp;

            // step 2: shift a left, wrap around if overflow
            if (a_tmp[7] == 1)
                a_tmp = {a_tmp[6:0], 1'b0} ^ 8'h1D;   // overflow
            else
                a_tmp = {a_tmp[6:0], 1'b0};           // no overflow

            // step 3: next bit of b
            b_tmp = b_tmp >> 1;
        end

        product = p;
    end

endmodule
