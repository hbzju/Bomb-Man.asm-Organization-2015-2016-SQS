`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:40:33 12/22/2015 
// Design Name: 
// Module Name:    VGA 
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
module VGA(
   input clk,
   input rst,
   input [4:0]Man_x,
   input [4:0]Man_y,
	input Monster_alive,
   input [4:0]Monster_x,
   input [4:0]Monster_y,
	input Door_open,
   //input [4:0]Door_x,
   //input [4:0]Door_y,
	input Boom,
	input [3:0]Fire,
	input [4:0]Bomb_x,
	input [4:0]Bomb_y,
	input win,
	input lose,
	input Bomb_EN,
	input [1:0]lives,
   output hsync,
   output vsync,
   output [3:0]vga_r,
   output [3:0]vga_g,
   output [3:0]vga_b
	);
   reg [3:0]clkDiv;
   reg [9:0] x_cnt;//行坐标
   reg [9:0] y_cnt;//列坐标
   reg [4:0]Door_x;
   reg [4:0]Door_y;
   wire clk2;
   assign clk2=clkDiv[1];
  
   initial begin
   clkDiv = 4'b0;
   Door_x = 5'd10;
   Door_y = 5'd10;
   end
   
   always @(posedge clk)
     clkDiv = clkDiv + 1; //2分频,输入时钟25M
	 
   always @(posedge clk2 or posedge rst) //列扫描
     if(rst)
       x_cnt <= 10'd0;
     else if(x_cnt == 10'd799)
       x_cnt <= 10'd0;
     else
       x_cnt <= x_cnt+1'b1;
   always @(posedge clk2 or posedge rst) //行扫描
     if(rst)
       y_cnt <= 10'd0;
     else if(y_cnt == 10'd524) //扫描到524行
       y_cnt <= 10'd0;
     else if(x_cnt == 10'd799)
       y_cnt <= y_cnt+1'b1;
   reg hsync_r,vsync_r;//行，场同步信号
   always @(posedge clk2 or posedge rst)
     if(rst)
       hsync_r <= 1'b1;
     else if(x_cnt == 10'd0)
       hsync_r <= 1'b0;
     else if(x_cnt == 10'd96)
       hsync_r <= 1'b1;
   always @(posedge clk2 or posedge rst)
     if(rst)
       vsync_r <= 1'b1;
     else if(y_cnt == 10'd0)
       vsync_r <= 1'b0;
     else if(y_cnt == 10'd2)
       vsync_r <= 1'b1;
   assign hsync = hsync_r;
   assign vsync = vsync_r;
   reg valid_yr;//有效标志位
   always @(posedge clk2 or posedge rst)
      if(rst)
        valid_yr <=1'b0;
      else if(y_cnt == 10'd32)
        valid_yr <= 1'b1; //32-512之间显示
      else if(y_cnt == 10'd512)
        valid_yr <= 1'b0;
   wire valid_y = valid_yr;
   reg valid_r;//有效显示标志区
   always @(posedge clk2 or posedge rst)
     if(rst)
       valid_r <= 1'b0;
     else if((x_cnt == 10'd141) && valid_y)
       valid_r <= 1'b1;
     else if((x_cnt == 10'd781) && valid_y)
       valid_r <= 1'b0;
   wire valid = valid_r;
   wire [9:0] x_dis;//横坐标显示有效区域相对坐标0-639
   wire [9:0] y_dis;//纵坐标显示有效区域相对坐标0-479
   assign x_dis = x_cnt - 10'd142;
   assign y_dis = y_cnt - 10'd33;
   reg [11:0]vga_rgb;  
   
	assign vga_r = vga_rgb[11:8];
	assign vga_g = vga_rgb[7:4];
	assign vga_b = vga_rgb[3:0];
	
    always @(posedge clk2)
	 begin
	 if(!valid) vga_rgb<=12'h000; 
	 else if(win||lose)begin
	    if(lose)begin
		    if((x_dis[9:5]==2&&y_dis[9:5]>=4&&y_dis[9:5]<11)||
			    (y_dis[9:5]==10&&x_dis[9:5]>=2&&x_dis[9:5]<5)||  //L
				 (x_dis[9:5]==6&&y_dis[9:5]>=4&&y_dis[9:5]<11)||
				 (x_dis[9:5]==7&&(y_dis[9:5]==4||y_dis[9:5]==10))||
				 (x_dis[9:5]==8&&y_dis[9:5]>=4&&y_dis[9:5]<11)||   //O
				 (x_dis[9:5]==10&&((y_dis[9:5]>=4&&y_dis[9:5]<8)||y_dis[9:5]==10))||
				 (x_dis[9:5]==11&&(y_dis[9:5]==4||y_dis[9:5]==10||y_dis[9:5]==7))||
				 (x_dis[9:5]==12&&((y_dis[9:5]>=7&&y_dis[9:5]<11)||y_dis[9:5]==4))||  //S
				 (x_dis[9:5]==14&&y_dis[9:5]>=4&&y_dis[9:5]<11)||
				 (y_dis[9:5]==4&&x_dis[9:5]>=15&&x_dis[9:5]<17)||
				 (y_dis[9:5]==7&&x_dis[9:5]>=15&&x_dis[9:5]<17)||
				 (y_dis[9:5]==10&&x_dis[9:5]>=15&&x_dis[9:5]<17)||
				 (x_dis[9:5]==18&&((y_dis[9:5]>=4&&y_dis[9:5]<9)||y_dis[9:5]==10)))//E
				    vga_rgb<=12'hF0F;
		    else  vga_rgb<=12'h000;	 
		 end
	    else if(win) begin
		    if((x_dis[9:5]==1&&y_dis[9:5]>=4&&y_dis[9:5]<9)||
			    (x_dis[9:5]==2&&y_dis[9:5]>=9&&y_dis[9:5]<11)||
				 (x_dis[9:5]==3&&y_dis[9:5]>=4&&y_dis[9:5]<9)||
				 (x_dis[9:5]==4&&y_dis[9:5]>=9&&y_dis[9:5]<11)||
				 (x_dis[9:5]==5&&y_dis[9:5]>=4&&y_dis[9:5]<9)||  //W
				 (y_dis[9:5]==4&&x_dis[9:5]>=7&&x_dis[9:5]<10)||
				 (y_dis[9:5]==10&&x_dis[9:5]>=7&&x_dis[9:5]<10)||
				 (x_dis[9:5]==8&&y_dis[9:5]>=5&&y_dis[9:5]<10)||    //I
				 (x_dis[9:5]==11&&y_dis[9:5]>=4&&y_dis[9:5]<11)||
				 (x_dis[9:5]==12&&y_dis[9:5]>=4&&y_dis[9:5]<5)||
				 (x_dis[9:5]==13&&y_dis[9:5]>=5&&y_dis[9:5]<10)||
				 (x_dis[9:5]==14&&y_dis[9:5]>=10&&y_dis[9:5]<11)||
				 (x_dis[9:5]==15&&y_dis[9:5]>=4&&y_dis[9:5]<11)||
				 (x_dis[9:5]==17&&y_dis[9:5]>=4&&y_dis[9:5]<9)||
				 (x_dis[9:5]==17&&y_dis[9:5]>=10&&y_dis[9:5]<11))  //N
				    vga_rgb<=12'hFF0;
		    else  vga_rgb<=12'h000;
		 end
		 else vga_rgb<=12'h777;
	 end	 
	 else if((x_dis[9:5]==5'd2||x_dis[9:5]==5'd17)||
	         (x_dis[9:5]==5'd4||x_dis[9:5]==5'd6||x_dis[9:5]==5'd8
				||x_dis[9:5]==5'd11||x_dis[9:5]==5'd13||x_dis[9:5]==5'd15)
	         &&(y_dis[9:5]==5'd0||y_dis[9:5]==5'd2||y_dis[9:5]==5'd4||y_dis[9:5]==5'd6||
	         y_dis[9:5]==5'd8||y_dis[9:5]==5'd10||y_dis[9:5]==5'd12||y_dis[9:5]==5'd14)||
				y_dis[9:5]==0||y_dis[9:5]==14)
	 begin
		    if(y_dis[4:0]==3||y_dis[4:0]==7||y_dis[4:0]==11||y_dis[4:0]==15||
			    y_dis[4:0]==19||y_dis[4:0]==23||y_dis[4:0]==27||y_dis[4:0]==31||
				 ((x_dis[4:0]==7||x_dis[4:0]==15||x_dis[4:0]==23||x_dis[4:0]==31)&&
				 (y_dis[4:0]<4||(y_dis[4:0]>=7&&y_dis[4:0]<12)
				 ||(y_dis[4:0]>=15&&y_dis[4:0]<20)||(y_dis[4:0]>=23&&y_dis[4:0]<28)))||
				 ((x_dis[4:0]==3||x_dis[4:0]==11||x_dis[4:0]==19||x_dis[4:0]==27)&&
				 (y_dis[4:0]>26||(y_dis[4:0]>=3&&y_dis[4:0]<8)||
				 (y_dis[4:0]>=11&&y_dis[4:0]<16)||(y_dis[4:0]>=19&&y_dis[4:0]<24))))
				    vga_rgb<=12'd007;
			  else vga_rgb<=12'hFFF;
	 end
	 //WALL
	 else if(Monster_alive&&x_dis[9:5]==Monster_x+5'b00010&&y_dis[9:5]==Monster_y)
	 begin
	    if((x_dis[4:0]==10&&y_dis[4:0]==13)||
		    (x_dis[4:0]==13&&y_dis[4:0]==13)||
			 (x_dis[4:0]==17&&y_dis[4:0]==13)||
			 (x_dis[4:0]==19&&y_dis[4:0]==13)||
			 (y_dis[4:0]==12&&x_dis[4:0]>=11&&x_dis[4:0]<13)||
			 (y_dis[4:0]==12&&x_dis[4:0]>=18&&x_dis[4:0]<20)||
			 (x_dis[4:0]==11&&y_dis[4:0]>=17&&y_dis[4:0]<19)||
			 (x_dis[4:0]==12&&y_dis[4:0]>=18&&y_dis[4:0]<20)||
			 (y_dis[4:0]==19&&x_dis[4:0]>=13&&x_dis[4:0]<17)||
			 (x_dis[4:0]==17&&y_dis[4:0]>=18&&y_dis[4:0]<24))
			   vga_rgb<=12'hFFF;
		 else if((x_dis[4:0]==8&&y_dis[4:0]==4)||
		         (x_dis[4:0]==16&&y_dis[4:0]==3)||
					(x_dis[4:0]==17&&y_dis[4:0]==2)||
					(x_dis[4:0]==9&&y_dis[4:0]>=2&&y_dis[4:0]<4)||
					(x_dis[4:0]==13&&y_dis[4:0]>=2&&y_dis[4:0]<5)||
					(x_dis[4:0]==20&&y_dis[4:0]>=2&&y_dis[4:0]<5)||
					(y_dis[4:0]==1&&x_dis[4:0]>=10&&x_dis[4:0]<13)||
					(y_dis[4:0]==1&&x_dis[4:0]>=18&&x_dis[4:0]<20)||
					(x_dis[4:0]>=12&&x_dis[4:0]<21&&y_dis[4:0]>=5&&y_dis[4:0]<8)||
		         (x_dis[4:0]>=8&&x_dis[4:0]<24&&y_dis[4:0]>=8&&y_dis[4:0]<25)||
					(x_dis[4:0]>=6&&x_dis[4:0]<26&&y_dis[4:0]>=14&&y_dis[4:0]<21)||
					(x_dis[4:0]==2&&y_dis[4:0]>=15&&y_dis[4:0]<17)||
					(x_dis[4:0]==28&&y_dis[4:0]>=16&&y_dis[4:0]<20)||
					(y_dis[4:0]==16&&x_dis[4:0]>=3&&x_dis[4:0]<28)||
					(y_dis[4:0]==26&&x_dis[4:0]>=11&&x_dis[4:0]<13)||
					(y_dis[4:0]==27&&x_dis[4:0]>=10&&x_dis[4:0]<12)||
					(y_dis[4:0]==28&&x_dis[4:0]>=9&&x_dis[4:0]<11)||
					(y_dis[4:0]==29&&x_dis[4:0]>=7&&x_dis[4:0]<10)||
					(y_dis[4:0]==29&&x_dis[4:0]>=16&&x_dis[4:0]<19)||
					(y_dis[4:0]==28&&x_dis[4:0]>=18&&x_dis[4:0]<20)||
					(x_dis[4:0]==19&&y_dis[4:0]>=26&&y_dis[4:0]<28))
					   vga_rgb<=12'hF0F;
		 else vga_rgb<=12'h000;	//Monster
	 end 
	 else if(Door_open&&x_dis[9:5]==Door_x+2&& y_dis[9:5]==Door_y)
	 begin
	    if((x_dis[4:0]>0&&x_dis[4:0]<12&&y_dis[4:0]>3&&y_dis[4:0]<28)||
		    (x_dis[4:0]>19&&x_dis[4:0]<31&&y_dis[4:0]>3&&y_dis[4:0]<28))
			   vga_rgb<=12'h00F;
		 else vga_rgb<=12'hFF0;
	 end	//Door
	 else if(x_dis[9:5]==Man_x+5'b00010&& y_dis[9:5]==Man_y)
	 begin 
	    if((x_dis[4:0]==10&&y_dis[4:0]==6)||
		    (x_dis[4:0]==13&&y_dis[4:0]==6)||
			 (x_dis[4:0]==11&&y_dis[4:0]==8)||
			 (x_dis[4:0]==12&&y_dis[4:0]==8))
			    vga_rgb<=12'h000;//眼睛嘴巴
		 else if((x_dis[4:0]>=8&&x_dis[4:0]<16&&y_dis[4:0]>=0&&y_dis[4:0]<4)||
		         (x_dis[4:0]>=5&&x_dis[4:0]<18&&y_dis[4:0]==4))
					   vga_rgb<=12'h0FF;//帽子
		 else if((x_dis[4:0]>=8&&x_dis[4:0]<16&&y_dis[4:0]>=5&&y_dis[4:0]<8)||
		         (x_dis[4:0]>=9&&x_dis[4:0]<15&&y_dis[4:0]==8)||
					(x_dis[4:0]>=10&&x_dis[4:0]<14&&y_dis[4:0]==9)||
					(x_dis[4:0]>=5&&x_dis[4:0]<18&&y_dis[4:0]==10)||
					(x_dis[4:0]>=4&&x_dis[4:0]<19&&y_dis[4:0]==11)||
					(x_dis[4:0]>=3&&x_dis[4:0]<23&&y_dis[4:0]==12)||
					(x_dis[4:0]==3&&y_dis[4:0]>=13&&y_dis[4:0]<23)||
					(x_dis[4:0]==4&&y_dis[4:0]>=13&&y_dis[4:0]<24)||
					(x_dis[4:0]==6&&y_dis[4:0]>=13&&y_dis[4:0]<23)||
					(x_dis[4:0]==3&&y_dis[4:0]>=13&&y_dis[4:0]<23)||
					(x_dis[4:0]>=7&&x_dis[4:0]<18&&y_dis[4:0]>=13&&y_dis[4:0]<24)||
					(x_dis[4:0]==18&&y_dis[4:0]>=13&&y_dis[4:0]<22)||
					(y_dis[4:0]==13&&x_dis[4:0]>=19&&x_dis[4:0]<23)||
					(y_dis[4:0]>=14&&y_dis[4:0]<17&&x_dis[4:0]>=21&&x_dis[4:0]<23)||
					(x_dis[4:0]>=23&&x_dis[4:0]<26&&y_dis[4:0]>=15&&y_dis[4:0]<17)||
					(x_dis[4:0]==26&&y_dis[4:0]==16)||
					(x_dis[4:0]>=8&&x_dis[4:0]<12&&y_dis[4:0]>=24&&y_dis[4:0]<32)||
					(x_dis[4:0]>=13&&x_dis[4:0]<17&&y_dis[4:0]>=24&&y_dis[4:0]<32)||
					(x_dis[4:0]==7&&y_dis[4:0]==31)||
					(x_dis[4:0]==17&&y_dis[4:0]==31)
					)
					    vga_rgb<=12'hFF0;//身体
		else if((y_dis[4:0]==6&&x_dis[4:0]>=26&&x_dis[4:0]<29)||
		        (x_dis[4:0]==26&&y_dis[4:0]>=7&&y_dis[4:0]<9)||
				  (y_dis[4:0]==9&&x_dis[4:0]>=26&&x_dis[4:0]<29)||
				  (y_dis[4:0]==10&&x_dis[4:0]>=25&&x_dis[4:0]<30)||
				  (y_dis[4:0]>=11&&y_dis[4:0]<14&&x_dis[4:0]>=24&&x_dis[4:0]<31)||
				  (y_dis[4:0]==14&&x_dis[4:0]>=26&&x_dis[4:0]<29)||
				  (y_dis[4:0]==15&&x_dis[4:0]>=27&&x_dis[4:0]<28))
				     vga_rgb<=12'hF00;//手雷
		else vga_rgb<=12'h000;//background
    end		 	 //Man
	 else vga_rgb<=12'h000;
	 
	 if(!win&&!lose&&Bomb_EN&&x_dis[9:5]==Bomb_x+5'b00010&& y_dis[9:5]==Bomb_y&&valid)begin
	    if((x_dis[4:1]==6&&y_dis[4:1]==7)||
		    (x_dis[4:1]==9&&y_dis[4:1]==7)||
			 (x_dis[4:1]==6&&y_dis[4:1]==10)||
			 (x_dis[4:1]==9&&y_dis[4:1]==10)||
		    (y_dis[4:1]==11&&x_dis[4:1]>=6&x_dis[4:1]<10)||
		    (y_dis[4:1]==12&&x_dis[4:1]>=7&x_dis[4:1]<9))
			   vga_rgb<=12'hFFF;
	    else if((y_dis[4:1]==0&&x_dis[4:1]>=9&x_dis[4:1]<11)||
		    (y_dis[4:1]==1&&x_dis[4:1]>=7&x_dis[4:1]<10)||
			 (x_dis[4:1]==7&&y_dis[4:1]>=2&y_dis[4:1]<4)||
			 (x_dis[4:1]>=5&&x_dis[4:1]<11&&y_dis[4:1]>=4&y_dis[4:1]<6)||
			 (y_dis[4:1]==6&&x_dis[4:1]>=4&x_dis[4:1]<12)||
			 (y_dis[4:1]==7&&x_dis[4:1]>=3&x_dis[4:1]<13)||
			 (x_dis[4:1]>=2&&x_dis[4:1]<14&&y_dis[4:1]>=8&y_dis[4:1]<14)||
			 (y_dis[4:1]==14&&x_dis[4:1]>=3&x_dis[4:1]<13)||
			 (y_dis[4:1]==15&&x_dis[4:1]>=5&x_dis[4:1]<11))
			    vga_rgb<=12'hF00;
    end
	 if(!win&&!lose&&Boom&&valid)begin
		 if((x_dis[9:5]==Bomb_x+2&& y_dis[9:5]==Bomb_y)||
		   (~Fire[0]&&x_dis[9:5]==Bomb_x+1&&y_dis[9:5]==Bomb_y)||
		   (~Fire[2]&&x_dis[9:5]==Bomb_x+3&&y_dis[9:5]==Bomb_y)||	
         (~Fire[1]&&x_dis[9:5]==Bomb_x+2&& y_dis[9:5]==Bomb_y-1)||			
         (~Fire[3]&&x_dis[9:5]==Bomb_x+2&& y_dis[9:5]==Bomb_y+1))
		 begin 
				   if((x_dis[4:0]>=11&&x_dis[4:0]<19&&y_dis[4:0]>=27&&y_dis[4:0]<32)||
					   (x_dis[4:0]>=7&&x_dis[4:0]<23&&y_dis[4:0]>=23&&y_dis[4:0]<27)||
						(x_dis[4:0]>=3&&x_dis[4:0]<27&&y_dis[4:0]>=19&&y_dis[4:0]<23)||
						(x_dis[4:0]>=3&&x_dis[4:0]<31&&y_dis[4:0]>=15&&y_dis[4:0]<19)||
						(x_dis[4:0]>=7&&x_dis[4:0]<27&&y_dis[4:0]>=11&&y_dis[4:0]<15)||
						(x_dis[4:0]>=15&&x_dis[4:0]<27&&y_dis[4:0]>=7&&y_dis[4:0]<11)||
						(x_dis[4:0]>=11&&x_dis[4:0]<19&&y_dis[4:0]>=3&&y_dis[4:0]<7)||
						(x_dis[4:0]>=7&&x_dis[4:0]<11&&y_dis[4:0]>=0&&y_dis[4:0]<3))
						   vga_rgb<=12'hF00;
		 end   //火焰	
		 if((x_dis[9:5]==5'd2||x_dis[9:5]==5'd17)||
	         (x_dis[9:5]==5'd4||x_dis[9:5]==5'd6||x_dis[9:5]==5'd8
				||x_dis[9:5]==5'd11||x_dis[9:5]==5'd13||x_dis[9:5]==5'd15)
	         &&(y_dis[9:5]==5'd0||y_dis[9:5]==5'd2||y_dis[9:5]==5'd4||y_dis[9:5]==5'd6||
	         y_dis[9:5]==5'd8||y_dis[9:5]==5'd10||y_dis[9:5]==5'd12||y_dis[9:5]==5'd14)||
				y_dis[9:5]==0||y_dis[9:5]==14)
			begin
		    if(y_dis[4:0]==3||y_dis[4:0]==7||y_dis[4:0]==11||y_dis[4:0]==15||
			    y_dis[4:0]==19||y_dis[4:0]==23||y_dis[4:0]==27||y_dis[4:0]==31||
				 ((x_dis[4:0]==7||x_dis[4:0]==15||x_dis[4:0]==23||x_dis[4:0]==31)&&
				 (y_dis[4:0]<4||(y_dis[4:0]>=7&&y_dis[4:0]<12)
				 ||(y_dis[4:0]>=15&&y_dis[4:0]<20)||(y_dis[4:0]>=23&&y_dis[4:0]<28)))||
				 ((x_dis[4:0]==3||x_dis[4:0]==11||x_dis[4:0]==19||x_dis[4:0]==27)&&
				 (y_dis[4:0]>26||(y_dis[4:0]>=3&&y_dis[4:0]<8)||
				 (y_dis[4:0]>=11&&y_dis[4:0]<16)||(y_dis[4:0]>=19&&y_dis[4:0]<24))))
				    vga_rgb<=12'd007;
			  else vga_rgb<=12'hFFF;
			end
	 end
	 if(!win&&!lose)begin
	    if((x_dis[9:2]==6&&y_dis[9:2]>=10&&y_dis[9:2]<49&&y_dis[9:2]!=19
	       &&y_dis[9:2]!=29&&y_dis[9:2]!=39)||
		    (x_dis[9:2]==6&&y_dis[9:2]>=60&&y_dis[9:2]<69)||
		    (x_dis[9:2]==6&&y_dis[9:2]>=72&&y_dis[9:2]<79)||
		    (x_dis[9:2]==6&&y_dis[9:2]>=80&&y_dis[9:2]<89)||
		    (x_dis[9:2]==8&&y_dis[9:2]>=31&&y_dis[9:2]<38)||
		    (x_dis[9:2]==8&&y_dis[9:2]>=61&&y_dis[9:2]<68)||
		    (x_dis[9:2]==8&&y_dis[9:2]>=81&&y_dis[9:2]<88)||
		    (x_dis[9:2]==10&&y_dis[9:2]>=11&&y_dis[9:2]<14)||
		    (x_dis[9:2]==10&&y_dis[9:2]>=15&&y_dis[9:2]<18)||
		    (x_dis[9:2]==10&&y_dis[9:2]>=20&&y_dis[9:2]<29)||
		    (x_dis[9:2]==10&&y_dis[9:2]>=30&&y_dis[9:2]<39)||
		    (x_dis[9:2]==10&&y_dis[9:2]>=41&&y_dis[9:2]<44)||
		    (x_dis[9:2]==10&&y_dis[9:2]>=45&&y_dis[9:2]<48)||
	   	 (x_dis[9:2]==10&&y_dis[9:2]>=60&&y_dis[9:2]<69)||
	   	 (x_dis[9:2]==10&&y_dis[9:2]>=72&&y_dis[9:2]<79)||
	   	 (x_dis[9:2]==10&&y_dis[9:2]>=80&&y_dis[9:2]<89)||
	   	 ((x_dis[9:2]>=6&&x_dis[9:2]<10)&&
	   	 (y_dis[9:2]==10||y_dis[9:2]==14||y_dis[9:2]==18||
	   	 y_dis[9:2]==20||y_dis[9:2]==28||y_dis[9:2]==40||
	   	 y_dis[9:2]==44||y_dis[9:2]==48||y_dis[9:2]==74))||
	   	 ((x_dis[9:2]==7||x_dis[9:2]==9)&&(y_dis[9:2]==30||y_dis[9:2]==60
	   	 ||y_dis[9:2]==71))||
	   	 (x_dis[9:2]==8&&y_dis[9:2]==70)||
	   	 (x_dis[9:2]==7&&y_dis[9:2]==80)||
	   	 (x_dis[9:2]==9&&y_dis[9:2]==88))
		       vga_rgb<=12'hF0F;
		else if((x_dis[9:2]==1&&y_dis[9:2]==99)||
		        (x_dis[9:2]==7&&y_dis[9:2]==99)||
				  (x_dis[9:2]==2&&y_dis[9:2]>=98&&y_dis[9:2]<102)||
				  (x_dis[9:2]==3&&y_dis[9:2]>=98&&y_dis[9:2]<103)||
				  (x_dis[9:2]==4&&y_dis[9:2]>=99&&y_dis[9:2]<104)||
				  (x_dis[9:2]==5&&y_dis[9:2]>=98&&y_dis[9:2]<103)||
				  (x_dis[9:2]==6&&y_dis[9:2]>=98&&y_dis[9:2]<102))
				  vga_rgb<=12'hF00;

		if((lives==1)&&(x_dis[9:2]==12&&y_dis[9:2]>=98&&y_dis[9:2]<104))vga_rgb<=3'hF00;
		else if((lives==2)&&((x_dis[9:2]==11&&y_dis[9:2]==98)||
		        (x_dis[9:2]==11&&y_dis[9:2]==102)||
		        (x_dis[9:2]==12&&y_dis[9:2]==98)||
				  (x_dis[9:2]==13&&y_dis[9:2]==99)||
				  (x_dis[9:2]==13&&y_dis[9:2]==100)||
				  (x_dis[9:2]==12&&y_dis[9:2]==101)||
				  (y_dis[9:2]==103&&x_dis[9:2]>=11&&x_dis[9:2]<14)))
				  vga_rgb<=12'hF00;
		else if((lives==3)&&(((y_dis[9:2]==98||y_dis[9:2]==103)&&x_dis[9:2]>=11&&x_dis[9:2]<13)||
		         (x_dis[9:2]==13&&y_dis[9:2]>=99&&y_dis[9:2]<103)||
					(x_dis[9:2]>=11&&x_dis[9:2]<13&&y_dis[9:1]>=201&&y_dis[9:1]<203)))
					vga_rgb<=12'hF00;				
		end
  end
	 //Fire
endmodule
