`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   08:11:24 05/28/2016
// Design Name:   M_datapath
// Module Name:   F:/cache/OExp12-MSOC/code/Mdatapath_test.v
// Project Name:  OExp12-MSOC
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: M_datapath
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Mdatapath_test;

	// Inputs
	reg clk;
	reg reset;
	reg MIO_ready;
	reg IorD;
	reg IRWrite;
	reg [1:0] RegDst;
	reg RegWrite;
	reg [1:0] MemtoReg;
	reg ALUSrcA;
	reg [1:0] ALUSrcB;
	reg [1:0] PCSource;
	reg PCWrite;
	reg PCWriteCond;
	reg Branch;
	reg [2:0] ALU_operation;
	reg [31:0] data2CPU;

	// Outputs
	wire [31:0] PC_Current;
	wire [31:0] Inst;
	wire [31:0] data_out;
	wire [31:0] M_addr;
	wire zero;
	wire overflow;
	wire [31:0] ALU_Out;
	wire [31:0] SrcA_out;
	wire [31:0] SrcB_out;
	
	
`define CPU_ctrl_signals {PCWrite, PCWriteCond, IorD, IRWrite, MemtoReg, PCSource, ALUSrcB, ALUSrcA, RegWrite, RegDst}
parameter AND = 3'b000, OR = 3'b001, ADD = 3'b010, SUB = 3'b110, NOR = 3'b100, SLT = 3'b111, XOR = 3'b011, SRL = 3'b101;

	// Instantiate the Unit Under Test (UUT)
	M_datapath uut (
		.clk(clk), 
		.reset(reset), 
		.MIO_ready(MIO_ready), 
		.IorD(IorD), 
		.IRWrite(IRWrite), 
		.RegDst(RegDst), 
		.RegWrite(RegWrite), 
		.MemtoReg(MemtoReg), 
		.ALUSrcA(ALUSrcA), 
		.ALUSrcB(ALUSrcB), 
		.PCSource(PCSource), 
		.PCWrite(PCWrite), 
		.PCWriteCond(PCWriteCond), 
		.Branch(Branch), 
		.ALU_operation(ALU_operation), 
		.PC_Current(PC_Current), 
		.data2CPU(data2CPU), 
		.Inst(Inst), 
		.data_out(data_out), 
		.M_addr(M_addr), 
		.ALU_Out(ALU_Out),
		.SrcA_out(SrcA_out),
		.SrcB_out(SrcB_out),
		.zero(zero), 
		.overflow(overflow)
	);
always #50 clk = ~clk;
	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;
		MIO_ready = 1;
		IorD = 0;
		IRWrite = 0;
		RegDst = 0;
		RegWrite = 0;
		MemtoReg = 0;
		ALUSrcA = 0;
		ALUSrcB = 0;
		PCSource = 0;
		PCWrite = 0;
		PCWriteCond = 0;
		Branch = 0;
		ALU_operation = 0;
		data2CPU = 0;

		// Wait 100 ns for global reset to finish
		#100;
		reset = 0;
        //#### Nor: nor $r1, $r0, $r0; R1 = alu_out = 32'hFFFF_FFFF
		// 1. IF:
		data2CPU = 32'b000000_00000_00000_00001_00000_100111;
		`CPU_ctrl_signals = 14'b1_00_1000_0010_000;
        ALU_operation = ADD;
		#100;
		//2. ID:
		`CPU_ctrl_signals = 14'b0_00_0000_0110_000;
        ALU_operation = ADD;
		#100;
		//3. Nor_Exe
		`CPU_ctrl_signals = 14'b0_00_0000_0001_000;
		ALU_operation = NOR;
		#100;
		//4. WB_R
		`CPU_ctrl_signals = 14'b0_00_0000_0001_101;
		#100;
		
		//#### slt: slt $r2, $r0, $r1; R2 = alu_out = 32'h0000_0001
		// 1. IF:
		data2CPU = 32'b000000_00000_00001_00010_00000_101010;
		`CPU_ctrl_signals = 14'b1_00_1000_0010_000;
        ALU_operation = ADD;
		#100;
		//2. ID:
		`CPU_ctrl_signals = 14'b0_00_0000_0110_000;
        ALU_operation = ADD;
		#100;
		//3. Slt_Exe
		`CPU_ctrl_signals = 14'b0_00_0000_0001_000;
		ALU_operation = SLT;
		#100;
		//4. WB_R
		`CPU_ctrl_signals = 14'b0_00_0000_0001_101;
		#100;
		
		//#### 3. add: add $r3, $r2, $r2; R3 = alu_out = 32'h0000_0002
		// 1. IF:
		data2CPU = 32'b000000_00010_00010_00011_00000_100000;
		`CPU_ctrl_signals = 14'b1_00_1000_0010_000;
        ALU_operation = ADD;
		#100;
		//2. ID:
		`CPU_ctrl_signals = 14'b0_00_0000_0110_000;
        ALU_operation = ADD;
		#100;
		//3. ADD_Exe
		`CPU_ctrl_signals = 14'b0_00_0000_0001_000;
		ALU_operation = ADD;
		#100;
		//4. WB_R
		`CPU_ctrl_signals = 14'b0_00_0000_0001_101;
		#100;
		
		//#### 4. sub: sub $r4, $r0, $r3; R4 = alu_out = 32'hffff_fffe
		// 1. IF:
		data2CPU = 32'b000000_00000_00011_00100_00000_100010;
		`CPU_ctrl_signals = 14'b1_00_1000_0010_000;
        ALU_operation = ADD;
		#100;
		//2. ID:
		`CPU_ctrl_signals = 14'b0_00_0000_0110_000;
        ALU_operation = ADD;
		#100;
		//3. Sub_Exe
		`CPU_ctrl_signals = 14'b0_00_0000_0001_000;
		ALU_operation = SUB;
		#100;
		//4. WB_R
		`CPU_ctrl_signals = 14'b0_00_0000_0001_101;
		#100;
		
		//#### 5. and: and $r5, $r3, $r4; R5 = alu_out = 32'h0000_0002
		// 1. IF:
		data2CPU = 32'b000000_00100_00011_00101_00000_100100;
		`CPU_ctrl_signals = 14'b1_00_1000_0010_000;
        ALU_operation = ADD;
		#100;
		//2. ID:
		`CPU_ctrl_signals = 14'b0_00_0000_0110_000;
        ALU_operation = ADD;
		#100;
		//3. AND_Exe
		`CPU_ctrl_signals = 14'b0_00_0000_0001_000;
		ALU_operation = AND;
		#100;
		//4. WB_R
		`CPU_ctrl_signals = 14'b0_00_0000_0001_101;
		#100;
		
		//#### 6. or: or $r6, $r2, $r4; R6 = alu_out = 32'hffff_ffff
		// 1. IF:
		data2CPU = 32'b000000_00100_00010_00110_00000_010110;
		`CPU_ctrl_signals = 14'b1_00_1000_0010_000;
        ALU_operation = ADD;
		#100;
		//2. ID:
		`CPU_ctrl_signals = 14'b0_00_0000_0110_000;
        ALU_operation = ADD;
		#100;
		//3. or_Exe
		`CPU_ctrl_signals = 14'b0_00_0000_0001_000;
		ALU_operation = OR;
		#100;
		//4. WB_R
		`CPU_ctrl_signals = 14'b0_00_0000_0001_101;
		#100;
		
		//#### xor: xor $r7, $r4, $r3; R7 = alu_out = 32'hffff_fffc
		// 1. IF:
		data2CPU = 32'b000000_00100_00011_00111_00000_100101;
		`CPU_ctrl_signals = 14'b1_00_1000_0010_000;
        ALU_operation = ADD;
		#100;
		//2. ID:
		`CPU_ctrl_signals = 14'b0_00_0000_0110_000;
        ALU_operation = ADD;
		#100;
		//3. Xor_Exe
		`CPU_ctrl_signals = 14'b0_00_0000_0001_000;
		ALU_operation = XOR;
		#100;
		//4. WB_R
		`CPU_ctrl_signals = 14'b0_00_0000_0001_101;
		#100;
		
		//#### jr:  jr $r0  PC = 32'h0000_0000
		// 1. IF:
		data2CPU = 32'b000000_00000_00000_00000_00000_001000;
		`CPU_ctrl_signals = 14'b1_00_1000_0010_000;
        ALU_operation = ADD;
		#100;
		//2. ID:
		`CPU_ctrl_signals = 14'b0_00_0000_0110_000;
        ALU_operation = ADD;
		#100;
		//3. Jr_Exe
		`CPU_ctrl_signals = 14'b1_00_0000_0001_000;
        ALU_operation = ADD;
		#100;
		
		//#### addi $r2, $r2, 2; R2 = alu_out = 32'h0000_0003
		// 1. IF:
		data2CPU = 32'b001000_00010_00010_00000_00000_000010;
		`CPU_ctrl_signals = 14'b1_00_1000_0010_000;
        ALU_operation = ADD;
		#100;
		//2. ID:
		`CPU_ctrl_signals = 14'b0_00_0000_0110_000;
        ALU_operation = ADD;
		#100;
		//3. EX_ADDi
		`CPU_ctrl_signals = 14'b0_00_0000_0101_000;
        ALU_operation = ADD; 
		#100;
		//4. WB_I
		`CPU_ctrl_signals = 14'b0_00_0000_0101_100;
		#100;
		
		//#### andi $r2, $r2, 5; R2 = alu_out = 32'h0000_0001
		// 1. IF:
		data2CPU = 32'b001100_00010_00010_00000_00000_000101;
		`CPU_ctrl_signals = 14'b1_00_1000_0010_000;
        ALU_operation = ADD;
		#100;
		//2. ID:
		`CPU_ctrl_signals = 14'b0_00_0000_0110_000;
        ALU_operation = ADD;
		#100;
		//3. EX_Andi
		`CPU_ctrl_signals <= 14'b0_00_0000_0101_000;
        ALU_operation = AND; 
		#100;
		//4. WB_I
		`CPU_ctrl_signals = 14'b0_00_0000_0101_100;
		#100;
		
		//#### ori $r2, $r2, 6; R2 = alu_out = 32'h0000_0007
		// 1. IF:
		data2CPU = 32'b001101_00010_00010_00000_00000_000110;
		`CPU_ctrl_signals = 14'b1_00_1000_0010_000;
        ALU_operation = ADD;
		#100;
		//2. ID:
		`CPU_ctrl_signals = 14'b0_00_0000_0110_000;
        ALU_operation = ADD;
		#100;
		//3. EX_Ori
		`CPU_ctrl_signals = 14'b0_00_0000_0101_000;
        ALU_operation = OR; 
		#100;
		//4. WB_I
		`CPU_ctrl_signals = 14'b0_00_0000_0101_100;
		#100;
		
		//#### xori $r2, $r2, 6; R2 = alu_out = 32'h0000_0001
		// 1. IF:
		data2CPU = 32'b001110_00010_00010_00000_00000_000110;
		`CPU_ctrl_signals = 14'b1_00_1000_0010_000;
        ALU_operation = ADD;
		#100;
		//2. ID:
		`CPU_ctrl_signals = 14'b0_00_0000_0110_000;
        ALU_operation = ADD;
		#100;
		//3. EX_Xori
		`CPU_ctrl_signals = 14'b0_00_0000_0101_000;
        ALU_operation = XOR; 
		#100;
		//4. WB_I
		`CPU_ctrl_signals = 14'b0_00_0000_0101_100;
		#100;
		
		//#### lui $r2, 6;  
		// 1. IF:
		data2CPU = 32'b001111_00000_00010_00000_00000_000110;
		`CPU_ctrl_signals = 14'b1_00_1000_0010_000;
        ALU_operation = ADD;
		#100;
		//2. ID:
		`CPU_ctrl_signals = 14'b0_00_0000_0110_000;
        ALU_operation = ADD;
		#100;
		//3. Lui_WB
		`CPU_ctrl_signals = 14'b0_00_0100_0110_100;
		#100;
		//#### After lui: add $r2, $r2, $r0; R2 = alu_out =  32'h0006_0000
		// 1. IF:
		data2CPU = 32'b000000_00010_00000_00010_00000_100000;
		`CPU_ctrl_signals = 14'b1_00_1000_0010_000;
        ALU_operation = ADD;
		#100;
		//2. ID:
		`CPU_ctrl_signals = 14'b0_00_0000_0110_000;
        ALU_operation = ADD;
		#100;
		//3. ADD_Exe
		`CPU_ctrl_signals = 14'b0_00_0000_0001_000;
		ALU_operation = ADD;
		#100;
		//4. WB_R
		`CPU_ctrl_signals = 14'b0_00_0000_0001_101;
		#100;
		
		//#### lw $r1, 4($r0); alu_out = 32'h0000_0004
		// 1. IF:
		data2CPU = 32'b100011_00000_00001_00000_00000_000100;
		`CPU_ctrl_signals = 14'b1_00_1000_0010_000;
        ALU_operation = ADD;
		#100;
		//2. ID:
		`CPU_ctrl_signals = 14'b0_00_0000_0110_000;
        ALU_operation = ADD;
		#100;
		//3. LW_EX
		`CPU_ctrl_signals = 14'b0_00_0000_0101_000;
        ALU_operation <= ADD;
		#100; 
		// 4. MEM_RD
		data2CPU = 32'hffff_0000;
		`CPU_ctrl_signals = 14'b0_01_0000_0101_000;
		#100;
		// 5. wb_lw
		`CPU_ctrl_signals = 14'b0_00_0010_0000_100;
		#100;
		//#### sw $r1, 8($r0); alu_out = 32'h0000_0008
		// 1. IF:
		data2CPU = 32'b101011_00000_00001_00000_00000_001000;
		`CPU_ctrl_signals = 14'b1_00_1000_0010_000;
        ALU_operation = ADD;
		#100;
		//2. ID:
		`CPU_ctrl_signals = 14'b0_00_0000_0110_000;
        ALU_operation = ADD;
		#100;
		//3. SW_EX
		`CPU_ctrl_signals = 14'b0_00_0000_0101_000; 
        ALU_operation = ADD;
		#100; 
		// 4. MEM_WD
		`CPU_ctrl_signals = 14'b0_01_0000_0101_000;
		#100;
		//#### beq $r0, $r0, 4; pc = pc + 8
		// 1. IF:
		data2CPU = 32'b000100_00000_00000_00000_00000_000100;
		`CPU_ctrl_signals = 14'b1_00_1000_0010_000;
        ALU_operation = ADD;
		#100;
		//2. ID:
		`CPU_ctrl_signals = 14'b0_00_0000_0110_000;
        ALU_operation = ADD;
		#100;
		//EX_beq:
		`CPU_ctrl_signals = 14'b0_10_0000_1001_000;
         ALU_operation = SUB;
        Branch = 1;
		#100;
		
		//#### bne $r0, $r1, 4; pc = pc + 8
		// 1. IF:
		data2CPU = 32'b000101_00000_00000_00000_00000_000100;
		`CPU_ctrl_signals = 14'b1_00_1000_0010_000;
        ALU_operation = ADD;
		#100;
		//2. ID:
		`CPU_ctrl_signals = 14'b0_00_0000_0110_000;
        ALU_operation = ADD;
		#100;
		//EX_beq:
		`CPU_ctrl_signals <= 17'b0_10_0000_1001_000;
        ALU_operation <= SUB;
        Branch = 0;
		#100;
		
		//#### j 32'h0000_1000
		// 1. IF:
		data2CPU = 32'b000010_00000_00000_00000_10000_000000;
		`CPU_ctrl_signals = 14'b1_00_1000_0010_000;
        ALU_operation = ADD;
		#100;
		//2. ID:
		`CPU_ctrl_signals = 14'b0_00_0000_0110_000;
        ALU_operation = ADD;
		#100;
		//3. EX_J
		`CPU_ctrl_signals = 14'b1_00_0001_0110_000;
		#100;
		//#### add $r5, $r5, $r5; R5 = alu_out = 32'h0000_0004
		// 1. IF:
		data2CPU = 32'b000000_00101_00101_00101_00000_100000;
		`CPU_ctrl_signals = 14'b1_00_1000_0010_000;
        ALU_operation = ADD;
		#100;
		//2. ID:
		`CPU_ctrl_signals = 14'b0_00_0000_0110_000;
        ALU_operation = ADD;
		#100;
		//3. ADD_Exe
		`CPU_ctrl_signals = 14'b0_00_0000_0001_000;
		ALU_operation = ADD;
		#100;
		//4. WB_R
		`CPU_ctrl_signals = 14'b0_00_0000_0001_101;
		#100;
		
		
		
		
		
		
		
		
		
		
		`CPU_ctrl_signals = 0;
		#100;
		// Add stimulus here

	end
      
endmodule

