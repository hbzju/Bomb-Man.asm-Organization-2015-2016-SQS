`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:42:07 05/12/2016 
// Design Name: 
// Module Name:    Top_OExp09_IPMCPU 
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
module Top_OExp09_IPMCPU(input RSTN,   
                        input [3:0] BTN_y,
                        input [15:0] SW,
                        input clk_100mhz,

                        output [4:0] BTN_x,
                        output CR,
                        output RDY,
                        output readn,
                        output seg_clk,
                        output seg_sout,
                        output SEG_PEN,
                        output seg_clrn,
                        output led_clk,
                        output led_sout,
                        output LED_PEN,
                        output led_clrn,
                        output [7:0] SEGMENT,
                        output [3:0] AN,
                        output [7:0] LED,
                        output Buzzer,
						
						output HSYNC,
						output VSYNC,
						output [3:0]Blue,
						output [3:0]Green,
						output [3:0]Red
                        );
		// U1
    wire [31:0] inst, PC, Addr_out, Data_in, Data_out;
    wire [4:0] State;
    wire mem_w, rst, Clk_CPU, cpu_mio, V5, _int;
		// U3
    wire [9:0] ram_addr;
    wire [31:0] dina, douta;
    wire data_ram_we, clk_m;  
		// U4
    wire [3:0] BTN_ok;
    wire [15:0] SW_ok, LED_out;
    wire [31:0] Counter_out, CPU2IO;
    wire counter0_out, counter1_out, counter2_out;
    wire GPIOe0000000_we, GPIOf0000000_we, counter_we;
		// U5
    wire IO_clk, N0;
    wire [7:0] point_out, LE_out;
    wire [31:0] Div, data_in, Disp_num;
    wire [63:0] point_in, zero_64;
		// U7
    wire [1:0] counter_ch;
    wire GPIOf0;
		// U9
    wire readn, Key_ready;
    wire [3:0] Pulse;
    wire [4:0] key_out;
		// M4 
    wire [4:0] Ctrl;
    wire [31:0] Ai, Bi;
    wire [7:0] blink;
		// U61 
	wire [3:0]MIO2VRAM_we;
	wire [4:0]Man_x,Man_y,Monster_x,Monster_y,Bomb_x,Bomb_y;
	wire [4:0]VRAM2MIO;
	wire [3:0]Fire;
	wire [1:0]lives;
	wire Door_open,win,lose,Bomb_EN,Boom,Monster_alive;
		//VGA
    wire [2:0] Scan;
    assign V5 = 1;
    assign N0 = 0;
    assign point_in = {Div[31:0], Div[31:13], State[4:0], {8{N0}}};
	assign clk_m = clk_100mhz;
    assign IO_clk = ~Clk_CPU;
	assign data_1 = {{2{N0}}, PC[31:2]};
	assign zero_64 = {64{N0}};
    assign Ctrl = {SW_ok[7:5], SW_ok[15], SW_ok[0]};
    assign Ai = 32'h87654321;
    assign Bi = 32'h12345678;
    assign Scan = {SW_ok[1], Div[19:18]};
	assign RDY = Key_ready;

    Multi_CPU       U1(.clk(Clk_CPU),
                       .reset(rst),
                       .MIO_ready(V5),
                       .PC_out(PC),
                       .inst_out(inst),
                       .mem_w(mem_w),
                       .Addr_out(Addr_out),
                       .Data_out(Data_out),
                       .Data_in(Data_in),
                       .CPU_MIO(cpu_mio),
                       .INT(_int),
                       .state(State)
                       );

    RAM_B           U3(.addra(ram_addr),
                       .wea(data_ram_we),
                       .dina(dina),
                       .clka(clk_m),
                       .douta(douta)
                       );


    MIO_BUS         U4(.clk(clk_100mhz),
                       .rst(rst),
                       .BTN(BTN_ok),
                       .SW(SW_ok),
                       .mem_w(mem_w),
                       .Cpu_data2bus(Data_out),                //data from CPU
                       .addr_bus(Addr_out),
                       .ram_data_out(douta),
                       .led_out(LED_out),
                       .counter_out(Counter_out),
                       .counter0_out(counter0_out),
                       .counter1_out(counter1_out),
                       .counter2_out(counter2_out),
                        
                       .Cpu_data4bus(Data_in),               //write to CPU
                       .ram_data_in(dina),                //from CPU write to Memory
                       .ram_addr(ram_addr),                        //Memory Address signals
                       .data_ram_we(data_ram_we),
                       .GPIOf0000000_we(GPIOf0000000_we),
                       .GPIOe0000000_we(GPIOe0000000_we),
								.GPIOvga(MIO2VRAM_we),
								.data4VRAM(VRAM2MIO),
                       .counter_we(counter_we),
                       .Peripheral_in(CPU2IO),
							  .sw4VRAM(sw4VRAM)
                       );

Multi_8CH32         U5(.clk(IO_clk),
                       .rst(rst),
                       .EN(GPIOe0000000_we),                               //Write EN
                       .Test(SW_ok[7:5]),                     
                       .point_in(point_in),                    
                       .LES(zero_64),                 
                       .Data0(CPU2IO),                 
                       .data1(data_1),
                       .data2(inst[31:0]),
                       .data3(Counter_out[31:0]),
                       .data4(Addr_out[31:0]),
                       .data5(Data_out[31:0]),
                       .data6(Data_in[31:0]),
                       .data7(PC[31:0]),
                       .point_out(point_out),
                       .LE_out(LE_out),
                       .Disp_num(Disp_num)
                       );

SSeg7_Dev           U6(.clk(clk_100mhz),          
                       .rst(rst),          
                       .Start(Div[20]),       
                       .SW0(SW_ok[0]),       
                       .flash(Div[25]),        
                       .Hexs(Disp_num),   
                       .point(point_out),    
                       .LES(LE_out),      
                       .seg_clk(seg_clk), 
                       .seg_sout(seg_sout),    
                       .SEG_PEN(SEG_PEN), 
                       .seg_clrn(seg_clrn) 
                       );

SPIO                U7(.clk(IO_clk),                           
                       .rst(rst),                  
                       .Start(Div[20]),                 
                       .EN(GPIOf0000000_we),                    
                       .P_Data(CPU2IO),          
                       .counter_set(counter_ch), 
                       .LED_out(LED_out),        
                       .led_clk(led_clk),         
                       .led_sout(led_sout),       
                       .led_clrn(led_clrn),        
                       .LED_PEN(LED_PEN),          
                       .GPIOf0(GPIOf0)                   
                        );

clk_div             U8(.clk(clk_100mhz),
                       .rst(rst),
                       .SW2(SW_ok[2]),
                       .clkdiv(Div[31:0]),
                       .Clk_CPU(Clk_CPU)
                        );

SAnti_jitter        U9(.clk(clk_100mhz), 
                       .RSTN(RSTN),
                       .readn(readn),
                       .Key_y(BTN_y),
                       .Key_x(BTN_x),
                       .SW(SW), 
                       .Key_out(key_out),
                       .Key_ready(Key_ready),
                       .pulse_out(Pulse),
                       .BTN_OK(BTN_ok),
                       .SW_OK(SW_ok),
                       .CR(CR),
                       .rst(rst)
                      );
Counter_x           U10(.clk(IO_clk),
                        .rst(rst),
                        .clk0(Div[8]),
                        .clk1(Div[9]),
                        .clk2(Div[11]),
                        .counter_we(counter_we),
                        .counter_val(CPU2IO),
                        .counter_ch(counter_ch),             //Counter channel set

                        .counter0_OUT(counter0_out),
                        .counter1_OUT(counter1_out),
                        .counter2_OUT(counter2),
                        .counter_out(Counter_out)
                       );
SEnter_2_32         M4(.clk(clk_100mhz),
                       .BTN(BTN_ok[2:0]),             
                       .Ctrl(Ctrl),               
                       .D_ready(Key_ready),             
                       .Din(key_out),
                       .readn(readn),          
                       .Ai(Ai),    
                       .Bi(Bi),   
                       .blink(blink)              
                       );
Seg7_Dev            U61(.Scan(Scan),
                        .SW0(SW_ok[0]),
                        .flash(Div[25]),
                        .Hexs(Disp_num),
                        .point(point_out),
                        .LES(LE_out),
                        .SEGMENT(SEGMENT),
                        .AN(AN)
                        );

PIO                 U71(.clk(IO_clk),
                        .rst(rst),
                        .EN(GPIOf0000000_we),
                        .PData_in(CPU2IO),
                        .counter_set(),
                        .LED_out(LED),
                        .GPIOf0()                       
                        );
buf                 buf1(Buzzer, V5);

VGA UHB1(
   .clk(clk_100mhz),
   .rst(rst),
   .Man_x(Man_x),
   .Man_y(Man_y),
	.Monster_alive(Monster_alive),
   .Monster_x(Monster_x),
   .Monster_y(Monster_y),
	.Door_open(Door_open),
	.Boom(Boom),
	.Fire(Fire),
	.Bomb_x(Bomb_x),
	.Bomb_y(Bomb_y),
	.win(win),
	.lose(lose),
	.Bomb_EN(Bomb_EN),
	.lives(lives),
	.hsync(HSYNC),
    .vsync(VSYNC),
    .vga_r(Red),
    .vga_g(Green),
    .vga_b(Blue)
	);

VRAM UHB2(
	.clk(clk_100mhz),
	.rst(rst),
	.GPIO_vga(MIO2VRAM_we),
	.data_in(CPU2IO),
	.Man_x(Man_x),
	.Man_y(Man_y),
	.Monster_alive(Monster_alive),
	.Monster_x(Monster_x),
	.Monster_y(Monster_y),
	.Boom(Boom),
	.Bomb_x(Bomb_x),
	.Bomb_y(Bomb_y),
	.Fire(Fire),
	.lives(lives),
	.Door_open(Door_open),
	.win(win),
	.lose(lose),
	.Bomb_EN(Bomb_EN),
	.data_out(VRAM2MIO),
	.sw_or_lw(sw4VRAM)
	);
endmodule
