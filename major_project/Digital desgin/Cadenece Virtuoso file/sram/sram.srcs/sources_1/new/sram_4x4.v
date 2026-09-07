//======================================================
// 4 x 4 SRAM
// 4 words × 4 bits
//======================================================
module sram_4x4 (
    input  wire       clk,
    input  wire       we,
    input  wire [1:0] addr,
    input  wire [3:0] din,
    output wire [3:0] dout
);

    // Outputs of the 16 individual SRAM cells
    wire [15:0] cell_q;

    // Write enable for selected row
    wire [3:0] row_we;

    //==================================================
    // 2-to-4 Row Decoder
    //==================================================
    assign row_we[0] = we && (addr == 2'b00);
    assign row_we[1] = we && (addr == 2'b01);
    assign row_we[2] = we && (addr == 2'b10);
    assign row_we[3] = we && (addr == 2'b11);

    //==================================================
    // Row 0 : Address 00
    //==================================================
    sram_cell cell_00 (
        .clk(clk),
        .we(row_we[0]),
        .din(din[0]),
        .dout(cell_q[0])
    );

    sram_cell cell_01 (
        .clk(clk),
        .we(row_we[0]),
        .din(din[1]),
        .dout(cell_q[1])
    );

    sram_cell cell_02 (
        .clk(clk),
        .we(row_we[0]),
        .din(din[2]),
        .dout(cell_q[2])
    );

    sram_cell cell_03 (
        .clk(clk),
        .we(row_we[0]),
        .din(din[3]),
        .dout(cell_q[3])
    );

    //==================================================
    // Row 1 : Address 01
    //==================================================
    sram_cell cell_10 (
        .clk(clk),
        .we(row_we[1]),
        .din(din[0]),
        .dout(cell_q[4])
    );

    sram_cell cell_11 (
        .clk(clk),
        .we(row_we[1]),
        .din(din[1]),
        .dout(cell_q[5])
    );

    sram_cell cell_12 (
        .clk(clk),
        .we(row_we[1]),
        .din(din[2]),
        .dout(cell_q[6])
    );

    sram_cell cell_13 (
        .clk(clk),
        .we(row_we[1]),
        .din(din[3]),
        .dout(cell_q[7])
    );

    //==================================================
    // Row 2 : Address 10
    //==================================================
    sram_cell cell_20 (
        .clk(clk),
        .we(row_we[2]),
        .din(din[0]),
        .dout(cell_q[8])
    );

    sram_cell cell_21 (
        .clk(clk),
        .we(row_we[2]),
        .din(din[1]),
        .dout(cell_q[9])
    );

    sram_cell cell_22 (
        .clk(clk),
        .we(row_we[2]),
        .din(din[2]),
        .dout(cell_q[10])
    );

    sram_cell cell_23 (
        .clk(clk),
        .we(row_we[2]),
        .din(din[3]),
        .dout(cell_q[11])
    );

    //==================================================
    // Row 3 : Address 11
    //==================================================
    sram_cell cell_30 (
        .clk(clk),
        .we(row_we[3]),
        .din(din[0]),
        .dout(cell_q[12])
    );

    sram_cell cell_31 (
        .clk(clk),
        .we(row_we[3]),
        .din(din[1]),
        .dout(cell_q[13])
    );

    sram_cell cell_32 (
        .clk(clk),
        .we(row_we[3]),
        .din(din[2]),
        .dout(cell_q[14])
    );

    sram_cell cell_33 (
        .clk(clk),
        .we(row_we[3]),
        .din(din[3]),
        .dout(cell_q[15])
    );

    //==================================================
    // Read MUX
    //==================================================
    assign dout = (addr == 2'b00) ? cell_q[3:0]   :
                  (addr == 2'b01) ? cell_q[7:4]   :
                  (addr == 2'b10) ? cell_q[11:8]  :
                                    cell_q[15:12];

endmodule