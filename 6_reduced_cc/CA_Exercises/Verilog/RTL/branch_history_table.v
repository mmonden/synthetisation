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
	integer upper_bit_read, upper_bit_write;

	reg r_prediction;

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
	initial state_row4 = 1;
	initial state_row5 = 0;
	initial state_row6 = 0;
	initial state_row7 = 0;

	always@(*) begin
		write_row = write_addr/4;
		read_row = read_addr/4;
	end

	always@(posedge clk, negedge arst_n)begin
		if(arst_n==0)begin
			r_prediction <= 0;
			states <= 0;
		end

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
			endcase

			// case(states[upper_bit_write +: 1])
			// 	2'b00:
			// 		if(was_taken | jumped)
			// 			states[upper_bit_write +: 1] <= 2'b01;
			// 		else
			// 			states[upper_bit_write +: 1] <= 2'b00;
			// 	2'b01:
			// 		if(was_taken | jumped)
			// 			states[upper_bit_write +: 1] <= 2'b10;
			// 		else
			// 			states[upper_bit_write +: 1] <= 2'b01;
			// 	2'b10:
			// 		if(was_taken | jumped)
			// 			states[upper_bit_write +: 1] <= 2'b11;
			// 		else
			// 			states[upper_bit_write +: 1] <= 2'b10;
			// 	2'b11:
			// 		if(!was_taken | !jumped)
			// 			states[upper_bit_write +: 1] <= 2'b11;
			// 		else
			// 			states[upper_bit_write +: 1] <= 2'b10;
			// endcase
		end
   	end

	assign prediction = r_prediction;
endmodule