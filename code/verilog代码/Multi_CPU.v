`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:42:21 05/12/2016 
// Design Name: 
// Module Name:    Multi_CPU 
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
module Multi_CPU(input clk,
                input reset,
                input MIO_ready,
                output [31:0] PC_out,
                output [31:0] inst_out,
                output mem_w,
                output [31:0] Addr_out,
                output [31:0] Data_out,
                input [31:0] Data_in,
                output CPU_MIO,
                input INT,
                output [4:0] state
    );
    wire zero, overflow, IorD, IRWrite, ALUSrcA, RegWrite;
    wire PCWrite, PCWriteCond, Branch, MemWrite, MemRead;
    wire [1:0] RegDst;
    wire [1:0] MemtoReg;
    wire [1:0] ALUSrcB;
    wire [1:0] PCSource;
	wire [2:0] ALU_operation;
    wire [31:0] PC_Current;
    assign mem_w = MemWrite && (~MemRead);
    assign PC_out = PC_Current;

    ctrl x_ctrl(.clk(clk),
                .reset(reset),
                .Inst_in(inst_out),
                .zero(zero),
                .overflow(overflow),
                .MIO_ready(MIO_ready),
                .MemRead(MemRead),
                .MemWrite(MemWrite),
                .ALU_operation(ALU_operation),
                .state_out(state),
                .CPU_MIO(CPU_MIO),
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
                .Branch(Branch)
                );

    M_datapath x_datapath(.clk(clk),
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
                          .data2CPU(Data_in),
                          .Inst(inst_out),
                          .data_out(Data_out),
                          .M_addr(Addr_out),
                          .zero(zero),
                          .overflow(overflow)
                          );





endmodule
