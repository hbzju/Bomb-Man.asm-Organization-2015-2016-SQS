`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:04:14 06/30/2012 
// Design Name: 
// Module Name:    MIO_BUS 
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
module MIO_BUS(input clk,
					input rst,
					input[3:0]BTN,
					input[15:0]SW,
					input mem_w,
					input[31:0]Cpu_data2bus,				//data from CPU
					input[31:0]addr_bus,
					input[31:0]ram_data_out,
					input[15:0]led_out,
					input[31:0]counter_out,
					input counter0_out,
					input counter1_out,
					input counter2_out,
					input [4:0]data4VRAM,
					
					output reg counter_we,
					output reg[31:0]Cpu_data4bus,				//write to CPU
					output reg[31:0]ram_data_in,				//from CPU write to Memory
					output reg[9:0]ram_addr,						//Memory Address signals
					output reg data_ram_we,
					output reg GPIOf0000000_we,
					output reg GPIOe0000000_we,
					output reg[3:0]GPIOvga,
					output reg sw4VRAM,
					output reg[31:0]Peripheral_in
					);
	always @* begin
		data_ram_we=0;
		counter_we=0;
		GPIOe0000000_we=0;
		GPIOf0000000_we=0;
		ram_addr=10'h0;
		ram_data_in=32'h0;
		Peripheral_in=32'h0;
		Cpu_data4bus=32'h0;
		GPIOvga=4'b0;
		sw4VRAM=0;
			case(addr_bus[31:28])
				4'h0:begin
					data_ram_we=mem_w;//data_ram (00000000-00000ffc) lower 4KB RAM
					ram_addr=addr_bus[11:2];
					ram_data_in=Cpu_data2bus;
					Cpu_data4bus=ram_data_out;
				end

				4'he:begin//7 Segment LEDs(e0000000-effffff),4 bit 7-seg display
					GPIOe0000000_we=mem_w;
					Peripheral_in=Cpu_data2bus;
					Cpu_data4bus=counter_out; 
				end

				4'hf:begin//LED(f00000000-fffffff0),8 LEDs&counter,f000004-fffffff4
					if(addr_bus[2])begin
						counter_we=mem_w;
						Peripheral_in=Cpu_data2bus;
						Cpu_data4bus=counter_out;
					end
					else begin
						GPIOf0000000_we=mem_w;
						Peripheral_in=Cpu_data2bus;
						Cpu_data4bus={12'h000,BTN,SW};
					end
				end
				
				4'hd:begin
					sw4VRAM=mem_w;
					Peripheral_in=Cpu_data2bus;
					GPIOvga=addr_bus[19:16];//0-unuse,1-man,2-monster,3-Monster
					Cpu_data4bus[4:0]=data4VRAM;
				end
			endcase
	end
															
endmodule
