module ulaaux (
    input wire [31:0] A,
    input wire [31:0] B,
    input wire ulaaux_control, // Operações a ser definidas
    output wire [31:0] ulaaux_out
);

    assign ulaaux_out = (ulaaux_control) ? A >> B : A << B; // Faz um shift left se for 0 e um shift right se for 1

endmodule