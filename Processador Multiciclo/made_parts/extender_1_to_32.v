module extender_1_to_32(
    input wire Data_in,
    output wire [31:0] Data_out
);

    assign Data_out = (Data_in) ? {32{1'b1}} : {32{1'b0}};

endmodule