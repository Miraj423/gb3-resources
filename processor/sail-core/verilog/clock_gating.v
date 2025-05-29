module clock_gating (
    input wire clk,
    input wire enable,
    output wire gated_clk
);
    reg enable_latched;
    always @(posedge clk or negedge enable)
        if (!enable)
            enable_latched <= 0;
        else
            enable_latched <= 1;

    assign gated_clk = clk & enable_latched;
endmodule
