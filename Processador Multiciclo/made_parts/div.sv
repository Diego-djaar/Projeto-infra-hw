//`timescale 1ns/1ps
module div(
    input wire clk,  
    input wire rst,  
    input wire start,
    input wire [31:0] a,
  	input wire [31:0] b,
    output reg busy,
    output reg done,
    output reg dbz,
	output reg [31:0] val,
    output reg [31:0] rem
    );

  reg [31:0] quo;
  reg [32:0] acc;
  reg [31:0] A;
  reg [31:0] B;
  reg [31:0] rem_temp;
  reg [6:0] i;
  reg neg;
  reg numerador_neg;

initial busy = 1'b0; // -------- mais 

    always @(posedge clk) begin
        done = 0;
      if (start && !busy) begin
            i =0;
        if (b == 0) begin // divisão por zero
                busy = 0;
                done = 1;
                dbz = 1;
            end else begin // começo ---------------
              	neg = 1'b0;
                busy = 1;
                dbz = 0;
              	numerador_neg = 1'b0;
              if (b[31] == 1) begin neg = ~neg; B = ~b+1; end
              else begin B = b; end
              if (a[31] == 1) begin neg = ~neg; A = ~a+1; numerador_neg = 1'b1;end
              else begin A = a; end
              {acc, quo} ={{32{1'b0}}, A, 1'b0};
            end
        end else if (busy) begin
          if (i == 32) begin  // fim ------------------
                busy = 0;
                done = 1;
            if (neg) begin val = ~quo+1; end
            else begin val = quo; end
            rem_temp = acc[31:1];
            if (numerador_neg) begin rem_temp = ~rem_temp + 1; end
            rem = rem_temp;
          end else begin  // operação ------------------
                i =i + 1;
            	if (acc >= {1'b0, B}) begin
              		acc = acc - B;
            		{acc, quo} = {acc[31:0], quo, 1'b1};
          		end else begin
              		{acc, quo} = {acc, quo} << 1;
          		end
            end
        end
        if (rst) begin
            busy =0;
            done =0;
            dbz =0;
            val =0;
            rem =0;
        end
    end
endmodule
