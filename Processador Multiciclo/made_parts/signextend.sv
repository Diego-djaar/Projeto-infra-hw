// sign extend 16-32
module signextend(
input wire [15:0] entrada, // instruction 15:0
output reg [31:0] saida
);

assign saida = (entrada[15]) ? {16'b1111111111111111, entrada} : {16'b0, entrada};

endmodule
