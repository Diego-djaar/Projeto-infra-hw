`timescale 1ns/1ps
//`include "design.sv"

module mult_tb();

reg [31:0] x;
reg [31:0] y;
reg clk;
reg reset;
reg mult_control;
output reg [31:0] hi;
output reg [31:0] lo;
output reg operando;
  
  integer i,j,cnt;
  
  
  
  mult UUT(
  .x(x),
  .y(y),
  .clk(clk),
  .reset(reset),
  .mult_control(mult_control),
  .lo(lo),
  .hi(hi),
  .operando(operando)
  );
  
always 
begin
    clk = 1'b1; 
    #1;

    clk = 1'b0;
    #1;
end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, mult_tb);
    
    mult_control = 1'b1;

    for (i = 1000000; i < 1010000; i = i + 1000)
      begin
        x = i;
        for (j = 7; j > -5; j = j - 1)
        begin
            y = j;
          	#500;
          $display("x = %d, y = %d, hi = %d, lo =  %d", $signed(x), $signed(y),  $signed(hi), $signed(lo));
          
        end
      end
   
    
    
    #5 $finish;
    
  end
 
endmodule