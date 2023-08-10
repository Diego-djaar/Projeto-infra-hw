`timescale 1ps/1ps

module div_tb(
    output reg busy,
    output reg done,
    output reg dbz,
    output reg [31:0] val,
    output reg [31:0] rem
);
  
    reg clk;  
    reg rst;  
    reg start;
    reg [31:0] a;
    reg [31:0] b;


  integer i,j;
  
  div dut(
    .clk(clk),
    .rst(rst),
    .start(start),
    .busy(busy),
    .done(done),
    .dbz(dbz),
    .a(a),
    .b(b),
    .val(val),
    .rem(rem)
  );


 initial begin 
   clk = 0; 
   forever begin
    #1 clk = ~clk;
 end end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, div_tb);
    
    start = 1'b1;
    
	 for (i = 1000; i < 10000; i = i + 1000)
      begin
        #5 a <= i;
        for (j = 7; j > -5; j = j - 1)
        begin
            #5 b <= j;
          #200
          $display("i = %d, j = %d, val = %d, rem = %d",i,j,$signed(val),rem);
        end
      end
    // $display("quo: %d", $signed(val));
    
    #5 $finish;
    
  end
 
endmodule
