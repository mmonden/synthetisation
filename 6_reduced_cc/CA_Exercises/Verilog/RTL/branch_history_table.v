// Take size = 32 --> ideal for amount of instructions + is factor of 2
// This means we need 2^n = 32 or n = 5 bits of the lower part of the PC
// Each memory cell has 2 bits

module branch_history_table #(
		parameter integer LOWER = 7
	)(
		input wire	clk,
		input wire	arst_n,
		input wire	en,
		input wire	[LOWER - 1:0] read_addr,
		input wire	[LOWER - 1:0] write_addr,
		input wire 	was_taken,
		input wire	jumped,

		output reg	prediction
	);
	integer read_row, write_row;

	reg r_prediction;

	reg [1:0] state_row0, state_row1, state_row2, state_row3, state_row4, state_row5, state_row6, state_row7, state_row8, state_row9;
	reg [1:0] state_row10, state_row11, state_row12, state_row13, state_row14, state_row15, state_row16, state_row17, state_row18, state_row19;
	reg [1:0] state_row20, state_row21, state_row22, state_row23, state_row24, state_row25, state_row26, state_row27, state_row28, state_row29;
	reg [1:0] state_row30, state_row31;

	initial state_row0 = 0;
	initial state_row1 = 0;
	initial state_row2 = 0;
	initial state_row3 = 0;
	initial state_row4 = 0;
	initial state_row5 = 0;
	initial state_row6 = 0;
	initial state_row7 = 0;
	initial state_row8 = 0;
	initial state_row9 = 0;
	initial state_row10 = 0;
	initial state_row11 = 0;
	initial state_row12 = 0;
	initial state_row13 = 0;
	initial state_row14 = 0;
	initial state_row15 = 0;
	initial state_row16 = 0;
	initial state_row17 = 0;
	initial state_row18 = 0;
	initial state_row19 = 0;
	initial state_row20 = 0;
	initial state_row21 = 0;
	initial state_row22 = 0;
	initial state_row23 = 0;
	initial state_row24 = 0;
	initial state_row25 = 0;
	initial state_row26 = 0;
	initial state_row27 = 0;
	initial state_row28 = 0;
	initial state_row29 = 0;
	initial state_row30 = 0;
	initial state_row31 = 0;

	always@(*) begin
		write_row = write_addr/4;
		read_row = read_addr/4;
	end

	always@(posedge clk)begin
		if(en == 1'b1) begin
			case(read_row)
				0:	r_prediction <= state_row0[1];
				1:	r_prediction <= state_row1[1];
				2:	r_prediction <= state_row2[1];
				3:	r_prediction <= state_row3[1];
				4:	r_prediction <= state_row4[1];
				5:	r_prediction <= state_row5[1];
				6:	r_prediction <= state_row6[1];
				7:	r_prediction <= state_row7[1];
				8:	r_prediction <= state_row8[1];
				9:	r_prediction <= state_row9[1];
				10:	r_prediction <= state_row10[1];
				11:	r_prediction <= state_row11[1];
				12:	r_prediction <= state_row12[1];
				13:	r_prediction <= state_row13[1];
				14:	r_prediction <= state_row14[1];
				15:	r_prediction <= state_row15[1];
				16:	r_prediction <= state_row16[1];
				17:	r_prediction <= state_row17[1];
				18:	r_prediction <= state_row18[1];
				19:	r_prediction <= state_row19[1];
				20:	r_prediction <= state_row20[1];
				21:	r_prediction <= state_row21[1];
				22:	r_prediction <= state_row22[1];
				23:	r_prediction <= state_row23[1];
				24:	r_prediction <= state_row24[1];
				25:	r_prediction <= state_row25[1];
				26:	r_prediction <= state_row26[1];
				27:	r_prediction <= state_row27[1];
				28:	r_prediction <= state_row28[1];
				29:	r_prediction <= state_row29[1];
				30:	r_prediction <= state_row30[1];
				31:	r_prediction <= state_row31[1];
			endcase

			if(was_taken | jumped)
				case(write_row)
					0:	if(~&(state_row0 & 2'b11)) state_row0 = state_row0 + 2'b01;
					1:	if(~&(state_row1 & 2'b11)) state_row1 = state_row1 + 2'b01;
					2:	if(~&(state_row2 & 2'b11)) state_row2 = state_row2 + 2'b01;
					3:	if(~&(state_row3 & 2'b11)) state_row3 = state_row3 + 2'b01;
					4:	if(~&(state_row4 & 2'b11)) state_row4 = state_row4 + 2'b01;
					5:	if(~&(state_row5 & 2'b11)) state_row5 = state_row5 + 2'b01;
					6:	if(~&(state_row6 & 2'b11)) state_row6 = state_row6 + 2'b01;
					7:	if(~&(state_row7 & 2'b11)) state_row7 = state_row7 + 2'b01;
					8:	if(~&(state_row8 & 2'b11)) state_row8 = state_row8 + 2'b01; 
					9:	if(~&(state_row9 & 2'b11)) state_row9 = state_row9 + 2'b01; 
					10:	if(~&(state_row10 & 2'b11)) state_row10 = state_row10 + 2'b01;
					11:	if(~&(state_row11 & 2'b11)) state_row11 = state_row11 + 2'b01;
					12:	if(~&(state_row12 & 2'b11)) state_row12 = state_row12 + 2'b01;
					13:	if(~&(state_row13 & 2'b11)) state_row13 = state_row13 + 2'b01;
					14:	if(~&(state_row14 & 2'b11)) state_row14 = state_row14 + 2'b01;
					15:	if(~&(state_row15 & 2'b11)) state_row15 = state_row15 + 2'b01;
					16:	if(~&(state_row16 & 2'b11)) state_row16 = state_row16 + 2'b01;
					17:	if(~&(state_row17 & 2'b11)) state_row17 = state_row17 + 2'b01;
					18:	if(~&(state_row18 & 2'b11)) state_row18 = state_row18 + 2'b01;
					19:	if(~&(state_row19 & 2'b11)) state_row19 = state_row19 + 2'b01;
					20:	if(~&(state_row20 & 2'b11)) state_row20 = state_row20 + 2'b01;
					21:	if(~&(state_row21 & 2'b11)) state_row21 = state_row21 + 2'b01;
					22:	if(~&(state_row22 & 2'b11)) state_row22 = state_row22 + 2'b01;
					23:	if(~&(state_row23 & 2'b11)) state_row23 = state_row23 + 2'b01;
					24:	if(~&(state_row24 & 2'b11)) state_row24 = state_row24 + 2'b01;
					25:	if(~&(state_row25 & 2'b11)) state_row25 = state_row25 + 2'b01;
					26:	if(~&(state_row26 & 2'b11)) state_row26 = state_row26 + 2'b01;
					27:	if(~&(state_row27 & 2'b11)) state_row27 = state_row27 + 2'b01;
					28:	if(~&(state_row28 & 2'b11)) state_row28 = state_row28 + 2'b01;
					29:	if(~&(state_row29 & 2'b11)) state_row29 = state_row29 + 2'b01;
					30:	if(~&(state_row30 & 2'b11)) state_row30 = state_row30 + 2'b01;
					31:	if(~&(state_row31 & 2'b11)) state_row31 = state_row31 + 2'b01;
				endcase
			else
				case(write_row)
					0:	if(|(state_row0 | 2'b00)) state_row0 = state_row0 - 2'b01;
					1:	if(|(state_row1 | 2'b00)) state_row1 = state_row1 - 2'b01;
					2:	if(|(state_row2 | 2'b00)) state_row2 = state_row2 - 2'b01;
					3:	if(|(state_row3 | 2'b00)) state_row3 = state_row3 - 2'b01;
					4:	if(|(state_row4 | 2'b00)) state_row4 = state_row4 - 2'b01;
					5:	if(|(state_row5 | 2'b00)) state_row5 = state_row5 - 2'b01;
					6:	if(|(state_row6 | 2'b00)) state_row6 = state_row6 - 2'b01;
					7:	if(|(state_row7 | 2'b00)) state_row7 = state_row7 - 2'b01;
					8:	if(|(state_row8 | 2'b00)) state_row8 = state_row8 - 2'b01; 
					9:	if(|(state_row9 | 2'b00)) state_row9 = state_row9 - 2'b01; 
					10:	if(|(state_row10 | 2'b00)) state_row10 = state_row10 - 2'b01;
					11:	if(|(state_row11 | 2'b00)) state_row11 = state_row11 - 2'b01;
					12:	if(|(state_row12 | 2'b00)) state_row12 = state_row12 - 2'b01;
					13:	if(|(state_row13 | 2'b00)) state_row13 = state_row13 - 2'b01;
					14:	if(|(state_row14 | 2'b00)) state_row14 = state_row14 - 2'b01;
					15:	if(|(state_row15 | 2'b00)) state_row15 = state_row15 - 2'b01;
					16:	if(|(state_row16 | 2'b00)) state_row16 = state_row16 - 2'b01;
					17:	if(|(state_row17 | 2'b00)) state_row17 = state_row17 - 2'b01;
					18:	if(|(state_row18 | 2'b00)) state_row18 = state_row18 - 2'b01;
					19:	if(|(state_row19 | 2'b00)) state_row19 = state_row19 - 2'b01;
					20:	if(|(state_row20 | 2'b00)) state_row20 = state_row20 - 2'b01;
					21:	if(|(state_row21 | 2'b00)) state_row21 = state_row21 - 2'b01;
					22:	if(|(state_row22 | 2'b00)) state_row22 = state_row22 - 2'b01;
					23:	if(|(state_row23 | 2'b00)) state_row23 = state_row23 - 2'b01;
					24:	if(|(state_row24 | 2'b00)) state_row24 = state_row24 - 2'b01;
					25:	if(|(state_row25 | 2'b00)) state_row25 = state_row25 - 2'b01;
					26:	if(|(state_row26 | 2'b00)) state_row26 = state_row26 - 2'b01;
					27:	if(|(state_row27 | 2'b00)) state_row27 = state_row27 - 2'b01;
					28:	if(|(state_row28 | 2'b00)) state_row28 = state_row28 - 2'b01;
					29:	if(|(state_row29 | 2'b00)) state_row29 = state_row29 - 2'b01;
					30:	if(|(state_row30 | 2'b00)) state_row30 = state_row30 - 2'b01;
					31:	if(|(state_row31 | 2'b00)) state_row31 = state_row31 - 2'b01;
				endcase
		end
   	end

	assign prediction = r_prediction;
endmodule