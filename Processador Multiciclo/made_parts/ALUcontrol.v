module ALUcontrol(
    input wire clk,
    input wire reset,
    input wire ALUOp,
    output wire [2:0] ALU_control,
    output wire [2:0] SHIFTER_control,
    output wire M_SHIFTER,
    output wire [1:0] M_ALUOut_control,
    output wire UC_control,
    output wire [1:0] UC_op
);
    // Como tudo aqui vai ser executado em um ciclo não é necessário usar um contador

    // Operações
    parameter NO_OP = 4'b0000; // equivalente a PASS_A
    parameter ADD = 4'b0001;
    parameter SUB = 4'b0010;
    parameter AND = 4'b0011;
    parameter PASS_B  = 4'b0100;
    parameter SHIFT_L1 = 4'b0101;
    parameter SHIFT_L2 = 4'b0110;
    parameter SHIFT_R = 4'b0111;
    parameter SHIFT_RA1 = 4'b1000;
    parameter SHIFT_RA2 = 4'b1001;
    parameter SLTI = 4'b1010;
    parameter BEQ = 4'b1011;
    parameter BNE = 4'b1100;
    parameter BLE = 4'b1101;
    parameter BGT = 4'1110;
    parameter LUI = 4'1111;

    always @(posedge clk) begin
        if (reset == 1'b1) begin
            ALU_control = 3'b000;
            SHIFTER_control = 3'b000;
            M_SHIFTER = 1'b0;
            M_ALUOut_control = 3'b00;
            UC_control = 1'b0;
            UC_op = 2'b00;
        end
        else begin
            if (ALUOp == NO_OP) begin
                ALU_control = 3'b000;
                SHIFTER_control = 3'b000;
                M_SHIFTER = 1'b0;
                M_ALUOut_control = 2'b01;
                UC_control = 1'b0;
                UC_op = 2'b00;
            end else if (ALUOp == ADD) begin
                ALU_control = 3'b001;
                SHIFTER_control = 3'b000;
                M_SHIFTER = 1'b0;
                M_ALUOut_control = 2'b01;
                UC_control = 1'b0;
                UC_op = 2'b00;
            end else if (ALUOp == SUB) begin
                ALU_control = 3'b010;
                SHIFTER_control = 3'b000;
                M_SHIFTER = 1'b0;
                M_ALUOut_control = 2'b01;
                UC_control = 1'b0;
                UC_op = 2'b00;
            end else if (ALUOp == AND) begin
                ALU_control = 3'b011;
                SHIFTER_control = 3'b000;
                M_SHIFTER = 1'b0;
                M_ALUOut_control = 2'b01;
                UC_control = 1'b0;
                UC_op = 2'b00;
            end else if (ALUOp == PASS_B) begin
                ALU_control = 3'b000;
                SHIFTER_control = 3'b000;
                M_SHIFTER = 1'b0;
                M_ALUOut_control = 2'b10;
                UC_control = 1'b0;
                UC_op = 2'b00;
            end else if (ALUOp == SHIFT_L1) begin
                ALU_control = 3'b000;
                SHIFTER_control = 3'b010;
                M_SHIFTER = 1'b0;
                M_ALUOut_control = 2'b10;
                UC_control = 1'b0;
                UC_op = 2'b00;
            end else if (ALUOp == SHIFT_L2) begin // ALUaux
                ALU_control = 3'b000;
                SHIFTER_control = 3'b010;
                M_SHIFTER = 1'b0;
                M_ALUOut_control = 2'b10;
                UC_control = 1'b0;
                UC_op = 2'b00;
            end else if (ALUOp == SHIFT_R) begin
                ALU_control = 3'b000;
                SHIFTER_control = 3'b011;
                M_SHIFTER = 1'b0;
                M_ALUOut_control = 2'b10;
                UC_control = 1'b0;
                UC_op = 2'b00;
            end else if (ALUOp == SHIFT_RA1) begin
                ALU_control = 3'b000;
                SHIFTER_control = 3'b100;
                M_SHIFTER = 1'b0;
                M_ALUOut_control = 2'b10;
                UC_control = 1'b0;
                UC_op = 2'b00;
            end else if (ALUOp == SHIFT_RA2) begin // ALUaux
                ALU_control = 3'b000;
                SHIFTER_control = 3'b010;
                M_SHIFTER = 1'b0;
                M_ALUOut_control = 2'b10;
                UC_control = 1'b0;
                UC_op = 2'b00;
            end else if (ALUOp == SLTI) begin
                ALU_control = 3'b111;
                SHIFTER_control = 3'b000;
                M_SHIFTER = 1'b0;
                M_ALUOut_control = 2'b11;
                UC_control = 1'b0;
                UC_op = 2'b00;
            end else if (ALUOp == BEQ) begin
                ALU_control = 3'b111;
                SHIFTER_control = 3'b000;
                M_SHIFTER = 1'b0;
                M_ALUOut_control = 2'b11;
                UC_control = 1'b1;
                UC_op = 2'b00;
            end else if (ALUOp == BNE) begin
                ALU_control = 3'b111;
                SHIFTER_control = 3'b000;
                M_SHIFTER = 1'b0;
                M_ALUOut_control = 2'b11;
                UC_control = 1'b1;
                UC_op = 2'b01;
            end else if (ALUOp == BLE) begin
                ALU_control = 3'b111;
                SHIFTER_control = 3'b000;
                M_SHIFTER = 1'b0;
                M_ALUOut_control = 2'b11;
                UC_control = 1'b1;
                UC_op = 2'b10;
            end else if (ALUOp == BGT) begin
                ALU_control = 3'b111;
                SHIFTER_control = 3'b000;
                M_SHIFTER = 1'b0;
                M_ALUOut_control = 2'b11;
                UC_control = 1'b1;
                UC_op = 2'b11;
            end else if (ALUOp == LUI) begin
                ALU_control = 3'b000;
                SHIFTER_control = 3'b010; // Shift left
                M_SHIFTER = 1'b1;
                M_ALUOut_control = 2'b10;
                UC_control = 1'b0;
                UC_op = 2'b00;
            end 
        end
    end

endmodule