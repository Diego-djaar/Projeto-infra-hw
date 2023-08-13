module update_UC_gate(
    input wire igual,
    input wire maior,
    input wire UC_control, // Definir se vai enviar o valor pra UC ou não
    input wire [1:0] UC_op, // Selecionar entre BEQ, BNE, BLE E BGT
    output reg update_UC_out
);
        
        initial begin
            update_UC_out = 1'b0;
        end
        
        always @(UC_control)
        begin
            update_UC_out = 1'b0;
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