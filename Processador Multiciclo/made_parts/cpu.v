module cpu(
    input wire clk,
    input wire reset
);

    // Control wires
    wire PC_w;
    wire EPC_w;
    wire MEM_w;
    wire IR_w;
    wire [1:0] M_WREG;
    wire [1:0] M_MEM;
    wire [1:0] M_PC;
    wire [1:0] M_ALUSrcA;
    wire [1:0] M_ALUSrcB;
    wire [1:0] M_EXC;
    wire ALUOut_w;
    wire RB_w;
    wire AB_w;
    wire MEM_DATA_REG_w;
    wire mult_control;
    wire mult_end; // Entrada da UC
    wire [1:0] LS_control;
    wire [1:0] SS_control;

    //Data wires
    wire [31:0] ULA_out;
    wire [31:0] PC_out;

    wire [31:0] MEM_adress;

    wire [31:0] MEM_in;
    wire [31:0] MEM_out;
    wire [5:0] OPCODE;
    wire [4:0] RS;
    wire [4:0] RT;
    wire [15:0] OFFSET;

    wire [4:0] WRITEREG_in;

    wire [31:0] RB_to_A;
    wire [31:0] RB_to_B;

    wire [31:0] A_out;
    wire [31:0] B_out;
    wire [31:0] MEM_DATA_REG_out;

    wire [31:0] hi_in;
    wire [31:0] lo_in;

    wire [31:0] ALUSrcA;
    wire [31:0] ALUSrcB;

    wire [3:0] ALUOp;
    wire SPECIAL;
    wire OVERFLOW;
    wire ZERO;
    wire [31:0] ALUOut;
    wire Update_UC;

    wire [31:0] ALU_REG_out;

    wire [31:0] extend_out;
    wire [31:0] shift_out;
    wire [31:0] shift_PC_out;

    wire [31:0] M_PC_out;
    wire [31:0] EPC_out;
    wire [31:0] DIVM_out;
    wire [31:0] M_exc_out;


    mux4to1 mux_PC_(
        M_PC,
        ALUOut,
        ALU_REG_out,
        shift_PC_out,
        EPC_out,
        M_PC_out
    );

    Registrador PC_(
        clk,
        reset,
        PC_w,
        M_PC_out,
        PC_out
    );

    registrador EPC_(
        clk,
        reset,
        EPC_w,
        ALU_REG_out,
        EPC_out
    );

    mux3to1 mux_EXC_(
        M_EXC,
        32'd253,
        32'd254,
        32'd255,
        M_exc_out
    );

    mux4to1 mux_MEM_(
        M_MEM,
        PC_out,
        ALU_REG_out,
        DIVM_out,
        M_exc_out,
        MEM_adress
    );

    Memoria MEM_(
        MEM_adress,
        clk,
        MEM_w,
        MEM_in, // Usado apenas no store (vindo da store size control)
        MEM_out
    );

    Instr_Reg IR_(
        clk,
        reset,
        IR_w,
        MEM_out,
        OPCODE,
        RS,
        RT,
        OFFSET
    );

    mux_writereg M_WREG_(
        M_WREG,
        RT,
        OFFSET,
        WRITEREG_in
    );

    Banco_reg REG_BASE_(
        clk,
        reset,
        RB_w,
        RS,
        RT,
        WRITEREG_in,
        ULA_out,
        RB_to_A,
        RB_to_B
    );

    Registrador A_(
        clk,
        reset,
        AB_w,
        RB_to_A,
        A_out
    );

    Registrador B_(
        clk,
        reset,
        AB_w,
        RB_to_B,
        B_out
    );

    mux3to1 mux_ALUSrcA_(
        M_ALUSrcA,
        PC_out,
        A_out,
        MEM_out,
        ALUSrcA
    );

    signextend signextend_(
        OFFSET,
        extend_out
    );

    shift_left_2 shiftleft2_( // mux ALUSrcB
        extend_out,
        shift_out
    );

    shift_left_PC shiftleft_PC_( // mux PC
        {RS, RD, OFFSET}, // Instruction[25:0]
        PC[31:28], // PC[31:28]
        shift_PC_out
    );

    mux4to1 mux_ALUSrcB_(
        M_ALUSrcB,
        B_out,
        32'd4, // Não sei se pode isso
        extend_out,
        shift_out,
        ALUSrcB
    );

    logic_unit logic_unit_(
        clk,
        reset,
        ALUSrcA,
        ALUSrcB,
        OFFSET[15:11], // SHAMT
        ALUOp, // 4 bits
        SPECIAL,
        OVERFLOW,
        ZERO,
        ALUOut,
        Update_UC
    );

    Registrador ALUOutreg_(
        clk,
        reset,
        ALUOut_w,
        ALUOut,
        ALU_REG_out
    );

    Registrador MEM_DATA_REG_(
        clk,
        reset,
        MEM_DATA_REG_w,
        MEM_out,
        MEM_DATA_REG_out
    );

    mult mult_(
        clk,
        reset,
        A_out,
        B_out,
        mult_control,
        hi_in,
        lo_in,
        mult_end
    );

    LScontrol LScontrol_(
        MEM_DATA_REG_out,
        LS_control,
        LScontrol_out
    );

    SScontrol SScontrol_(
        B_out,
        MEM_DATA_REG_out,
        SS_control,
        MEM_in
    );

endmodule