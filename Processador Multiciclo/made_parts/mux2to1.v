module mux2to1 (
    input wire selector,
    input wire [31:0] Data_0, // 0
    input wire [31:0] Data_1, // 1
    output reg [31:0] Data_out
);
    assign Data_out = selector ? Data_1 : Data_0;

endmodule