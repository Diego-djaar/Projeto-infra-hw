module div(
input wire [31:0] a,
input wire [31:0] b,
input wire clk,
input wire reset,
input wire div_control,
output reg [31:0] hi,
output reg [31:0] lo,
output reg operando
);

reg [31:0] A;
reg [31:0] B;
reg signed [63:0] rem;
reg [63:0] quo;
reg neg;
  
reg [5:0] n;

parameter lim = {31{1'b1}};

initial n = 32;
initial hi = 32'b0;
initial lo = 32'b0;
initial operando = 1'b0;
initial A = 32'b0;
initial B = 32'b0;
initial rem = 64'b0;
initial quo = 64'b0;
initial neg = 1'b0;

  
always @(posedge clk)
begin
  if (!operando && div_control)
    begin
		operando = 1'b1;
		n = 32;
	end

	if (reset) 
    begin
		n = 32;
		hi = 32'b0;
		n = 32;
		hi = 32'b0;
		lo = 32'b0;
		operando = 1'b0;
		A = 32'b0;
		B = 32'b0;
		rem = 64'b0;
		quo = 64'b0;
		neg = 1'b0;
	end
	
	if (operando) 
    begin	
		if(n == 32) //comeco
        begin
			neg = 1'b0;
			if (a >= lim) neg = ~neg;
			if (b >= lim) neg = ~neg;
			A = a;
			rem = {{32'b0},A};
			B = b;
 		end 
		else if(n == 0) // fim
        begin
			if (neg)
			begin
				quo = ~quo+1;
			end
			hi = quo[63:32];
			lo = quo[31:0];
			operando = 1'b0;
		end		 
		else 
        begin
			// operacao de fato
			rem = rem - $signed(B);
			if (rem >= 0)
			begin
				quo = quo << 1;
				quo[0] = 1'b1;
			end
			else
			begin
				rem = rem + B;
				quo = quo << 1;
				quo[0] = 1'b0;
			end
			B = B >> 1;
		end
		n = n-1;
    end	
end

endmodule
