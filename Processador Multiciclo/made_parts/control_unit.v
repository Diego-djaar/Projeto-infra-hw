`include "ALUcontrol.v"
module control_unit (
    input wire clk,
    input wire reset_in,
    input wire update_uc,
    input wire [5:0] opcode,
    input wire [5:0] funct,
    input wire divisor_done,
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
    output reg DivReset,
    output reg [2:0] DivmOp,
    output reg [3:0] ALUOp
);

  // Variáveis

  reg [5:0] STATE;
  reg [5:0] STATE_R;
  reg [3:0] COUNTER;

  // Parâmetros (Constantes)
  // Estados da FSM
  parameter ST_PC_MAIS_4 = 6'h3F;
  parameter ST_RESET = 6'h3E;
  parameter ST_WAIT_MEM = 6'h3D;
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

  // Operações do ALUcontrol
    parameter NO_OP = 4'b0000; // equivalente a PASS_A
    parameter ADD = 4'b0001;
    parameter SUB = 4'b0010;
    parameter AND = 4'b0011;
    parameter PASS_B = 4'b0100; // Passa pela ULAaux
    parameter SHIFT_L1 = 4'b0101;
    parameter SHIFT_L2 = 4'b0110;
    parameter SHIFT_R = 4'b0111;
    parameter SHIFT_RA1 = 4'b1000;
    parameter SHIFT_RA2 = 4'b1001;
    parameter SLTI = 4'b1010;
    parameter BEQ = 4'b1011;
    parameter BNE = 4'b1100;
    parameter BLE = 4'b1101;
    parameter BGT = 4'b1110;
    parameter LUI = 4'b1111;

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
        DivReset = 1'b1;
        DivmOp = 3'b000;
        ALUOp = 4'b0000;
        reset_out = 1'b1;
        // Resetando o contador para 0
        COUNTER = 4'b0000;
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
        DivReset = 1'b1;
        DivmOp = 3'b000;
        ALUOp = 4'b0000;
        reset_out = 1'b0;
        // Resetando o contador para 0
        COUNTER = 4'b0000;
      end
    end else begin
      case (STATE)
        ST_RESET: begin
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
          DivReset = 1'b1;
          DivmOp = 3'b000;
          ALUOp = 4'b0000;
          reset_out = 1'b0;
          // Resetando o contador para 0
          COUNTER = 4'b0000;
        end
        ST_PC_MAIS_4: begin
          case (COUNTER)
            0: begin  // soft reset e pc + 4
              PC_w = 1'b0;
              PC_w_cond = 1'b0;
              EPC_w = 1'b0;
              Mux_W_RB = 2'b00;
              Mux_W_DT = 3'b000;
              //Mux_PC = 2'b00;
              Mux_EXC = 2'b00;
              //ALUOut_w = 1'b0;
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
              DivReset = 1'b1;
              DivmOp = 3'b000;
              // PC + 4
              Mux_MEM = 1'b0;
              MEM_w = READ;
              IR_w = WRITE;
              Mux_ALUSrcA = 2'b00;
              Mux_ALUSrcB = 2'b01;
              ALUOp = ADD;  // O ADD do ALUcontrol
              ALUOut_w = WRITE;
              Mux_PC = 2'b01;
              // Soma Counter
              COUNTER = COUNTER + 1;
            end
            1: begin  // Estado vazio, lendo a memória
              COUNTER = COUNTER + 1;
            end
            2: begin  // Segundo ciclo
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
                  opcode == ST_LUI
                  )
                Mux_W_RB = 2'b00;
              else if (opcode == ST_R && 
                  (funct == STR_ADD ||
                   funct == STR_AND ||
                   funct == STR_SUB ||
                   funct == STR_SRAV ||
                   funct == STR_SLT ||
                   funct == STR_SLLV)
                  ) Mux_W_RB = 2'b01;
              else if (opcode == ST_R && (funct == STR_MFHI || funct == STR_MFLO)) begin
                Mux_W_RB = 2'b01;
                Mux_W_DT = funct == STR_MFHI ? 3'b011 : 3'b100;
                Banco_reg_w = WRITE;
              end else if (opcode == ST_R && (
                  funct == STR_SLL || funct == STR_SRA || funct == STR_SRL)) begin
                Mux_W_RB = 2'b01;
                Mux_W_DT = 3'b000;
              end else if (opcode == ST_J || opcode == ST_JAL) begin
                Mux_PC = 2'b10;
                PC_w = WRITE;
                if (opcode == ST_J) STATE = ST_PC_MAIS_4;  // Volta para o PC+4
                else begin
                  Mux_W_RB = 2'b11;
                  Mux_W_DT = 3'b110;
                  Banco_reg_w = WRITE;
                end
              end else if (opcode == ST_R && funct == STR_RTE) begin
                Mux_PC = 2'b11;
                PC_w   = WRITE;
                STATE  = ST_PC_MAIS_4;  // Volta para o PC+4
              end


              // Escreve no PC
              ALUOut_w = READ;
              IR_w = READ;
              PC_w = WRITE;
              COUNTER = 0;
            end
          endcase
        end
        ST_R: begin // Instruções do tipo R
            case (STATE_R)
                STR_ADD, STR_AND, STR_SUB, STR_SLT: begin // CONCLUÍDO 
                    case (COUNTER)
                        0: begin
                            A_reg_w = WRITE;
                            B_reg_w = WRITE;
                            COUNTER = COUNTER + 1;
                        end
                        1: begin
                            Mux_ALUSrcA = 2'b01;
                            Mux_ALUSrcB = 2'b00;
                            ALUOp = STATE_R == STR_ADD ? ADD :
                                              STATE_R == STR_AND ? AND :
                                              STATE_R == STR_SLT ? SLTI :
                                              STATE_R == STR_SUB ? SUB : 4'b0000;
                            COUNTER = COUNTER + 1;
                        end
                        2: begin
                            A_reg_w = READ;
                            B_reg_w = READ;
                            Mux_W_DT = 3'b000;
                            Banco_reg_w = WRITE;
                            COUNTER = COUNTER + 1;
                        end
                        3: begin // Esperar escrever
                            COUNTER = COUNTER + 1;
                        end
                        4: begin // Ir para pc mais 4
                            COUNTER = 0;
                            STATE = ST_PC_MAIS_4;
                        end
                    endcase
                end
                STR_SRAV, STR_SLLV: begin // Operações de shift na aluaux CONCLUÍDO
                  case (COUNTER)
                        0: begin
                            A_reg_w = WRITE;
                            B_reg_w = WRITE;
                            COUNTER = COUNTER + 1;
                        end
                        1: begin
                            Mux_ALUSrcA = 2'b01;
                            Mux_ALUSrcB = 2'b00;
                            ALUOp = STATE_R == STR_SRAV ? SHIFT_RA2 : // shift direita aritmetico
                                              STATE_R == STR_SLLV ? SHIFT_L2 : 4'b0000; // shift esquerda
                            COUNTER = COUNTER + 1;
                        end
                        2: begin // Esperar o shifter operar (2 ciclos)
                            COUNTER = COUNTER + 1;
                        end
                        3: begin
                            A_reg_w = READ;
                            B_reg_w = READ;
                            Mux_W_DT = 3'b000;
                            Banco_reg_w = WRITE;
                            COUNTER = COUNTER + 1;
                        end
                        4: begin // Esperar escrever
                            COUNTER = COUNTER + 1;
                        end
                        5: begin // Ir para pc mais 4
                            COUNTER = 0;
                            STATE = ST_PC_MAIS_4;
                        end
                    endcase
                end
                STR_SLL, STR_SRA, STR_SRL: begin
                    case (COUNTER)
                        0: begin
                            B_reg_w = WRITE;
                            COUNTER = COUNTER + 1;
                        end
                        1: begin
                            Mux_ALUSrcB = 2'b00;
                            ALUOp = STATE_R == STR_SLL ? SHIFT_L1 :
                                              STR_SRA ?  SHIFT_RA1:
                                              STR_SRL ? SHIFT_R : 4'b0000;
                            COUNTER = COUNTER + 1;
                        end
                        2: begin
                            B_reg_w = READ;
                            Mux_W_DT = 3'b000;
                            Banco_reg_w = WRITE;
                            COUNTER = COUNTER + 1;
                        end
                        3: begin // Esperar escrever
                            COUNTER = COUNTER + 1;
                        end
                        4: begin // Ir para pc mais 4
                            COUNTER = 0;
                            STATE = ST_PC_MAIS_4;
                        end
                    endcase
                end
                STR_JR: begin // CONCLUÍDO
                    case (COUNTER)
                        0: begin
                            A_reg_w = WRITE;
                            COUNTER = COUNTER + 1;
                        end
                        1: begin
                            Mux_ALUSrcA = 2'b01;
                            ALUOp = 4'b0000; // NO_OP que é equivalente a PASS_A
                            COUNTER = COUNTER + 1;
                        end
                        2: begin
                            A_reg_w = READ;
                            Mux_PC = 2'b00;
                            PC_w = 1'b1;
                            COUNTER = COUNTER + 1;
                        end
                        3: begin // Esperar escrever no PC
                            COUNTER = COUNTER + 1;
                        end
                        4: begin // Ir para pc mais 4
                            COUNTER = 0;
                            PC_w = 1'b0;
                            STATE = ST_PC_MAIS_4;
                        end
                  endcase
                end
                STR_RTE: begin
                    case(COUNTER)
                        0: begin
                            Mux_PC = 2'b11;
                            PC_w = 1'b1;
                            COUNTER = COUNTER + 1;
                        end
                        1: begin
                            COUNTER = 0;
                            STATE = ST_PC_MAIS_4; // O reset do PC_w vai ser feito no ST_PC_MAIS_R
                        end
                    endcase
                end
                STR_MFHI, STR_MFLO: begin // CONCLUÍDO
                  case (COUNTER)
                    0: begin
                      // Basta esperar escrever
                      COUNTER = COUNTER + 1;
                    end
                    1: begin
                      COUNTER = 0;
                      STATE = ST_PC_MAIS_4;
                    end
                  endcase
                end
                STR_BREAK: begin // CONCLUÍDO
                  case(COUNTER)
                    0: begin // Faz PC menos 4
                      PC_w = READ;
                      Mux_ALUSrcA = 2'b00;
                      Mux_ALUSrcB = 2'b01;
                      ALUOp = SUB;
                      COUNTER = COUNTER + 1;
                      ALUOut_w = WRITE;
                      Mux_PC = 2'b01;
                    end
                    1: COUNTER = COUNTER + 1; // Escreve em ALUOut_w
                    2: begin // Escreve no PC
                      ALUOut_w = READ;
                      PC_w = WRITE;
                      COUNTER = COUNTER + 1;
                    end
                    3: begin // Espera escrever
                      COUNTER = COUNTER + 1;
                    end
                    4: begin 
                      STATE = ST_PC_MAIS_4;
                      PC_w = READ;
                      COUNTER = 0;
                    end
                  endcase
                end
                STR_DIV: begin
                  case (COUNTER)
                        0: begin
                          A_reg_w = WRITE;
                          B_reg_w = WRITE;
                          COUNTER = COUNTER + 1;
                          DivReset = 1'b1;
                        end
                        1: begin // Inicia divisão
                          DivReset = 1'b0;
                          DivOp = 1;
                          COUNTER = COUNTER + 1;
                        end
                        2: begin // Agora esperar até divisor done
                          if (divisor_done) COUNTER = COUNTER + 1;
                        end
                        3: begin // Escreve o resultado em HI e LO
                          HI_reg_w = WRITE;
                          LO_reg_w = WRITE;
                          COUNTER = COUNTER + 1;
                        end
                        4: begin // Escrito
                          HI_reg_w = READ;
                          LO_reg_w = READ;
                          DivOp = 0;
                          DivReset = 1;
                          COUNTER = 0;
                          STATE = ST_PC_MAIS_4;
                        end
                  endcase
                end
                STR_DIVM: begin
                  case (COUNTER)
                    0: begin // Escrever nos registradores A e B
                      A_reg_w = WRITE;
                      B_reg_w = WRITE;
                      COUNTER = COUNTER + 1;
                      DivReset = 1'b1;
                    end
                    1: begin // Escrever A e B nos registradores internos
                      DivmOp = 1;
                      Mux_MEM = 2'b10; // divm_sh
                      COUNTER = COUNTER + 1;
                    end
                    2: begin // Enviar A para ler na memória
                      DivmOp = 2;
                      COUNTER = COUNTER + 1;
                    end
                    3: begin // Esperar ler
                      COUNTER = COUNTER + 1;
                    end
                    4: begin // Ler memória e por em Reg_A e enviar B para ler na memória
                      DivmOp = 3;
                      COUNTER = COUNTER + 1;
                    end
                    5: begin // Espera atualizar memória
                      DivmOp = 4;
                      COUNTER = COUNTER + 1;
                    end
                    6: begin // Esperar ler
                      COUNTER = COUNTER + 1;
                    end
                    7: begin // Ler memória e por em Reg_B
                      DivmOp = 5;
                      COUNTER = COUNTER + 1;
                    end
                    8: begin // Ler ambos para dividir
                    DivmOp = 6;
                      COUNTER = COUNTER + 1;
                    end
                    9: begin // Inicia divisão
                      DivReset = 1'b0;
                      DivOp = 1;
                      COUNTER = COUNTER + 1;
                    end
                    10: begin // Agora esperar até divisor done
                      if (divisor_done) COUNTER = COUNTER + 1;
                    end
                    11: begin // Escreve o resultado em HI e LO
                      HI_reg_w = WRITE;
                      LO_reg_w = WRITE;
                      COUNTER = COUNTER + 1;
                    end
                    12: begin // Escrito
                      HI_reg_w = READ;
                      LO_reg_w = READ;
                      DivOp = 0;
                      DivReset = 1;
                      COUNTER = 0;
                      DivmOp = 01;
                      STATE = ST_WAIT_MEM;
                    end
                  endcase
                end
            endcase
        end
        ST_WAIT_MEM: begin // Espera 2 ciclos para a memória ser escrita com PC
          case (COUNTER)
            0: begin
              Mux_MEM = 2'b00;
              COUNTER = COUNTER + 1;
            end
            1: begin
              COUNTER = 0;
              STATE = ST_PC_MAIS_4;
            end
          endcase
        end
        ST_JAL: begin // CONCLUÍDO
          case(COUNTER)
            0: begin 
              // 1 ciclo para escrever
              COUNTER = COUNTER + 1;
            end
            1: begin
              Banco_reg_w = READ;
              STATE = ST_PC_MAIS_4;
              COUNTER = 0;
            end
          endcase
        end
        ST_J: begin // CONCLUÍDO
          case (COUNTER)
            0: begin
              Mux_PC = 2'b10;
              PC_w = 1'b1;
              COUNTER = COUNTER + 1;
            end
            1: begin
              STATE = ST_PC_MAIS_4;
              COUNTER = 0;
            end
          endcase
        end
      endcase
    end
  end
endmodule
