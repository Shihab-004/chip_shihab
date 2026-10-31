
`timescale 1ns/1ps

module alu_random_tb;

    reg [7:0] A, B;
    reg [2:0] opcode;

    wire [7:0] result;
    wire carry, zero, overflow;

    integer i;
    integer pass_count = 0;
    integer fail_count = 0;

    reg [8:0] expected_sum;
    reg [7:0] expected_result;
    reg expected_carry;
    reg expected_zero;
    reg expected_overflow;

    alu uut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .result(result),
        .carry(carry),
        .zero(zero),
        .overflow(overflow)
    );

    initial begin

        $dumpfile("simulation/alu_random.vcd");
        $dumpvars(0, alu_random_tb);

        $display("===== RANDOM ALU TESTING STARTED =====");

        for (i = 0; i < 1000; i = i + 1) begin

            A = $random;
            B = $random;
            opcode = $random % 8;

            #1;

            expected_result = 0;
            expected_carry = 0;
            expected_overflow = 0;

            case (opcode)

                3'b000: begin
                    expected_sum = A + B;
                    expected_result = expected_sum[7:0];
                    expected_carry = expected_sum[8];

                    expected_overflow =
                        (~(A[7] ^ B[7])) &
                        (expected_result[7] ^ A[7]);
                end

                3'b001: begin
                    expected_result = A - B;
                    expected_carry = (A >= B);

                    expected_overflow =
                        (A[7] ^ B[7]) &
                        (expected_result[7] ^ A[7]);
                end

                3'b010: expected_result = A & B;

                3'b011: expected_result = A | B;

                3'b100: expected_result = A ^ B;

                3'b101: expected_result = ~A;

                3'b110: expected_result = A << 1;

                3'b111: expected_result = A >> 1;

            endcase

            expected_zero = (expected_result == 0);

            if (
                result !== expected_result ||
                carry !== expected_carry ||
                zero !== expected_zero ||
                overflow !== expected_overflow
            ) begin

                fail_count = fail_count + 1;

                $display(
                    "FAIL | A=%h B=%h OP=%b",
                    A, B, opcode
                );

            end
            else begin

                pass_count = pass_count + 1;

            end

        end

        $display("\n===== RANDOM TEST SUMMARY =====");
        $display("Total Tests : %0d", pass_count + fail_count);
        $display("PASS        : %0d", pass_count);
        $display("FAIL        : %0d", fail_count);

        if (fail_count == 0)
            $display("ALL RANDOM TESTS PASSED!");
        else
            $display("RANDOM TESTING FAILED!");

        $finish;

    end

endmodule
