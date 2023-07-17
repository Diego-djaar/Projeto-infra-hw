module mux_ALUOut(
    input wire [2:0] selector,
    input wire [31:0] Data_0, // ALUresult AUX
    input wire [31:0] Data_1, // ALUresult
    input wire [31:0] Data_2, // SHIFTER
    input wire [31:0] Data_3, // ALUSourceA
    input wire [31:0] Data_4, // 1-32 bit extender
    output wire [31:0] Data_out // ALUOut
);

    always @(*)
    begin
        case (selector)
            3'b000: Data_out = Data_0; // ALUresult AUX
            3'b001: Data_out = Data_1; // ALUresult
            3'b010: Data_out = Data_2; // SHIFTER
            3'b011: Data_out = Data_3; // ALUSourceA
            3'b100: Data_out = Data_4; // 1-32 bit extender
            default: Data_out = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx; // Default
        endcase
    end

endmodule