module logic_unit(
    input wire clk,
    input wire reset,
    input wire [32:0] ALUSrcA,
    input wire [32:0] ALUSrcB,
    input wire [4:0] SHAMT,
    input wire [3:0] ALUOp,
    output wire SPECIAL,
    output wire OVERFLOW,
    output wire ZERO,
    output wire [32:0] ALUOut,
    output wire Update_UC
);
    // Control wires
    wire [2:0] ALU_control;

    // Data wires
    wire [32:0] ALU_out;
    wire Of;
    wire Ng;
    wire Zr;
    wire Eq;
    wire Gt;
    wire Lt;


    // Criar um encoder pra traduzir ALUOp nas operações da ULA/SHIFTER

    ula32 ULA_(
        ALUSrcA,
        ALUSrcB,
        ALU_control,
        ALU_out,
        Of,
        Ng,
        Zr,
        Eq,
        Gt,
        Lt
    );

    RegDesloc SHIFTER_(

    );




endmodule