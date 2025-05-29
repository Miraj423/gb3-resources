/*
 * Dual-port block RAM (1024x32) for iCE40 (SB_RAM40_4K or inferred)
 * Allows two independent read/write ports in one cycle.
 */
module dual_port_bram_32x1024 (
    input  wire         clk,
    // Port A
    input  wire         weA,
    input  wire [9:0]   addrA,
    input  wire [31:0]  dinA,
    output reg  [31:0]  doutA,
    // Port B
    input  wire         weB,
    input  wire [9:0]   addrB,
    input  wire [31:0]  dinB,
    output reg  [31:0]  doutB
);

    // Infer block RAM; for iCE40 use (* ramstyle="block" *)
    (* ramstyle = "block" *) reg [31:0] mem [0:1023];

    // Port A: Read/Write
    always @(posedge clk) begin
        if (weA) begin
            mem[addrA] <= dinA;
        end
        doutA <= mem[addrA];
    end

    // Port B: Read/Write
    always @(posedge clk) begin
        if (weB) begin
            mem[addrB] <= dinB;
        end
        doutB <= mem[addrB];
    end

endmodule
