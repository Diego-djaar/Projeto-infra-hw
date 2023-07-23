module ulaaux (
    input wire [31:0] A,
    input wire [31:0] B,
    input wire [1:0] ulaaux_control, // Operações a ser definidas
    output wire [31:0] ulaaux_out
);

    wire [31:0] A1;
    
    assign A1 = (ulaaux_control[0]) ? A << B : B;
    assign ulaaux_out = (ulaaux_control[1]) ? A >> B : A1; // Faz um shift left se for 0 e um shift right se for 1

endmodule