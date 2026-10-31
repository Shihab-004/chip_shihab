
`timescale 1ns/1ps

module alu_tb;

    reg [7:0] A, B;
    reg [2:0] opcode;

    wire [7:0] result;
    wire carry, zero, overflow;

    integer pass_count = 0;
    integer fail_count = 0;

    // ALU connection
    alu uut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .result(result),
        .carry(carry),
        .zero(zero),
        .overflow(overflow)
    );

    // Self-checking task
    task run_test;

        input [7:0] test_A;
        input [7:0] test_B;
        input [2:0] test_opcode;

        input [7:0] expected_result;
        input expected_carry;
        input expected_zero;
        input expected_overflow;

        begin
            A = test_A;
            B = test_B;
            opcode = test_opcode;

            #1;

            if (
                result !== expected_result ||
                carry !== expected_carry ||
                zero !== expected_zero ||
                overflow !== expected_overflow
            ) begin

                $display("FAIL | A=%h B=%h OP=%b | Expected: R=%h C=%b Z=%b V=%b | Actual: R=%h C=%b Z=%b V=%b",
                    A, B, opcode,
                    expected_result, expected_carry,
                    expected_zero, expected_overflow,
                    result, carry, zero, overflow
                );

                fail_count = fail_count + 1;

            end else begin

                $display("PASS | A=%h B=%h OP=%b | Result=%h",
                    A, B, opcode, result
                );

                pass_count = pass_count + 1;

            end
        end

    endtask


    initial begin

        $dumpfile("simulation/alu.vcd");
        $dumpvars(0, alu_tb);

        $display("\n===== 8-BIT ALU VERIFICATION STARTED =====\n");

        // ADD tests
        run_test(10, 5, 3'b000, 15, 0, 0, 0);
        run_test(255, 1, 3'b000, 0, 1, 1, 0);
        run_test(127, 1, 3'b000, 128, 0, 0, 1);
        run_test(128, 128, 3'b000, 0, 1, 1, 1);

        // SUB tests
        run_test(10, 5, 3'b001, 5, 1, 0, 0);
        run_test(5, 10, 3'b001, 251, 0, 0, 0);
        run_test(128, 1, 3'b001, 127, 1, 0, 1);
        run_test(0, 0, 3'b001, 0, 1, 1, 0);

        // AND tests
        run_test(8'hF0, 8'h0F, 3'b010, 8'h00, 0, 1, 0);
        run_test(8'hFF, 8'h0F, 3'b010, 8'h0F, 0, 0, 0);

        // OR tests
        run_test(8'hF0, 8'h0F, 3'b011, 8'hFF, 0, 0, 0);

        // XOR tests
        run_test(8'hAA, 8'hFF, 3'b100, 8'h55, 0, 0, 0);

        // NOT tests
        run_test(8'h55, 0, 3'b101, 8'hAA, 0, 0, 0);
        run_test(8'hFF, 0, 3'b101, 8'h00, 0, 1, 0);

        // Left Shift tests
        run_test(8'h0F, 0, 3'b110, 8'h1E, 0, 0, 0);
        run_test(8'h80, 0, 3'b110, 8'h00, 0, 1, 0);

        // Right Shift tests
        run_test(8'hF0, 0, 3'b111, 8'h78, 0, 0, 0);
        run_test(8'h01, 0, 3'b111, 8'h00, 0, 1, 0);


        // Final verification summary
        $display("\n===== VERIFICATION SUMMARY =====");
        $display("Total Tests : %0d", pass_count + fail_count);
        $display("PASS        : %0d", pass_count);
        $display("FAIL        : %0d", fail_count);

        if (fail_count == 0)
            $display("\nALL TESTS PASSED!");
        else
            $display("\nVERIFICATION FAILED!");

        $finish;

    end

endmodule
