module logic_unit(
    input wire clk,
    input wire reset,
    input wire [31:0] ALUSrcA,
    input wire [31:0] ALUSrcB,
    input wire [4:0] SHAMT,
    input wire [3:0] ALUOp,
    output wire SPECIAL,
    output wire OVERFLOW,
    output wire ZERO,
    output wire [31:0] ALUOut,
    output wire Update_UC
);
    // Control wires
    wire [2:0] ALU_control;
    wire [2:0] SHIFTER_control;
    wire M_SHIFTER;
    wire [2:0] M_ALUOut_control;

    // Data wires
    wire [31:0] ALU_out;
    wire Of;
    wire Ng;
    wire Zr;
    wire Eq;
    wire Gt;
    wire Lt;
    wire [31:0] SHIFTER_out;
    wire [4:0] M_SHIFTER_out;
    wire [31:0] EXTEND_out;


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

    mux_shifter mux_shifter_(
        M_SHIFTER,
        SHAMT,
        M_SHIFTER_out
    );

    RegDesloc SHIFTER_(
        clk,
        reset,
        SHIFTER_control,
        M_SHIFTER_out,
        ALUSrcB,
        SHIFTER_out
    );

    extender_1_to_32 extender_1_to_32_(
        Lt,
        EXTEND_out
    );

    mux_ALUOut mux_ALUOut_(
        M_ALUOut_control,
        ALU_aux, // ainda n implementada
        ALU_out,
        SHIFTER_out,
        ALUSrcA,
        EXTEND_out
    );




endmodule