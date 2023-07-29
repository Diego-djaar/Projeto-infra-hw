module mult(
input wire [31:0] x,
input wire [31:0] y,
input wire clk,
input wire reset,
input wire mult_control, // Vai virar 0 quando a flag osperando avisar pra unidade de controle que acabou a multiplicação
output reg [31:0] hi,
output reg [31:0] lo,
output reg operando // Indica quando a operação acabou
);

  
parameter lim = {31{1'b1}}; // 2^31

integer a,m,q;
reg q0;
integer n;

reg neg;
reg [63:0] res;   
  
initial n = 32;
initial q0 = 0;
initial m = 0;
initial a = 0;
initial q = 0;
initial operando = 0;

always @(posedge clk)
begin
    if (!operando && mult_control) // mudar p código aluop de 4 bits
    begin
		operando = 1'b1;
		n = 32;
	end

	if (reset) 
    begin
		n = 32;
		q0 = 0;
		m = 0;
		a = 0;
		q = 0;
		operando = 0;  
	end
	
	if (operando) 
    begin	
		if(n == 32) //começo
        begin
          m = x;
          q = y;
          neg = 1'b0;
          if (m >= lim) 
          begin
            neg = ~neg;
            m = ~m+1;
          end
          if (q >= lim) 
          begin
            neg = ~neg;
            q = ~q+1;
          end
		    q0 = 0;
			a = 0;
		end 
		else if(n == 0) // fim
        begin
          res = {a,q};
          if (neg) begin res = ~res+1; end;
          lo = res[31:0];
          hi = res[63:32];
		  operando = 1'b0;
          $display(res);
		end		 
		else 
        begin
			if (q[0] && !q0)
			begin
				a = a-m;
			end
			else if (!q[0] && q0)
			begin
				a = a+m;
			end
			q0 = q[0];
			q[31] =a[0];
			a = a>>>1;
			q = q>>>1;
		end
		n = n-1;
    end	
end

endmodule
