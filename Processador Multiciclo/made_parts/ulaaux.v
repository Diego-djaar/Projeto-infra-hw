module ulaaux (
    input wire [31:0] A,
    input wire [31:0] B,
    input wire [0:1] ulaaux_control, // Operações a ser definidas
    output reg [31:0] ulaaux_out
);

    wire [31:0] A1;
    
    assign A1 = (ulaaux_control[0]) ? A << B : B; // Faz um shift left se for 10
    assign ulaaux_out = (ulaaux_control[1]) ? A >>> B : A1;  // e um shift right aritmetico se for 01

endmodule