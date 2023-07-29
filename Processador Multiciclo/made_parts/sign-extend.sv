// sign extend 16-32
module signextend(
input wire [15:0] entrada, // instruction 15:0
output reg [31:0] saida
);

always@(*)begin
  if (entrada[15]) begin
      saida = {16'd65535,entrada}; // 2^16-1 concatenado  
  end
  else begin
    saida = {16'b0, entrada};
  end
end

endmodule
