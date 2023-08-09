module mux_writedata(
    input wire [2:0] selector,
    input wire [31:0] Data_0,
    input wire [31:0] Data_1,
    input wire [31:0] Data_2,
    input wire [31:0] Data_3,
    input wire [31:0] Data_4,
    input wire [31:0] Data_5,
    output reg [31:0] Data_out
);
    always @(*) begin
        case (selector)
            3'b000: Data_out = Data_0; // ALUOut
            3'b001: Data_out = Data_1; // Load Size Control
            3'b010: Data_out = Data_2; // Memory Data Reg
            3'b011: Data_out = Data_3; // $HI
            3'b100: Data_out = Data_4; // $LO
            3'b101: Data_out = 32'd227; // $227
            3'b110: Data_out = Data_5; // ALUOut_reg
        endcase
    end

endmodule