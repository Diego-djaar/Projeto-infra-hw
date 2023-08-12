module logic_unit(
    input wire clk,
    input wire reset,
    input wire [31:0] ALUSrcA,
    input wire [31:0] ALUSrcB,
    input wire [4:0] SHAMT,
    input wire [3:0] ALUOp,
    input wire [1:0] COUNTER,
    output reg SPECIAL,
    output wire OVERFLOW,
    output reg ZERO,
    output wire [31:0] ALUOut,
    output wire Update_UC
);
    // Control wires
    wire [2:0] ALU_control;
    wire [2:0] SHIFTER_control;
    wire M_SHIFTER;
    wire [2:0] M_ALUOut_control;
    wire UC_control;
    wire [1:0] UC_op;
    wire [1:0] ulaaux_control;

    // Data wires
    wire [31:0] ALUResult; // Saída da ULA
    wire Of;
    wire Ng;
    wire Zr;
    wire Eq;
    wire Gt;
    wire Lt;
    wire [31:0] SHIFTER_out;
    wire [4:0] M_SHIFTER_out;
    wire [31:0] EXTEND_out;
    wire [31:0] ALU_aux;


    // Criar um encoder pra traduzir ALUOp nas operações da ULA/SHIFTER

    ula32 ULA_(
        ALUSrcA,
        ALUSrcB,
        ALU_control,
        ALUResult,
        OVERFLOW,
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

    mux5to1 mux_ALUOut_(
        M_ALUOut_control,
        ALU_aux,
        ALUResult,
        SHIFTER_out,
        EXTEND_out,
        ALUSrcA,
        ALUOut
    );

    update_UC_gate update_UC_(
        Eq,
        Gt,
        UC_control,
        UC_op,
        Update_UC
    );

    ulaaux ulaaux_(
        ALUSrcA,
        ALUSrcB,
        ulaaux_control,
        ALU_aux
    );

    ALUcontrol ALUcontrol_(
        clk,
        reset,
        ALUOp,
        COUNTER,
        ALU_control,
        SHIFTER_control,
        M_SHIFTER,
        M_ALUOut_control,
        UC_control,
        UC_op,
        ulaaux_control
    );


endmodule