//======================================================
// 1-Bit SRAM Cell
//======================================================
module sram_cell (
    input  wire clk,
    input  wire we,
    input  wire din,
    output reg  dout
);

    always @(posedge clk) begin
        if (we)
            dout <= din;
    end

endmodule