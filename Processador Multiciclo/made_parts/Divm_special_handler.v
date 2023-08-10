module Divm_special_handler(
    input wire clk,
    input wire reset,
    input wire [31:0] Memory,
    input wire [31:0] A,
    input wire [31:0] B,
    input wire [2:0] DivmOp,
    output wire [31:0] Mux_memory,
    output wire [31:0] A_out,
    output wire [31:0] B_out
);
    reg seletor_A;
    reg seletor_B;
    reg seletor_MEM;
    wire [31:0] A_in;
    reg A_w;
    wire [31:0] B_in;
    reg B_w;

    always @(posedge clk) begin
        case (DivmOp)
            0, 2: begin //Comum & // Enviar A para ler na memória
                seletor_A = 0;
                seletor_B = 0;
                seletor_MEM = 0;
                A_w = 0;
                B_w = 0;
            end
            1: begin // Escrever A e B nos registradores internos
                seletor_A = 0;
                seletor_B = 0;
                seletor_MEM = 0;
                A_w = 1;
                B_w = 1;
            end
            3: begin // Ler memória e por em Reg_A e enviar B para ler na memória
                seletor_A = 1;
                seletor_B = 0;
                seletor_MEM = 1;
                A_w = 1;
                B_w = 0;
            end
            4, 6: begin // Enviar B para ler na memória & // Ler ambos para dividr
                seletor_A = 0;
                seletor_B = 0;
                seletor_MEM = 1;
                A_w = 0;
                B_w = 0;
            end
            5: begin // Ler memória e por em Reg_B
                seletor_A = 0;
                seletor_B = 1;
                seletor_MEM = 0;
                A_w = 0;
                B_w = 1;
            end
            7: begin // Reset
                seletor_A = 0;
                seletor_B = 0;
                seletor_MEM = 0;
                A_w = 0;
                B_w = 0;
                //reset = 1;
            end
        endcase
    end

    Registrador A_(
        clk,
        reset,
        A_w,
        A_in,
        A_out
    );

    Registrador B_(
        clk,
        reset,
        B_w,
        B_in,
        B_out
    );


    mux2to1 mux_A(
        seletor_A,
        A,
        Memory,
        A_in
    );

    mux2to1 mux_B(
        seletor_B,
        B,
        Memory,
        B_in
    );

    mux2to1 mux_MEM_(
        seletor_MEM,
        A_out,
        B_out,
        Mux_memory
    );
endmodule