module mult(
input wire [31:0] x,
input wire [31:0] y,
input wire clk,
input wire reset,
input wire mult_control, // Vai virar 0 quando a flag operando avisar pra unidade de controle que acabou a multiplicação
output reg [31:0] hi,
output reg [31:0] lo
output reg operando // Indica quando a operação acabou
);

reg [64:0] A;
reg [64:0] S;
reg [64:0] P;
integer n;

initial A = 65'b0;
initial S = 65'b0;
initial P = 65'b0;
initial operando = 0;  
initial cnt = 0;

always @(posedge clk)
begin
    if (!operando && mult_control) // mudar p código aluop de 4 bits
    begin
		operando = 1'b1;
	end

	if (reset) 
    begin
		A = 65'b0;
		S = 65'b0;
		P= 65'b0;
		hi = 32'b0;
		lo = 32'b0;
		n = 0;
        operando = 1'b0;
		fim = 1'b0;
	end
	
	if (operando) 
    begin	
		if(!n)
        begin
			A = {x, 32'b0, 1'b0};
			S = {~x+1, 32'b0, 1'b0};
			P = {32'b0 , y, 1'b0};
			P = P>>>1;
		end 
		else if(n == 32)
        begin
            hi = P[64:33];
			lo = P[32:1];
			n = 0;
			operando = 1'b1; // Entrada da unidade de controle pra saber o fim da operação
		end		 
		else 
        begin
			if(P[1:0] == 2'b01)
            begin
				P = P + A;
			end 
			else if(P[1:0]==2'b10)
            begin
				P = P + S;
			end
			P = P>>>1;

		end
		n = n+1;
    end	
end

endmodule
