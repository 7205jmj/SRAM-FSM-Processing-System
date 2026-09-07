// =============================================================
// dual_port_sram_tb.v - Testbench for dual_port_sram.v
// Run with Icarus Verilog:
//   iverilog -o dp_sim dual_port_sram.v dual_port_sram_tb.v
//   vvp dp_sim
// =============================================================
`timescale 1ns/1ps

module dual_port_sram_tb;

    localparam DATA_WIDTH = 8;
    localparam ADDR_WIDTH = 4;   // 16-word depth for a quick sim

    reg                   clk_a, clk_b;
    reg                   en_a, we_a;
    reg  [ADDR_WIDTH-1:0] addr_a;
    reg  [DATA_WIDTH-1:0] din_a;
    wire [DATA_WIDTH-1:0] dout_a;

    reg                   en_b, we_b;
    reg  [ADDR_WIDTH-1:0] addr_b;
    reg  [DATA_WIDTH-1:0] din_b;
    wire [DATA_WIDTH-1:0] dout_b;

    integer errors;

    dual_port_sram #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .WRITE_MODE("READ_FIRST")
    ) dut (
        .clk_a(clk_a), .en_a(en_a), .we_a(we_a), .addr_a(addr_a), .din_a(din_a), .dout_a(dout_a),
        .clk_b(clk_b), .en_b(en_b), .we_b(we_b), .addr_b(addr_b), .din_b(din_b), .dout_b(dout_b)
    );

    // Two independent clock domains: 10ns and 7ns periods
    initial clk_a = 0;
    always #5   clk_a = ~clk_a;

    initial clk_b = 0;
    always #3.5 clk_b = ~clk_b;

    task check(input [8*20-1:0] label, input [DATA_WIDTH-1:0] got, input [DATA_WIDTH-1:0] expected);
        begin
            if (got !== expected) begin
                $display("FAIL: %0s expected=%0h got=%0h", label, expected, got);
                errors = errors + 1;
            end else begin
                $display("PASS: %0s (%0h)", label, got);
            end
        end
    endtask

    initial begin
        errors = 0;
        en_a = 0; we_a = 0; addr_a = 0; din_a = 0;
        en_b = 0; we_b = 0; addr_b = 0; din_b = 0;

        // ---------------------------------------------------
        // Test 1: Port A writes, Port B independently reads
        //         a DIFFERENT address at the same time
        // ---------------------------------------------------
        @(negedge clk_a);
        en_a = 1; we_a = 1; addr_a = 4'd2; din_a = 8'hAA;   // A writes addr 2
        en_b = 1; we_b = 0; addr_b = 4'd9;                   // B reads addr 9 (untouched, should be 0)
        @(negedge clk_a);
        @(negedge clk_b);
        check("B reads untouched addr9", dout_b, 8'h00);

        // Now B reads back what A wrote to addr 2
        @(negedge clk_b);
        we_b = 0; addr_b = 4'd2;
        @(negedge clk_b);
        @(negedge clk_b);
        check("B reads A's write to addr2", dout_b, 8'hAA);

        // ---------------------------------------------------
        // Test 2: Both ports write DIFFERENT addresses
        //         truly in parallel, then cross-read
        // ---------------------------------------------------
        @(negedge clk_a);
        en_a = 1; we_a = 1; addr_a = 4'd5; din_a = 8'h55;
        en_b = 1; we_b = 1; addr_b = 4'd6; din_b = 8'h66;
        @(negedge clk_a);
        @(negedge clk_b);

        we_a = 0; addr_a = 4'd6;   // A reads what B wrote
        we_b = 0; addr_b = 4'd5;   // B reads what A wrote
        @(negedge clk_a);
        @(negedge clk_b);
        @(negedge clk_a);
        @(negedge clk_b);
        check("A cross-reads B's addr6", dout_a, 8'h66);
        check("B cross-reads A's addr5", dout_b, 8'h55);

        // ---------------------------------------------------
        // Test 3: WRITE_FIRST-style same-port bypass check
        // (with READ_FIRST mode configured, dout should show
        //  OLD data on the write cycle itself)
        // ---------------------------------------------------
        @(negedge clk_a);
        we_a = 1; addr_a = 4'd5; din_a = 8'hF0;  // overwrite addr5 (currently 0x55)
        @(negedge clk_a);
        check("READ_FIRST: dout shows old data on write", dout_a, 8'h55);
        @(negedge clk_a);
        we_a = 0;
        @(negedge clk_a);
        check("Subsequent read shows new data", dout_a, 8'hF0);

        // ---------------------------------------------------
        // Test 4: Collision case - both ports write the SAME
        // address on overlapping edges. This is flagged by the
        // DUT's collision monitor; we don't assert a specific
        // "winner" value since real HW leaves it undefined -
        // we only confirm the simulation surfaces the hazard.
        // ---------------------------------------------------
        @(negedge clk_a);
        we_a = 1; addr_a = 4'd10; din_a = 8'h11;
        we_b = 1; addr_b = 4'd10; din_b = 8'h22;
        $display("--- Expect a WRITE COLLISION warning above/below this line ---");
        @(negedge clk_a);
        we_a = 0; we_b = 0;
        @(negedge clk_a);
        @(negedge clk_b);

        // ---------------------------------------------------
        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("%0d TEST(S) FAILED", errors);

        $finish;
    end

endmodule
