module LScontrol (
    input wire [31:0] Data_in,
    input wire [1:0] LS_control, // Selecionar entre LW, LH ou LB
    output reg [31:0] Data_out
);

    always @(*) begin
        case (LS_control)
            2'b00: Data_out = 32'b0;
            2'b01: Data_out = {24'b0, Data_in[7:0]}; // LB
            2'b10: Data_out = {16'b0, Data_in[15:0]}; // LH
            2'b11: Data_out = Data_in; // LW
        endcase
    end

endmodule