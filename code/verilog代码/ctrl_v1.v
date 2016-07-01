`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:43:13 05/19/2016 
// Design Name: 
// Module Name:    ctrl 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ctrl(input  clk,
            input  reset,
            input  [31:0] Inst_in,
            input  zero,
            input  overflow,
            input  MIO_ready,
            output reg MemRead,
            output reg MemWrite,
            output reg[2:0]ALU_operation,
            output [4:0]state_out,
            
            output reg CPU_MIO,
            output reg IorD,
            output reg IRWrite,
            output reg [1:0]RegDst,
            output reg RegWrite,
            output reg [1:0]MemtoReg,
            output reg ALUSrcA,
            output reg [1:0]ALUSrcB,
            output reg [1:0]PCSource,
            output reg PCWrite,
            output reg PCWriteCond,
            output reg Branch
            );
parameter IF = 5'b00000, ID = 5'b00001, // _1, _2 The first 2 step 
          EX_R = 5'b00010, // _3 R-type execute
          EX_Mem = 5'b00011, // _3 Memory execute(compute)
          EX_I = 5'b00100, // _3 I-type execute
          Lui_WB = 5'b00101, // _3 Lui write back
          EX_beq = 5'b00110, EX_bne = 5'b00111,// _3 beq, bne execute
          EX_jr = 5'b01000, EX_JAL = 5'b01001, EX_J = 5'b01010,// _3 jr, jal, j execute
          MEM_RD=5'b01011, // memory load (MDR)
          MEM_WD = 5'b01100, // _4 memory write
          WB_R = 5'b01101, WB_I = 5'b01110, //_4 R-type, I-type write back
          WB_LW = 5'b01111,   // _5 LOAD 
          EX_JALR1 = 5'b10000, // for jalr
          EX_JALR2 = 5'b10001,
          ERROR = 5'b11111;

parameter AND = 3'b000, OR = 3'b001, ADD = 3'b010, SUB = 3'b110, NOR = 3'b100, SLT = 3'b111, XOR = 3'b011, SRL = 3'b101;
`define CPU_ctrl_signals {PCWrite, PCWriteCond, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource, ALUSrcB, ALUSrcA, RegWrite, RegDst, CPU_MIO}

reg [4:0] state;
wire [5:0] Fun, OP;
assign state_out = state;
assign Fun = Inst_in[5:0];
assign OP = Inst_in[31:26];

// Output signal
always @ (posedge clk or posedge reset) begin
    if(reset == 1) begin
        `CPU_ctrl_signals <= 17'b1_0010_1000_0010_0001;
        ALU_operation <= ADD;
        state <= IF;
    end
    else begin
        case(state)
            // The first step: instruction fetch
            IF: begin //0
                if(MIO_ready == 1) begin
                    `CPU_ctrl_signals <= 17'b0_0000_0000_0110_0000;
                    ALU_operation <= ADD;
                    state <= ID;
                end
                else begin
                    `CPU_ctrl_signals <= 17'b1_0010_1000_0010_0001;
                    state <= IF;
                end
            end 

            // The second step: instruction decode
            ID: begin 
                case(OP)
                    // R-type
                    6'b000000: begin
                        `CPU_ctrl_signals <= 17'b0_0000_0000_0001_0000;
                        state <= EX_R;
                        case (Fun)
                            // jr
                        6'b100000: ALU_operation <= ADD;
                        6'b100010: ALU_operation <= SUB;
                        6'b100100: ALU_operation <= AND;
                        6'b100101: ALU_operation <= OR;
                        6'b100111: ALU_operation <= NOR;
                        6'b101010: ALU_operation <= SLT;
                        6'b000010: ALU_operation <= SRL; 
                        6'b000000: ALU_operation <= XOR; 
                        6'b001000: begin
                                `CPU_ctrl_signals <= 17'b1_0000_0000_0001_0000;
                                ALU_operation <= ADD;
                                state <= EX_jr;
                        end
                            // jalr
                        6'b001001: begin
                                ALU_operation <= ADD;
                                `CPU_ctrl_signals <= 17'b0_0000_0000_0011_0000;
                                state <= EX_JALR1;
                        end
                        default:    ALU_operation <= ADD;
                        endcase
                    end
                    // Lw
                    6'b100011: begin //Lw
                        `CPU_ctrl_signals <= 17'b0_0000_0000_0101_0000;
                        ALU_operation <= ADD;               
                        state <= EX_Mem;
                    end
                    // SW
                    6'b101011: begin 
                        `CPU_ctrl_signals <= 17'b0_0000_0000_0101_0000;
                        ALU_operation <= ADD;                
                        state <= EX_Mem;
                    end
                    // Beq
                    6'b000100: begin
                        `CPU_ctrl_signals <= 17'b0_1000_0000_1001_0000;
                        ALU_operation <= SUB;
                        Branch <= 1;
                        state <= EX_beq;
                    end
                    // Bne
                    6'b000101: begin
                        `CPU_ctrl_signals <= 17'b0_1000_0000_1001_0000;
                        ALU_operation <= SUB;
                        Branch <= 0; // different from beq
                        state <= EX_beq;
                    end
                    // Jump
                    6'b000010: begin
                        `CPU_ctrl_signals <= 17'b1_0000_0001_0110_0000;
                        state <= EX_J;
                    end
                    // Jal
                    6'b000011: begin
                        `CPU_ctrl_signals <= 17'b1_0000_0111_0110_1100;
                        state <= EX_JAL;

                    end
                    // addi, andi, ori, xori
                    6'b001000: begin
                        `CPU_ctrl_signals <= 17'b0_0000_0000_0101_0000;
                        ALU_operation <= ADD; 
                        state <= EX_I;
                    end
                    // andi
                    6'b001100: begin
                        `CPU_ctrl_signals <= 17'b0_0000_0000_0101_0000;
                        ALU_operation <= AND; 
                        state <= EX_I;
                    end
                    // ori
                    6'b001101: begin
                        `CPU_ctrl_signals <= 17'b0_0000_0000_0101_0000;
                        ALU_operation <= OR; 
                        state <= EX_I;
                    end
                    // xori
                    6'b001110: begin
                        `CPU_ctrl_signals <= 17'b0_0000_0000_0101_0000;
                        ALU_operation <= XOR; 
                        state <= EX_I;
                    end
                    // Slti
                    6'b001010: begin
                        `CPU_ctrl_signals <= 17'b0_0000_0000_0101_0000;
                        ALU_operation <= SLT;
                        state <= EX_I;
                    end
                    // Lui
                    6'b001111: begin
                        `CPU_ctrl_signals <= 17'b0_0000_0100_0110_1000;
                        state <= Lui_WB;
                    end

                    default : begin
                        `CPU_ctrl_signals <= 17'b1_0010_1000_0010_0001;
                        state <= ERROR;
                    end
                endcase
			end
            // The third step: instruction dependent
            // R-type
            EX_R: begin
                `CPU_ctrl_signals <= 17'b0_0000_0000_0001_1010;
                state <= WB_R;
            end
            // Memory Ex
            EX_Mem: begin
                // Load
                if(OP == 6'b100011) begin
                    `CPU_ctrl_signals <= 17'b0_0110_0000_0101_0001;
                    state <= MEM_RD;
                end if (OP == 6'B101011) begin
                    `CPU_ctrl_signals <= 17'b0_0101_0000_0101_0001;
                    state <= MEM_WD;
                end
            end
            // I-type
            EX_I: begin
                `CPU_ctrl_signals <= 17'b0_0000_0000_0101_1000;
                state <= WB_I;
            end
            EX_JALR1: begin
                `CPU_ctrl_signals <= 17'b0_0000_0000_0000_1100;
                state <= EX_JALR2;
            end
            // instruction end of step 3
            EX_beq: begin
                `CPU_ctrl_signals <= 17'b1_0010_1000_0010_0001;
                ALU_operation <= ADD;
                state <= IF;
            end
			EX_bne: begin
                `CPU_ctrl_signals <= 17'b1_0010_1000_0010_0001;
                ALU_operation <= ADD;
                state <= IF;
            end
			EX_jr: begin
                `CPU_ctrl_signals <= 17'b1_0010_1000_0010_0001;
                ALU_operation <= ADD;
                state <= IF;
            end 
			EX_JAL: begin
                `CPU_ctrl_signals <= 17'b1_0010_1000_0010_0001;
                ALU_operation <= ADD;
                state <= IF;
            end 
			EX_J: begin
                `CPU_ctrl_signals <= 17'b1_0010_1000_0010_0001;
                ALU_operation <= ADD;
                state <= IF;
            end 
			MEM_WD: begin
                `CPU_ctrl_signals <= 17'b1_0010_1000_0010_0001;
                ALU_operation <= ADD;
                state <= IF;
            end
			Lui_WB: begin
                `CPU_ctrl_signals <= 17'b1_0010_1000_0010_0001;
                ALU_operation <= ADD;
                state <= IF;
            end
            
            
            // The forth step: R-type or memory-access
            // memory read
            MEM_RD: begin
                if(MIO_ready) begin
                    `CPU_ctrl_signals <= 17'b0_0000_0010_0000_1000;
                    state <= WB_LW;
                end
                else begin
                    `CPU_ctrl_signals <= 17'b0_0110_0000_0101_0000;
                    state <= MEM_RD;
                end
            end
            // memory wirte
            MEM_WD: begin
                if(MIO_ready) begin
                    `CPU_ctrl_signals <= 17'b1_0010_1000_0010_0001;
                    ALU_operation <= ADD;
                    state <= IF;
                end
                else begin
                    `CPU_ctrl_signals <= 17'b0_0101_0000_0101_0000;
                    state <= MEM_WD;
                end
            end
            WB_R: begin
                `CPU_ctrl_signals <= 17'b1_0010_1000_0010_0001;
                ALU_operation <= ADD;
                state <= IF;
            end
			WB_I: begin
                `CPU_ctrl_signals <= 17'b1_0010_1000_0010_0001;
                ALU_operation <= ADD;
                state <= IF;
            end 
            WB_LW: begin
                `CPU_ctrl_signals <= 17'b1_0010_1000_0010_0001;
                ALU_operation <= ADD;
                state <= IF;
            end
			EX_JALR2: begin
                `CPU_ctrl_signals <= 17'b1_0010_1000_0010_0001;
                ALU_operation <= ADD;
                state <= IF;
            end

            ERROR: begin state <= ERROR; end
			
            default: begin
                `CPU_ctrl_signals <= 17'b1_0010_1000_0010_0001;
                ALU_operation <= ADD;
                Branch <= 0;
                state <= ERROR;
            end
        endcase
	end
end
                
endmodule
