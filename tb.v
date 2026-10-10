`timescale 1ns/1ps
module tb_gf_mult_simple;
    reg  [7:0] a, b;
    wire [7:0] product;
    integer errors;

    gf_mult_simple dut (.a(a), .b(b), .product(product));

    task check;
        input [7:0] ta;
        input [7:0] tb;
        input [7:0] expected;
        begin
            a = ta; b = tb;
            #1;
            if (product === expected)
                $display("PASS: %h * %h = %h", ta, tb, product);
            else begin
                $display("FAIL: %h * %h = %h (expected %h)", ta, tb, product, expected);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        errors = 0;
        // Case 1: no overflow
        check(8'h03, 8'h05, 8'h0F);
        // Case 2: overflow (a[7] = 1 during doubling)
        check(8'h80, 8'h05, 8'hBA);
        check(8'h80, 8'h02, 8'h1D);
        // Extra checks
        check(8'h00, 8'hA7, 8'h00);
        check(8'h01, 8'hA7, 8'hA7);
        if (errors == 0) $display("ALL TESTS PASSED");
        else             $display("%0d TEST(S) FAILED", errors);
        $finish;
    end
endmodule
