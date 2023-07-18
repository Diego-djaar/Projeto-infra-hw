module update_UC(
    input wire [32:0] ALUOut,
    input wire igual,
    input wire maior,
    input wire menor,
    input wire UC_control, // Definir se vai enviar o valor pra UC ou não
    input wire [1:0] UC_op // Selecionar entre BEQ, BNE, BLE E BGT
    output wire update_UC_out
);

    always @(*)
    begin
        case (UC_op)
            2'b00:
            2'b01:
            2'b10:
            2'b11:
        endcase
    end

endmodule