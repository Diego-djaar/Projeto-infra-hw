module div(
    input wire reset,
    input wire aluop, // presumindo sinal de um bit, ajeitar dps
    input wire clk,
  input wire [31:0] x, 
  input wire [31:0] y,
    output reg fim,
    output reg div_zero,
  output reg [31:0] lo,
  output reg [31:0] hi
);

reg [63:0] b; // y
reg [63:0] quo;
reg signed [63:0] rem;
integer n;
reg operando;
reg neg;

parameter lim = {31{1'b1}};
initial n = 32;



always @(posedge clk) 
begin
    if (aluop && !reset)
    begin 
        operando = 1'b1;
    end
    if (reset) 
    begin 
      	div_zero = 1'b0;
        n = 32;
      	neg = 1'b0;
        b = 64'b0;
        quo = 64'b0;
        rem = 64'b0;
        operando = 1'b0;
    end
  if (operando && !div_zero) // tá certo botar verificação de div 0 aqui?
    begin
        if (n == 32) // começo
        begin
          rem = {{32{1'b0}},x};
          b = {{32{1'b0}},y};
          if (b == 0)
          begin
            // tem que interromper ou só sinalizar?
            div_zero = 1'b1;
          end
            neg = 1'b0;
          if (x >= lim)
            begin
                rem = ~rem+1; // operar como se fosse positivo
                neg = ~neg;
            end
          if (y >= lim)
            begin
                b = ~b+1; // operar como positivo
                neg = ~neg;
            end
            quo = 64'b0;
        end
        else if (n == 0) // fim
        begin
            // lógica sinalizada
            if (neg)
            begin
                quo = ~quo+1;
            end
            hi = quo[63:32];
            lo = quo[31:0];
            fim = 1'b1;
            operando = 1'b0;
        end
        else // operação
        begin 
            rem = $signed(rem - b);
            if (rem < 0)
            begin
                rem = rem + b;
                quo = quo << 1;
                quo[0] = 1'b0;
            end
            else
            begin
                quo = quo << 1;
                quo[0]=1'b1;
            end
            b = b >> 1;
        end
        n = n-1;
    end

end


    
endmodule
