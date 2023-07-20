module update_UC(
    input wire [32:0] ALUOut,
    input wire igual,
    input wire maior,
    input wire menor,
    input wire UC_control, // Definir se vai enviar o valor pra UC ou não
    input wire [1:0] UC_op, // Selecionar entre BEQ, BNE, BLE E BGT
    output wire update_UC_out
);

        always @(*)
        begin
            update_UC_out = 1'b0; // Não sei se essa linha é necessária
            if (UC_control == 1'b1) begin
                case (UC_op)
                    2'b00: update_UC_out = (igual) ? 1'b1 : 1'b0; // BEQ
                    2'b01: update_UC_out = (igual) ? 1'b0 : 1'b1; // BNE
                    2'b10: update_UC_out = (maior) ? 1'b0 : 1'b1; // BLE
                    2'b11: update_UC_out = (maior) ? 1'b1 : 1'b0; // BGT
                endcase
            end
        end

endmodule