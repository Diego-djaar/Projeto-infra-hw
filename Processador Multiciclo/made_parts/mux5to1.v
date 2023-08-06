module mux5to1 (
    input wire [1:0] selector,
    input wire [31:0] Data_0,
    input wire [31:0] Data_1,
    input wire [31:0] Data_2,
    input wire [31:0] Data_3,
    input wire [31:0] Data_4,
    output reg [31:0] Data_out
);
    always @(*)
    begin
        case (selector)
            2'b00: Data_out = Data_0;
            2'b01: Data_out = Data_1;
            2'b10: Data_out = Data_2;
            2'b11: Data_out = Data_3;
            // Faltando Data_4. Necessário aumentar o tamanho do seletor.
            default: Data_out = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx; // Default
        endcase
    end

endmodule