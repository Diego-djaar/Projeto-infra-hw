module cpu(
    input wire clk,
    input wire reset
);

    // Control wires
    wire PC_w;
    wire MEM_w;
    wire IR_w;
    wire M_WREG;
    wire RB_w;
    wire AB_w;
    wire MEM_DATA_REG_w;

    //Data wires
    wire [31:0] ULA_out;
    wire [31:0] PC_out;

    wire [31:0] MEM_in;
    wire [31:0] MEM_to_IR;
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


    Registrador PC_(
        clk,
        reset,
        PC_w,
        ULA_out, // Mudar pra o mux do PC
        PC_out
    );

    Memoria MEM_(
        PC_out,
        clk,
        MEM_w,
        MEM_in, // Usado apenas no store (vindo da store size control)
        MEM_to_IR
    );

    Instr_Reg IR_(
        clk,
        reset,
        IR_w,
        MEM_to_IR,
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

    Registrador MEM_DATA_REG_(
        clk,
        reset,
        MEM_DATA_REG_w,
        MEM_to_IR,
        MEM_DATA_REG_out
    );


endmodule