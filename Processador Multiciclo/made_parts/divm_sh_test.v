module divm_sh_test(
    input wire clk
);

reg [31:0] A;
reg [31:0] B;
reg [2:0] DivmOp;
reg reset;

wire [31:0] Mux_memory;
wire [31:0] A_out;
wire [31:0] B_out;

reg [31:0] Memory;
reg write_mem;

always @(posedge clk) if(write_mem) Memory = Mux_memory + 707;

initial begin
    A = 14;
    B = 23;
    DivmOp = 0;
    reset = 0;
    write_mem = 0;
    @(posedge clk);
    reset = 1;
    @(posedge clk);
    @(posedge clk);
    reset = 0;
    @(posedge clk);
    DivmOp = 1;
    @(posedge clk);
    DivmOp = 2;
    write_mem = 1;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    DivmOp = 3;
    write_mem = 0;
    @(posedge clk);
    @(posedge clk);
    DivmOp = 4;
    write_mem = 1;
    @(posedge clk);
    write_mem = 0;
    DivmOp = 5;
    @(posedge clk);
    DivmOp = 6;
end

Divm_special_handler divm_(
    clk,
    reset,
    Memory,
    A,
    B,
    DivmOp,
    Mux_memory,
    A_out,
    B_out
);

endmodule