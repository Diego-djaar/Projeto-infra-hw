module cpu(
    input wire clk,
    input wire reset
);

    wire RESET_OUT;

    // Control wires
    wire PC_w;
    wire PC_w_cond;
    wire EPC_w;
    wire MEM_w;
    wire IR_w;
    wire [1:0] Mux_W_RB;
    wire [2:0] Mux_W_DT;
    wire [1:0] Mux_MEM;
    wire [1:0] Mux_PC;
    wire [1:0] Mux_ALUSrcA;
    wire [1:0] Mux_ALUSrcB;
    wire [1:0] Mux_EXC;
    wire ALUOut_w;
    wire RB_w;
    wire A_w;
    wire B_w;
    wire HI_w;
    wire LO_w;
    wire MEM_DATA_REG_w;
    wire mult_control;
    wire mult_end; // Entrada da UC
    wire [1:0] LS_control;
    wire [31:0] LScontrol_out;
    wire [1:0] SS_control;
    wire DivOp;
    wire div_reset;
    wire DivmOp;
    
    //Data wires
    wire [31:0] ULA_out;
    wire [31:0] PC_out;

    wire [31:0] MEM_adress;

    wire [31:0] MEM_in;
    wire [31:0] MEM_out;
    wire [5:0] OPCODE;
    wire [4:0] RS;
    wire [4:0] RT;
    wire [4:0] RD;
    wire [15:0] OFFSET;
    assign RD = OFFSET[15:11];

    wire [4:0] WRITEREG_in;

    wire [31:0] RB_to_A;
    wire [31:0] RB_to_B;

    wire [31:0] A_out;
    wire [31:0] B_out;
    wire [31:0] MEM_DATA_REG_out;

    wire [31:0] HI_in;
    wire [31:0] LO_in;

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

    wire [31:0] Mux_PC_out;
    wire [31:0] EPC_out;
    wire [31:0] DIVM_out;
    wire [31:0] Mux_exc_out;
    wire [31:0] extend2_out;
    wire [31:0] Mux_W_DATA_out;
    wire [31:0] HI_out;
    wire [31:0] LO_out;

    mux4to1 mux_PC_(
        Mux_PC,
        ALUOut,
        ALU_REG_out,
        shift_PC_out,
        EPC_out,
        Mux_PC_out
    );

    Registrador PC_(
        clk,
        reset,
        PC_w,
        Mux_PC_out,
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
        Mux_EXC,
        32'd253,
        32'd254,
        32'd255,
        Mux_exc_out
    );

    LScontrol extend8_32_( // Reutilizando componente para criar um extensor de 8 pra 32 bits
        MEM_out,
        2'b01,
        extend2_out
    );

    mux4to1 mux_MEM_(
        Mux_MEM,
        PC_out,
        ALU_REG_out,
        DIVM_out,
        Mux_exc_out,
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

    mux_writereg Mux_W_RB_(
        Mux_W_RB,
        RT,
        OFFSET,
        WRITEREG_in
    );


    mux_writedata Mux_W_DT_(
        Mux_W_DT,
        ALUOut,
        LScontrol_out,
        MEM_DATA_REG_out,
        HI_out,
        LO_out,
        ALU_REG_out,
        Mux_W_DATA_out
    );

    Banco_reg REG_BASE_(
        clk,
        reset,
        RB_w,
        RS,
        RT,
        WRITEREG_in,
        Mux_W_DATA_out,
        RB_to_A,
        RB_to_B
    );

    Registrador A_(
        clk,
        reset,
        A_w,
        RB_to_A,
        A_out
    );

    Registrador B_(
        clk,
        reset,
        B_w,
        RB_to_B,
        B_out
    );

    Registrador HI_(
        clk,
        reset,
        HI_w,
        HI_in,
        HI_out
    );

    Registrador LO_(
        clk,
        reset,
        LO_w,
        LO_in,
        LO_out
    );

    mux3to1 mux_ALUSrcA_(
        Mux_ALUSrcA,
        PC_out,
        A_out,
        extend2_out, // Bit menos significativo da memória
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
        PC_out[31:28], // PC[31:28]
        shift_PC_out
    );

    mux4to1 mux_ALUSrcB_(
        Mux_ALUSrcB,
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

    // mult mult_(
    //     clk,
    //     reset,
    //     A_out,
    //     B_out,
    //     mult_control,
    //     HI_in,
    //     LO_in,
    //     mult_end
    // );

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

    wire unused;
    wire divisor_done;
    wire unused2;
    div divisor(
        clk,
        reset | div_reset,
        DivOp,
        A_out,
        B_out,
        unused,
        divisor_done,
        unused2,
        LO_in, // val in LO
        HI_in // rem in HI
    );

    control_unit control_unit_(
        clk,
        reset,
        Update_UC,
        OPCODE,
        OFFSET[5:0],
        divisor_done,
        RESET_OUT,
        PC_w,
        PC_w_cond,
        EPC_w,
        MEM_w,
        IR_w,
        Mux_W_RB,
        Mux_W_DT,
        Mux_MEM,
        Mux_PC,
        Mux_ALUSrcA,
        Mux_ALUSrcB,
        Mux_EXC,
        ALUOut_w,
        RB_w,
        A_w,
        B_w,
        HI_w,
        LO_w,
        MEM_DATA_REG_w,
        mult_control,
        mult_end,
        LS_control,
        SS_control,
        DivOp,
        div_reset,
        DivmOp,
        ALUOp
    );
endmodule
