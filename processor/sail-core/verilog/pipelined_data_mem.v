/*
 * Pipelined data memory wrapper around dual_port_bram_32x1024:
 * Splits the read/write path into two pipeline stages to allow
 * one new request per cycle with fixed latency.
 */
module pipelined_data_mem (
    input  wire         clk,
    input  wire [9:0]   addr_in,
    input  wire         we_in,
    input  wire [31:0]  din_in,
    output reg  [31:0]  dout_out
);

    // Stage 1 registers (request staging)
    reg         we_s1;
    reg [9:0]   addr_s1;
    reg [31:0]  din_s1;

    // Stage 2 registers (capture output)
    wire [31:0] dout_s2;
    reg         we_s2;
    reg [9:0]   addr_s2;
    reg [31:0]  din_s2;

    // Instantiate dual-port block RAM
    dual_port_bram_32x1024 bram (
        .clk   (clk),
        // Port A uses staged signals
        .weA   (we_s2),
        .addrA (addr_s2),
        .dinA  (din_s2),
        .doutA (dout_s2),
        // Port B unused here
        .weB   (1'b0),
        .addrB (10'd0),
        .dinB  (32'b0),
        .doutB ()
    );

    // Pipeline stage 1: sample inputs
    always @(posedge clk) begin
        we_s1   <= we_in;
        addr_s1 <= addr_in;
        din_s1  <= din_in;
    end

    // Pipeline stage 2: drive BRAM ports
    always @(posedge clk) begin
        we_s2   <= we_s1;
        addr_s2 <= addr_s1;
        din_s2  <= din_s1;
    end

    // Output register: capture BRAM read-data
    always @(posedge clk) begin
        dout_out <= dout_s2;
    end

endmodule
