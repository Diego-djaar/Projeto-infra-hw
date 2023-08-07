module mux_writereg(
    input wire [1:0] selector,
    input wire [4:0] Data_0,
    input wire [15:0] Data_1,
    output reg [4:0] Data_out
);
    always @(*) begin
        case (selector)
            2'b00: Data_out = Data_0; // rt
            2'b01: Data_out = Data_1[15:11]; // rd
            2'b10: Data_out = 5'b11101; // $29
            2'b11: Data_out = 5'b11111; // $31
        endcase
    end
    //assign Data_out = (selector) ? Data_1[15:11] : Data_0; // Falta adicionar os registradores $29 e $31 como entradas

endmodule