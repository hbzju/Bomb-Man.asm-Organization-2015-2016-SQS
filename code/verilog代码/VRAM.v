module VRAM(
	input clk,
	input rst,
	input [3:0]GPIO_vga,
	input [31:0]data_in,
	input sw_or_lw,
	output [4:0]Man_x,
	output [4:0]Man_y,
	output Monster_alive,
	output [4:0]Monster_x,
	output [4:0]Monster_y,
	output Boom,
	output [4:0]Bomb_x,
	output [4:0]Bomb_y,
	output [3:0]Fire,
	output [1:0]lives,
	output Door_open,
	output win,
	output lose,
	output Bomb_EN,
	output reg [4:0]data_out
	);
	
	reg [10:0]vram[3:0];

	assign Man_x = vram[0][4:0];
	assign Man_y = vram[0][9:5];
	assign Monster_alive=vram[1][10];
	assign Monster_x = vram[1][4:0];
	assign Monster_y = vram[1][9:5];
	assign Boom = vram[2][10];
	assign Bomb_x = vram[2][4:0];
	assign Bomb_y = vram[2][9:5];
	assign Fire[3] = vram[3][0];
	assign Fire[2] = vram[3][1];
	assign Fire[1] = vram[3][2];
	assign Fire[0] = vram[3][3];
	assign lives = vram[3][5:4];
	assign Door_open = vram[3][6];
	assign win = vram[3][7];
	assign lose = vram[3][8];
	assign Bomb_EN = vram[3][9];

	always @(posedge clk or posedge rst) begin
		if (rst) begin
			vram[0]=11'b00000100001;//man
			vram[1]=11'b10011101000;//monster
			vram[2]=11'b00000000000;//bomb
			vram[3]=11'b00000110000;//other
		end
		else if(sw_or_lw)begin
			case(GPIO_vga)
				4'd0:begin
				end
				4'd1:begin//man_x
					vram[0][4:0]=data_in[4:0];
				end
				4'd2:begin//man_y
					vram[0][9:5]=data_in[4:0];
				end
				4'd3:begin//Monster_alive
					vram[1][10]=data_in[0];
				end
				4'd4:begin//Monster_x
					vram[1][4:0]=data_in[4:0];
				end
				4'd5:begin//Monster_y
					vram[1][9:5]=data_in[4:0];
				end
				4'd6:begin//Boom
					vram[2][10]=data_in[0];
				end
				4'd7:begin//Boom_x=Man_x,Boom_y=Man_y
					vram[2][4:0]=vram[0][4:0];
					vram[2][9:5]=vram[0][9:5];
				end
				/*4'd8:begin//Boom_y
					vram[2][9:5]=data_in[4:0];
				end*/
				4'd9:begin//Fire
					vram[3][3:0]=data_in[3:0];
				end
				4'd10:begin//lives
					vram[3][5:4]=data_in[1:0];
				end
				4'd11:begin//Door_open
					vram[3][6]=data_in[0];
				end
				4'd12:begin//win
					vram[3][7]=data_in[0];
				end
				4'd13:begin//lose
					vram[3][8]=data_in[0];
				end
				4'd14:begin//Bomb_EN
					vram[3][9]=data_in[0];
				end
				4'd15:
				begin
					vram[0]=11'b00000100001;//man
					vram[1]=11'b10011101001;//monster
					vram[2]=11'b00000000000;//bomb
					vram[3]=11'b00000110000;//other			
				end
			endcase
		end
		else begin  //lw
			data_out=0;
			case(GPIO_vga)
				4'd0:begin
				end
				4'd1:begin//man_x
					data_out[4:0]=vram[0][4:0];
				end
				4'd2:begin//man_y
					data_out[4:0]=vram[0][9:5];
				end
				4'd3:begin//Monster_alive
					data_out[0]=vram[1][10];
				end
				4'd4:begin//Monster_x
					data_out[4:0]=vram[1][4:0];
				end
				4'd5:begin//Monster_y
					data_out[4:0]=vram[1][9:5];
				end
				4'd6:begin//Boom
					data_out[0]=vram[2][10];
				end
				4'd7:begin//return Bomb_x
					data_out[4:0]=vram[2][4:0];
				end
				4'd8:begin//Boom_y
					data_out[4:0]=vram[2][9:5];
				end
				4'd9:begin//Fire
					data_out[3:0]=vram[3][3:0];
				end
				4'd10:begin//lives
					data_out[1:0]=vram[3][5:4];
				end
				4'd11:begin//Door_open
					data_out[0]=vram[3][6];
				end
				4'd12:begin//win
					data_out[0]=vram[3][7];
				end
				4'd13:begin//lose
					data_out[0]=vram[3][8];
				end
				4'd14:begin//Bomb_EN
					data_out[0]=vram[3][9];
				end
				4'd15:
				begin
					vram[0]=11'b00000100001;//man
					vram[1]=11'b10011101001;//monster
					vram[2]=11'b00000000000;//bomb
					vram[3]=11'b00000110000;//other
				end
			endcase
		end
	end

endmodule
	