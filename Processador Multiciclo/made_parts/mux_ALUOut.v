module mux_ALUOut(
    input wire [1:0] selector,
    input wire [31:0] Data_0, // ALUresult AUX
    input wire [31:0] Data_1, // ALUresult
    input wire [31:0] Data_2, // SHIFTER
    input wire [31:0] Data_3, // 1-32 bit extender
    output wire [31:0] Data_out // ALUOut
);

    always @(*)
    begin
        case (selector)
            2'b00: Data_out = Data_0; // ALUresult AUX
            2'b01: Data_out = Data_1; // ALUresult
            2'b10: Data_out = Data_2; // SHIFTER
            2'b11: Data_out = Data_3; // 1-32 bit extender
            default: Data_out = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx; // Default
        endcase
    end

endmodule