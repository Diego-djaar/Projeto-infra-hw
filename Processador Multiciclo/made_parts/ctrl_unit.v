module ctrl_unit(
    input wire clk,
    input wire reset,
    output reg reset_out
);

// Variáveis

reg [4:0] STATE;
reg [2:0] COUNTER;

// Parâmetros (Constantes)
    // Estados da FSM
    parameter ST_COMMON = 5'b00000;
    parameter ST_RESET = 5'b00001;
    parameter ST_ADD = 5'b00010;
    // Opcodes e functs
    parameter ADD = 6'b000000;

initial begin
    // Initial reset executado na máquina
    reset_out = 1'b1;
end

always @(posedge clk) begin
    if (reset == 1'b1) begin // Se reset for pressionado
        if (STATE != ST_RESET) begin
            STATE = ST_RESET;
            // Resetando todos os sinais

            rst_out = 1'b1;
            // Resetando o contador para 0
            COUNTER = 3'b000;
        end
        else begin
           STATE = ST_COMMON;
            // Resetando todos os sinais

            rst_out = 1'b0;
            // Resetando o contador para 0
            COUNTER = 3'b000;
        end
    end
    else begin
        case (STATE)
            ST_COMMON: begin
                
            end
        endcase
    end
end

endmodule