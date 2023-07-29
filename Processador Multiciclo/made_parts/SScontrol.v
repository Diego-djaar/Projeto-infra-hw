module SScontrol (
    input wire [31:0] B,
    input wire [31:0] MemDataReg,
    input wire [1:0] SS_control, // Selecionar entre SW, SH ou SB
    output reg [31:0] Data_out
);

    always @(*) begin
        case (SS_control)
            2'b00: Data_out = 32'b0;
            2'b01: Data_out = {MemDataReg[31:8], B[7:0]}; // SB
            2'b10: Data_out = {MemDataReg[31:16], B[15:0]}; // SH
            2'b11: Data_out = B; // SW
        endcase
    end

endmodule