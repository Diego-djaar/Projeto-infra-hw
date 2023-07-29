// cond sub 4
// corrijam se tiver errado
module cond_sub_4(
  input wire Break,
  input wire[31:0] PC,
  output reg [31:0] saida
);

  assign saida = (Break ? PC - 32'd4 : PC);
  
endmodule
