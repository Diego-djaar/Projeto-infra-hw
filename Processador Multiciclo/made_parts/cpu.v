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
    wire [2:0] Mux_PC;
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
    wire [2:0] DivmOp;
    
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

    wire exc_divby0;
    wire [31:0] HI_in;
    wire [31:0] HI_in_mult;
    wire [31:0] HI_in_div;
    wire [31:0] LO_in;
    wire [31:0] LO_in_mult;
    wire [31:0] LO_in_div;

    wire [31:0] ALUSrcA;
    wire [31:0] ALUSrcB;

    wire [3:0] ALUOp;
    wire SPECIAL;
    wire exc_overflow;
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

    mux5to1 mux_PC_(
        Mux_PC,
        ALUOut,
        ALU_REG_out,
        shift_PC_out,
        EPC_out,
        {{24{1'b0}},MEM_out[7:0]}, // 8 bits menos significativos, extendidos para 32
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
        32'd4, // 4
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
        exc_overflow,
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

    mux2to1 div_mult_hi_(
        DivOp | (DivmOp!=0),
        HI_in_mult,
        HI_in_div,
        HI_in
    );

    mux2to1 div_mult_lo_(
        DivOp | (DivmOp!=0),
        LO_in_mult,
        LO_in_div,
        LO_in
    );

    mult mult_(
        clk,
        reset,
        A_out,
        B_out,
        mult_control,
        HI_in_mult,
        LO_in_mult,
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

    wire unused;
    wire divisor_done;
    wire unused2;

    wire [31:0] Div_a;
    wire [31:0] Div_b;

    wire [31:0] Divm_a_out;
    wire [31:0] Divm_b_out;

    mux2to1 div_a_(
        DivmOp != 0,
        A_out,
        Divm_a_out,
        Div_a
    );

    mux2to1 div_b_(
        DivmOp != 0,
        B_out,
        Divm_b_out,
        Div_b
    );

    div divisor_(
        clk,
        reset | div_reset,
        DivOp,
        Div_a,
        Div_b,
        unused,
        divisor_done,
        exc_divby0,
        LO_in_div, // val in LO
        HI_in_div // rem in HI
    );

    Divm_special_handler divm_sh_(
        clk,
        reset,
        MEM_out,
        A_out,
        B_out,
        DivmOp,
        DIVM_out,
        Divm_a_out,
        Divm_b_out
    );

    control_unit control_unit_(
        clk,
        reset,
        Update_UC,
        OPCODE,
        OFFSET[5:0],
        divisor_done,
        {exc_overflow, exc_divby0},
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
