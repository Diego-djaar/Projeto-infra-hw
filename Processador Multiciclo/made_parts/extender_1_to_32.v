module extender_1_to_32(
    input wire Data_in,
    output reg [31:0] Data_out
);

    assign Data_out = (Data_in) ? 32'b1 : 32'b0;

endmodule