module mux_shifter(
    input wire selector,
    input wire [4:0] SHAMT,
    output wire [4:0] Data_out
);

    assign Data_out = (selector) ? 5'b10000 : SHAMT;

endmodule