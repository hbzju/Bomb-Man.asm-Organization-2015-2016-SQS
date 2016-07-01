`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:12:22 05/19/2016 
// Design Name: 
// Module Name:    M_datapath 
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
module M_datapath( input clk,
                   input reset,
                  
                   input MIO_ready,     
                   input IorD,
                   input IRWrite,
                   input[1:0] RegDst,
                   input RegWrite,
                   input[1:0]MemtoReg,
                   input ALUSrcA,
                  
                   input[1:0]ALUSrcB,
                   input[1:0]PCSource,
                   input PCWrite,
                   input PCWriteCond,   
                   input Branch,
                   input[2:0]ALU_operation,
                  
                   output[31:0]PC_Current,
                   input[31:0]data2CPU,
                   output[31:0]Inst,
                   output[31:0]data_out,
                   output[31:0]M_addr,
                   output zero,
                   output overflow
                );

// IR relevant 
// MDR relevant
wire N0, V5;
wire [31:0] MDR_out;
// U2 relevant
wire [4:0] Wt_addr;
wire [31:0] ALU_Out;
wire [31:0] Wt_data, rdata_A, rdata_B;
// Ext_32 relevant
wire [31:0] Imm_32;
// ALU relevant
wire [31:0] SrcA_out, SrcB_out, res;
// PC relevant
wire [31:0] PC_value, PC_4, Branch_pc, Jump_addr;
wire pc_EN, branch_EN;
/* New */
wire [31:0] lui_value, jr_value, jr_addr;

assign N0 = 0;
assign V5 = 1;
assign data_out = rdata_B;
assign branch_EN = ~(Branch ^ zero ) && PCWriteCond; // edit
assign pc_EN = MIO_ready && (PCWrite || branch_EN);
assign PC_4 = res;
assign Branch_pc = ALU_Out;
assign Jump_addr = {PC_Current[31:28], Inst[25:0], {2{N0}}};
/* New */
assign lui_value = {Inst[15:0], {16{N0}}};
assign jr_value = PC_Current;
assign jr_addr = ALU_Out;

//++++++++++++++++++++ Instruction Register ++++++++++++++++++
REG32               IR(.clk(clk),
                       .rst(reset),
                       .CE(IRWrite),
                       .D(data2CPU),
                       .Q(Inst)
                        );

//++++++++++++++++++++ Memory data Register +++++++++++++++++++
REG32               MDR(.clk(clk),
                        .rst(N0),
                        .CE(V5),
                        .D(data2CPU),
                        .Q(MDR_out)
                        );   

//++++++++++++++++++++ U2 Regs ++++++++++++++++++++++++++++++
MUX4T1_5            MUX1(.s(RegDst),
                         .I0(Inst[20:16]),
                         .I1(Inst[15:11]),
                         .I2(5'b11111), // edit
                         .I3(0),
                         .o(Wt_addr)
                         );
MUX4T1_32           MUX2(.s(MemtoReg),
                         .I0(ALU_Out),
                         .I1(MDR_out),
                         .I2(lui_value), // edit
                         .I3(jr_value), // edit
                         .o(Wt_data)
                         );
regs                U2(.clk(clk),
                       .rst(reset),
                       .R_addr_A(Inst[25:21]),
                       .R_addr_B(Inst[20:16]),
                       .Wt_addr(Wt_addr),
                       .wt_data(Wt_data),
                       .rdata_A(rdata_A),
                       .rdata_B(rdata_B),
                       .L_S(RegWrite)
                       );

//+++++++++++++++++++++ Ext_32 +++++++++++++++++++++++++++++
Ext_32              Ext_32(.imm_16(Inst[15:0]),
                           .Imm_32(Imm_32)
                           );
//+++++++++++++++++++++ ALU ++++++++++++++++++++++++++++++++
MUX2T1_32           MUX3(.s(ALUSrcA),
                         .I0(PC_Current),
                         .I1(rdata_A),
                         .o(SrcA_out)
                         );

MUX4T1_32           MUX4(.s(ALUSrcB),
                         .I0(rdata_B),
                         .I1(4),
                         .I2(Imm_32),
                         .I3(Imm_32<<2),
                         .o(SrcB_out)
                         );
ALU                 U1(.A(SrcA_out),
                       .B(SrcB_out),
                       .ALU_operation(ALU_operation),
                       .zero(zero),
                       .res(res),
                       .overflow(overflow)
                       );
REG32               ALUOut(.clk(clk),
                           .rst(N0),
                           .CE(V5),
                           .D(res),
                           .Q(ALU_Out)
                           );
// ++++++++++++++++++++ Memory address out +++++++++++++++++
MUX2T1_32           MUX5(.s(IorD),
                         .I0(PC_Current),
                         .I1(ALU_Out),
                         .o(M_addr)
                         );
// ++++++++++++++++++++ PC +++++++++++++++++++++++++++++++++
REG32               PC(.clk(clk),
                       .rst(reset),
                       .CE(pc_EN),
                       .D(PC_value),
                       .Q(PC_Current)
					   );

MUX4T1_32           MUX6(.s(PCSource),
                         .I0(PC_4),
                         .I1(Branch_pc),
                         .I2(Jump_addr),
                         .I3(jr_addr),
                         .o(PC_value)
                         );

endmodule
