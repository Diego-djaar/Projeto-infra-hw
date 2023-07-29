module mux_writereg(
    input wire selector,
    input wire [4:0] Data_0,
    input wire [15:0] Data_1,
    output reg [4:0] Data_out
);

    assign Data_out = (selector) ? Data_1[15:11] : Data_0; // Falta adicionar os registradores $29 e $31 como entradas

endmodule