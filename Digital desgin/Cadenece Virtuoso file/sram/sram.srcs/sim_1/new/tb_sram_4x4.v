`timescale 1ns/1ps

module tb_sram_4x4;

    reg        clk;
    reg        we;
    reg [1:0]  addr;
    reg [3:0]  din;
    wire [3:0] dout;

    //==================================================
    // DUT
    //==================================================
    sram_4x4 DUT (
        .clk  (clk),
        .we   (we),
        .addr (addr),
        .din  (din),
        .dout (dout)
    );

    //==================================================
    // Clock Generation
    //==================================================
    initial begin
        clk = 1'b0;

        forever #5 clk = ~clk;
    end

    //==================================================
    // Test Sequence
    //==================================================
    initial begin

        // Initial values
        we   = 1'b0;
        addr = 2'b00;
        din  = 4'b0000;

        #10;

        // ---------------------------------------------
        // Write 1010 to address 00
        // ---------------------------------------------
        we   = 1'b1;
        addr = 2'b00;
        din  = 4'b1010;

        #10;

        // ---------------------------------------------
        // Write 1100 to address 01
        // ---------------------------------------------
        addr = 2'b01;
        din  = 4'b1100;

        #10;

        // ---------------------------------------------
        // Write 0011 to address 10
        // ---------------------------------------------
        addr = 2'b10;
        din  = 4'b0011;

        #10;

        // ---------------------------------------------
        // Write 1111 to address 11
        // ---------------------------------------------
        addr = 2'b11;
        din  = 4'b1111;

        #10;

        // ---------------------------------------------
        // Stop writing
        // ---------------------------------------------
        we = 1'b0;

        // Read address 00
        addr = 2'b00;
        #10;
        $display("Address = %b, Data = %b", addr, dout);

        // Read address 01
        addr = 2'b01;
        #10;
        $display("Address = %b, Data = %b", addr, dout);

        // Read address 10
        addr = 2'b10;
        #10;
        $display("Address = %b, Data = %b", addr, dout);

        // Read address 11
        addr = 2'b11;
        #10;
        $display("Address = %b, Data = %b", addr, dout);

        #10;

        $finish;

    end

endmodule