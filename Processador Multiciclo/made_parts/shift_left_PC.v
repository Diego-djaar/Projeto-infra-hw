module shift_left_PC (
    input wire [25:0] Instruction,
    input wire [3:0] PC, // PC[31:28]
    output wire [31:0] Data_out
);

    wire [27:0] A1;

    assign A1 = Instruction << 2;
    assign Data_out = {PC, A1};

endmodule