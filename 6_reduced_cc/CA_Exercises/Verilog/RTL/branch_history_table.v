// Take size = 32 --> ideal for amount of instructions + is factor of 2
// This means we need 2^n = 32 or n = 5 bits of the lower part of the PC
// Each memory cell has 2 bits

module branch_history_table #(
		parameter integer LOWER = 5
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

	reg [1:0] state_row0;
	reg [1:0] state_row1;
	reg [1:0] state_row2;
	reg [1:0] state_row3;
	reg [1:0] state_row4;
	reg [1:0] state_row5;
	reg [1:0] state_row6;
	reg [1:0] state_row7;

	initial state_row0 = 0;
	initial state_row1 = 0;
	initial state_row2 = 0;
	initial state_row3 = 0;
	initial state_row4 = 0;
	initial state_row5 = 0;
	initial state_row6 = 0;
	initial state_row7 = 0;

	always@(*) begin
		write_row = write_addr/4;
		read_row = read_addr/4;
	end

	always@(posedge clk)begin
		if(en == 1'b1) begin
			case(read_row)
				0:	prediction <= state_row0[1];
				1:	prediction <= state_row1[1];
				2:	prediction <= state_row2[1];
				3:	prediction <= state_row3[1];
				4:	prediction <= state_row4[1];
				5:	prediction <= state_row5[1];
				6:	prediction <= state_row6[1];
				7:	prediction <= state_row7[1];
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
				endcase
		end
   	end
endmodule