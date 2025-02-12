`include "made_parts/ALUcontrol.v"
module ctrl_unit (
    input wire clk,
    input wire reset_in,
    input wire update_uc,
    input wire [5:0] opcode,
    input wire [5:0] funct,
    output reg reset_out,
    output reg PC_w,
    output reg PC_w_cond,
    output reg EPC_w,
    output reg MEM_w,
    output reg IR_w,
    output reg [1:0] Mux_W_RB,
    output reg [2:0] Mux_W_DT,
    output reg [1:0] Mux_MEM,
    output reg [1:0] Mux_PC,
    output reg [1:0] Mux_ALUSrcA,
    output reg [1:0] Mux_ALUSrcB,
    output reg [1:0] Mux_EXC,
    output reg ALUOut_w,
    output reg Banco_reg_w,
    output reg A_reg_w,
    output reg B_reg_w,
    output reg HI_reg_w,
    output reg LO_reg_w,
    output reg MEM_DATA_REG_w,
    output reg mult_control,
    output reg mult_end,  // Entrada da UC
    output reg [1:0] LS_control,
    output reg [1:0] SS_control,
    output reg DivOp,
    output reg DivmOp,
    output reg ALUOp
);

  // Variáveis

  reg [5:0] STATE;
  reg [5:0] STATE_R;
  reg [2:0] COUNTER;

  // Parâmetros (Constantes)
  // Estados da FSM
  parameter ST_PC_MAIS_4 = 6'h3F;
  parameter ST_RESET = 6'h3E;
  // Opcodes e functs
  parameter ST_R = 6'h0;
  parameter STR_ADD = 6'h20;
  parameter STR_AND = 6'h24;
  parameter STR_DIV = 6'h1A;
  parameter STR_MULT = 6'h18;
  parameter STR_JR = 6'h8;
  parameter STR_MFHI = 6'h10;
  parameter STR_MFLO = 6'h12;
  parameter STR_SLL = 6'h0;
  parameter STR_SLLV = 6'h4;
  parameter STR_SLT = 6'h2A;
  parameter STR_SRA = 6'h3;
  parameter STR_SRAV = 6'h7;
  parameter STR_SRL = 6'h2;
  parameter STR_SUB = 6'h22;
  parameter STR_BREAK = 6'hD;
  parameter STR_RTE = 6'h13;
  parameter STR_DIVM = 6'h5;
  parameter ST_ADDI = 6'h8;
  parameter ST_ADDIU = 6'h9;
  parameter ST_BEQ = 6'h4;
  parameter ST_BNE = 6'h5;
  parameter ST_BLE = 6'h6;
  parameter ST_BGT = 6'h7;
  parameter ST_ADDM = 6'h1;
  parameter ST_LB = 6'h20;
  parameter ST_LH = 6'h21;
  parameter ST_LUI = 6'hf;
  parameter ST_LW = 6'h23;
  parameter ST_SB = 6'h28;
  parameter ST_SH = 6'h29;
  parameter ST_SLTI = 6'hA;
  parameter ST_SW = 6'h2B;
  parameter ST_J = 6'h2;
  parameter ST_JAL = 6'h3;

  // Controle de Memória, Instruções e Banco de Registradores
  parameter READ = 1'b0;
  parameter WRITE = 1'b1;

  initial begin
    // Initial reset executado na máquina
    reset_out = 1'b1;
  end

  always @(posedge clk) begin
    if (reset_in) begin  // Se reset for pressionado
      if (STATE != ST_RESET) begin
        STATE = ST_RESET;
        // Resetando todos os sinais
        PC_w = 1'b0;
        PC_w_cond = 1'b0;
        EPC_w = 1'b0;
        MEM_w = 1'b0;
        IR_w = 1'b0;
        Mux_W_RB = 2'b00;
        Mux_W_DT = 3'b000;
        Mux_MEM = 2'b00;
        Mux_PC = 2'b00;
        Mux_ALUSrcA = 2'b00;
        Mux_ALUSrcB = 2'b00;
        Mux_EXC = 2'b00;
        ALUOut_w = 1'b0;
        Banco_reg_w = 1'b0;
        A_reg_w = 1'b0;
        B_reg_w = 1'b0;
        HI_reg_w = 1'b0;
        LO_reg_w = 1'b0;
        MEM_DATA_REG_w = 1'b0;
        mult_control = 1'b0;
        mult_end = 1'b0;  // Entrada da UC
        LS_control = 2'b00;
        SS_control = 2'b00;
        DivOp = 1'b0;
        DivmOp = 1'b0;
        ALUOp = 4'b0000;
        reset_out = 1'b1;
        // Resetando o contador para 0
        COUNTER = 3'b000;
      end else begin
        STATE = ST_PC_MAIS_4;
        // Resetando todos os sinais
        PC_w = 1'b0;
        PC_w_cond = 1'b0;
        EPC_w = 1'b0;
        MEM_w = 1'b0;
        IR_w = 1'b0;
        Mux_W_RB = 2'b00;
        Mux_W_DT = 3'b000;
        Mux_MEM = 2'b00;
        Mux_PC = 2'b00;
        Mux_ALUSrcA = 2'b00;
        Mux_ALUSrcB = 2'b00;
        Mux_EXC = 2'b00;
        ALUOut_w = 1'b0;
        Banco_reg_w = 1'b0;
        A_reg_w = 1'b0;
        B_reg_w = 1'b0;
        HI_reg_w = 1'b0;
        LO_reg_w = 1'b0;
        MEM_DATA_REG_w = 1'b0;
        mult_control = 1'b0;
        mult_end = 1'b0;  // Entrada da UC
        LS_control = 2'b00;
        SS_control = 2'b00;
        DivOp = 1'b0;
        DivmOp = 1'b0;
        ALUOp = 4'b0000;
        reset_out = 1'b0;
        // Resetando o contador para 0
        COUNTER = 3'b000;
      end
    end else begin
      case (STATE)
        ST_PC_MAIS_4: begin
          case (COUNTER)
            0: begin  // soft reset e pc + 4
              PC_w = 1'b0;
              PC_w_cond = 1'b0;
              EPC_w = 1'b0;
              Mux_W_RB = 2'b00;
              Mux_W_DT = 3'b000;
              Mux_PC = 2'b00;
              Mux_EXC = 2'b00;
              ALUOut_w = 1'b0;
              Banco_reg_w = 1'b0;
              A_reg_w = 1'b0;
              B_reg_w = 1'b0;
              HI_reg_w = 1'b0;
              LO_reg_w = 1'b0;
              MEM_DATA_REG_w = 1'b0;
              mult_control = 1'b0;
              mult_end = 1'b0;  // Entrada da U = 0;
              LS_control = 2'b00;
              SS_control = 2'b00;
              DivOp = 1'b0;
              DivmOp = 1'b0;
              // PC + 4
              Mux_MEM = 1'b0;
              MEM_w = READ;
              IR_w = WRITE;
              Mux_ALUSrcA = 2'b00;
              Mux_ALUSrcB = 2'b01;
              ALUOp = ALUcontrol.ADD;  // O ADD do ALUcontrol
              Mux_PC = 2'b01;
              // Soma Counter
              COUNTER += 1;
            end
            1: begin  // Estado vazio, lendo a memória
              COUNTER += 1;
            end
            2: begin // Segundo ciclo
              // Ler instrução
              STATE   = opcode;
              STATE_R = funct;

              // Algumas instruções requerem algo aqui
              if (opcode == ST_ADDI ||
                  opcode == ST_ADDIU ||
                  opcode == ST_ADDM ||
                  opcode == ST_SLTI ||
                  opcode == ST_LW ||
                  opcode == ST_LB ||
                  opcode == ST_LH ||
                  opcode == ST_SW ||
                  opcode == ST_SB ||
                  opcode == ST_SH ||
                  opcode == ST_LUI ||
                  (opcode == ST_R && 
                  (funct == STR_ADD ||
                   funct == STR_AND ||
                   funct == STR_SUB ||
                   funct == STR_SRAV ||
                   funct == STR_SLT ||
                   funct == STR_SLLV)
                  ))
                Mux_W_RB = 2'b00;
              else if (opcode == ST_R && (funct == STR_MFHI || funct == STR_MFLO)) begin
                Mux_W_RB = 2'b01;
                Mux_W_DT = funct == STR_MFHI? 3'b011 : 3'b100;
                Banco_reg_w = WRITE;
              end


              // Escreve no PC
              IR_w = READ;
              PC_w = 1'b1;
              COUNTER = 0;
            end
          endcase
        end
        ST_R: begin

        end
      endcase
    end
  end

endmodule
