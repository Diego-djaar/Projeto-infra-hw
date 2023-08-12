module ALUcontrol(
    input wire clk,
    input wire reset,
    input wire [3:0] ALUOp,
    input wire [1:0] COUNTER,
    output reg [2:0] ALU_control,
    output reg [2:0] SHIFTER_control,
    output reg M_SHIFTER,
    output reg [2:0] M_ALUOut_control,
    output reg UC_control,
    output reg [1:0] UC_op,
    output reg [1:0] ulaaux_control
);
    // Com excessão das operações de shift, todas as operações são feitas em um ciclo
    // Portanto, é necessário criar o reg STATE, que só vai ser alterado se o COUNTER for 0 (significa que não estã no meio de nenhuma op)
    // MUDADO: isso já é levado em consideração na control unit e ta causando bug
    reg [3:0] STATE;

    // Operações
    parameter NO_OP = 4'b0000; // equivalente a PASS_A
    parameter ADD = 4'b0001;
    parameter SUB = 4'b0010;
    parameter AND = 4'b0011;
    parameter PASS_B = 4'b0100; // Passa pela ULAaux
    parameter SHIFT_L1 = 4'b0101;
    parameter SHIFT_L2 = 4'b0110;
    parameter SHIFT_R = 4'b0111;
    parameter SHIFT_RA1 = 4'b1000;
    parameter SHIFT_RA2 = 4'b1001;
    parameter SLTI = 4'b1010;
    parameter BEQ = 4'b1011;
    parameter BNE = 4'b1100;
    parameter BLE = 4'b1101;
    parameter BGT = 4'b1110;
    parameter LUI = 4'b1111;

    always @(posedge clk) begin
        
        STATE = ALUOp;

        if (reset == 1'b1) begin
            ALU_control = 3'b000;
            SHIFTER_control = 3'b000;
            M_SHIFTER = 1'b0;
            M_ALUOut_control = 3'b000;
            UC_control = 1'b0;
            UC_op = 2'b00;
            ulaaux_control = 2'b00;
        end else begin
            case (STATE)
                NO_OP : begin
                    ALU_control = 3'b000;
                    SHIFTER_control = 3'b000;
                    M_SHIFTER = 1'b0;
                    M_ALUOut_control = 3'b001;
                    UC_control = 1'b0;
                    UC_op = 2'b00;
                    ulaaux_control = 2'b00;
                end 
                ADD : begin
                    ALU_control = 3'b001;
                    SHIFTER_control = 3'b000;
                    M_SHIFTER = 1'b0;
                    M_ALUOut_control = 3'b001;
                    UC_control = 1'b0;
                    UC_op = 2'b00;
                    ulaaux_control = 2'b00;
                end 
                SUB : begin
                    ALU_control = 3'b010;
                    SHIFTER_control = 3'b000;
                    M_SHIFTER = 1'b0;
                    M_ALUOut_control = 3'b001;
                    UC_control = 1'b0;
                    UC_op = 2'b00;
                    ulaaux_control = 2'b00;
                end 
                AND : begin
                    ALU_control = 3'b011;
                    SHIFTER_control = 3'b000;
                    M_SHIFTER = 1'b0;
                    M_ALUOut_control = 3'b001;
                    UC_control = 1'b0;
                    UC_op = 2'b00;
                    ulaaux_control = 2'b00;
                end
                PASS_B : begin
                    ALU_control = 3'b000;
                    SHIFTER_control = 3'b000;
                    M_SHIFTER = 1'b0;
                    M_ALUOut_control = 3'b000; // Saída da ulaaux
                    UC_control = 1'b0;
                    UC_op = 2'b00;
                    ulaaux_control = 2'b00;
                end
                SHIFT_L1 : begin
                    if (COUNTER == 0) begin
                        ALU_control = 3'b000;
                        SHIFTER_control = 3'b001; // load no shifter
                        M_SHIFTER = 1'b0;
                        M_ALUOut_control = 3'b010;
                        UC_control = 1'b0;
                        UC_op = 2'b00;
                        ulaaux_control = 2'b00;
                    end else if (COUNTER == 1) begin // Operação
                        SHIFTER_control = 3'b010;
                    end else begin // Nada
                        SHIFTER_control = 3'b000;
                    end
                end
                SHIFT_L2 : begin // ALUaux
                    ALU_control = 3'b000;
                    SHIFTER_control = 3'b000;
                    M_SHIFTER = 1'b0;
                    M_ALUOut_control = 3'b000;
                    UC_control = 1'b0;
                    UC_op = 2'b00;
                    ulaaux_control = 2'b10;
                end
                SHIFT_R : begin
                    if (COUNTER == 0) begin
                        ALU_control = 3'b000;
                        SHIFTER_control = 3'b001; // load no shifter
                        M_SHIFTER = 1'b0;
                        M_ALUOut_control = 3'b010;
                        UC_control = 1'b0;
                        UC_op = 2'b00;
                        ulaaux_control = 2'b00;
                    end else if (COUNTER == 1) begin // Operação
                        SHIFTER_control = 3'b011;
                    end else begin // Nada
                        SHIFTER_control = 3'b000;
                    end
                end
                SHIFT_RA1 : begin
                    if (COUNTER == 0) begin
                        ALU_control = 3'b000;
                        SHIFTER_control = 3'b001; // load no shifter
                        M_SHIFTER = 1'b0;
                        M_ALUOut_control = 3'b010;
                        UC_control = 1'b0;
                        UC_op = 2'b00;
                        ulaaux_control = 2'b00;
                    end else if (COUNTER == 1) begin // Operação
                        SHIFTER_control = 3'b100;
                    end else begin // Nada
                        SHIFTER_control = 3'b000;
                    end
                end
                SHIFT_RA2 : begin // ALUaux
                    
                    ALU_control = 3'b000;
                    SHIFTER_control = 3'b000;
                    M_SHIFTER = 1'b0;
                    M_ALUOut_control = 3'b000;
                    UC_control = 1'b0;
                    UC_op = 2'b00;
                    ulaaux_control = 2'b01;
                end
                SLTI : begin
                    ALU_control = 3'b111;
                    SHIFTER_control = 3'b000;
                    M_SHIFTER = 1'b0;
                    M_ALUOut_control = 3'b011;
                    UC_control = 1'b0;
                    UC_op = 2'b00;
                    ulaaux_control = 2'b00;
                end
                BEQ : begin
                    ALU_control = 3'b111;
                    SHIFTER_control = 3'b000;
                    M_SHIFTER = 1'b0;
                    M_ALUOut_control = 3'b011;
                    UC_control = 1'b1;
                    UC_op = 2'b00;
                    ulaaux_control = 2'b00;
                end
                BNE : begin
                    ALU_control = 3'b111;
                    SHIFTER_control = 3'b000;
                    M_SHIFTER = 1'b0;
                    M_ALUOut_control = 3'b011;
                    UC_control = 1'b1;
                    UC_op = 2'b01;
                    ulaaux_control = 2'b00;
                end
                BLE : begin
                    ALU_control = 3'b111;
                    SHIFTER_control = 3'b000;
                    M_SHIFTER = 1'b0;
                    M_ALUOut_control = 3'b011;
                    UC_control = 1'b1;
                    UC_op = 2'b10;
                    ulaaux_control = 2'b00;
                end
                BGT : begin
                    ALU_control = 3'b111;
                    SHIFTER_control = 3'b000;
                    M_SHIFTER = 1'b0;
                    M_ALUOut_control = 3'b011;
                    UC_control = 1'b1;
                    UC_op = 2'b11;
                    ulaaux_control = 2'b00;
                end
                LUI : begin
                    if (COUNTER == 0) begin
                        ALU_control = 3'b000;
                        M_SHIFTER = 1'b1;
                        SHIFTER_control = 3'b001; // load no shifter
                        M_ALUOut_control = 3'b010;
                        UC_control = 1'b0;
                        UC_op = 2'b00;
                        ulaaux_control = 2'b00;
                    end else if (COUNTER == 1) begin // Operação
                        SHIFTER_control = 3'b010;
                    end else begin // Nada
                        SHIFTER_control = 3'b000;
                    end
                end
            endcase
        end
    end

endmodule