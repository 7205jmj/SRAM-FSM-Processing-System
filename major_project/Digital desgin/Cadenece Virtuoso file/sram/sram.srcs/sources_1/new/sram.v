// =============================================================
// dual_port_sram.v - True Dual-Port Synchronous SRAM
// =============================================================
// Two fully independent ports (A, B), each with its own clock,
// enable, write-enable, address and data - modeling a true
// dual-port block RAM (e.g. as used in FIFOs, shared-memory
// CPU/DMA interfaces, or video frame buffers).
//
// WRITE_MODE controls what a port's dout shows when THAT SAME
// port writes on the current cycle (standard FPGA BRAM options):
//   "WRITE_FIRST" : dout <= new data being written      (bypass)
//   "READ_FIRST"  : dout <= old data, THEN mem updates  (default)
//   "NO_CHANGE"   : dout holds its previous value during a write
//
// NOTE ON CROSS-PORT COLLISIONS:
// If port A and port B write to the SAME address on the SAME
// clock edge, real dual-port RAM hardware leaves the result
// UNDEFINED (this is a well-known hazard called a "true
// collision" - see Xilinx UG573 / vendor BRAM datasheets). This
// model does not try to hide that: it flags it in simulation via
// $display so the hazard is visible during verification, and
// leaves memory update order to simulator scheduling - a real
// design must avoid this by construction (mutex/handshake between
// the two masters), not rely on RTL behavior to resolve it.
// =============================================================

module dual_port_sram #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 8,
    parameter DEPTH       = (1 << ADDR_WIDTH),
    parameter WRITE_MODE  = "READ_FIRST"   // "READ_FIRST" | "WRITE_FIRST" | "NO_CHANGE"
)(
    // ---------------- Port A ----------------
    input  wire                  clk_a,
    input  wire                  en_a,
    input  wire                  we_a,
    input  wire [ADDR_WIDTH-1:0] addr_a,
    input  wire [DATA_WIDTH-1:0] din_a,
    output reg  [DATA_WIDTH-1:0] dout_a,

    // ---------------- Port B ----------------
    input  wire                  clk_b,
    input  wire                  en_b,
    input  wire                  we_b,
    input  wire [ADDR_WIDTH-1:0] addr_b,
    input  wire [DATA_WIDTH-1:0] din_b,
    output reg  [DATA_WIDTH-1:0] dout_b
);

    // ---------------------------------------------------------
    // Shared memory array - the one thing both ports arbitrate
    // ---------------------------------------------------------
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    integer k;
    initial
        for (k = 0; k < DEPTH; k = k + 1)
            mem[k] = {DATA_WIDTH{1'b0}};

    // ---------------------------------------------------------
    // Cross-port collision flag (simulation-only visibility)
    // ---------------------------------------------------------
    // synthesis translate_off
    always @(posedge clk_a) begin
        if (en_a && we_a && en_b && we_b && (addr_a == addr_b) && clk_a == clk_b)
            $display("[%0t] WARNING: true dual-port WRITE COLLISION at addr %0d",
                      $time, addr_a);
    end
    // synthesis translate_on

    // ---------------------------------------------------------
    // Port A
    // ---------------------------------------------------------
    always @(posedge clk_a) begin
        if (en_a) begin
            if (we_a) begin
                mem[addr_a] <= din_a;
                if (WRITE_MODE == "WRITE_FIRST")
                    dout_a <= din_a;
                else if (WRITE_MODE == "READ_FIRST")
                    dout_a <= mem[addr_a];
                // NO_CHANGE: dout_a simply not updated this cycle
            end else begin
                dout_a <= mem[addr_a];
            end
        end
    end

    // ---------------------------------------------------------
    // Port B
    // ---------------------------------------------------------
    always @(posedge clk_b) begin
        if (en_b) begin
            if (we_b) begin
                mem[addr_b] <= din_b;
                if (WRITE_MODE == "WRITE_FIRST")
                    dout_b <= din_b;
                else if (WRITE_MODE == "READ_FIRST")
                    dout_b <= mem[addr_b];
            end else begin
                dout_b <= mem[addr_b];
            end
        end
    end

endmodule
