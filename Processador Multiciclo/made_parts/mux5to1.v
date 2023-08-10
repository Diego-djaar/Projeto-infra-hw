module mux5to1 (
    input wire [2:0] selector,
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
            3'b000: Data_out = Data_0;
            3'b001: Data_out = Data_1;
            3'b010: Data_out = Data_2;
            3'b011: Data_out = Data_3;
            3'b100: Data_out = Data_4;
            default: Data_out = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx; // Default
        endcase
    end

endmodule