module ALUcontrol(
    input wire clk,
    input wire reset,
    input wire ALUOp,
    output wire [2:0] ALU_control;
    output wire [2:0] SHIFTER_control;
    output wire M_SHIFTER;
    output wire [2:0] M_ALUOut_control;
    output wire UC_control;
    output wire [1:0] UC_op;
);
    // Como tudo aqui vai ser executado em um ciclo não é necessário usar um contador

    // Operações
    parameter NO_OP = 4'b0000;
    parameter ADD = 4'b0001;
    parameter SUB = 4'b0010;
    parameter AND = 4'b0011;
    parameter PASS_A = 4'b0100;
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
            M_ALUOut_control = 3'b000;
            UC_control = 1'b0;
            UC_op = 2'b00;
        end
        else begin
            if (ALUOp == NO_OP) begin
                ALU_control = 3'b000;
                SHIFTER_control = 3'b000;
                M_SHIFTER = 1'b0;
                M_ALUOut_control = 3'b000;
                UC_control = 1'b0;
                UC_op = 2'b00;
            end
        end
    end

endmodule