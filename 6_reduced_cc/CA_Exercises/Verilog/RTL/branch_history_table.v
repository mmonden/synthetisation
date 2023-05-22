// Take size = 32 --> ideal for amount of instructions + is factor of 2
// This means we need 2^n = 32 or n = 5 bits of the lower part of the PC
// Each memory cell has 2 bits

module branch_history_table #(
		parameter integer LOWER = 7
	)(
		input wire	clk,
		input wire	arst_n,
		input wire	en,
		input wire	[LOWER - 1:0] current_pc,
		input wire	[LOWER - 1:0] write_pc,
		input wire 	was_taken,
		input wire	jumped,
		output reg	prediction
	);
	integer row_index;

	reg r_predicted;

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

	always@(posedge clk, negedge arst_n) begin
		if(arst_n==0)begin
				r_predicted <= 0;
		end

		if(en == 1'b1) begin
			row_index = prev_pc[LOWER - 1:0]/4;

			if(was_taken)
				case(row_index)
					0: if(~&(state_row0 & 2'b11)) state_row0 <= state_row0 + 2'b01;
					1: if(~&(state_row1 & 2'b11)) state_row1 <= state_row1 + 2'b01;
					2: if(~&(state_row2 & 2'b11)) state_row2 <= state_row2 + 2'b01;
					3: if(~&(state_row3 & 2'b11)) state_row3 <= state_row3 + 2'b01;
					4: if(~&(state_row4 & 2'b11)) state_row4 <= state_row4 + 2'b01;
					5: if(~&(state_row5 & 2'b11)) state_row5 <= state_row5 + 2'b01;
					6: if(~&(state_row6 & 2'b11)) state_row6 <= state_row6 + 2'b01;
					7: if(~&(state_row7 & 2'b11)) state_row7 <= state_row7 + 2'b01;
				endcase
			else if(jumped)
				case(row_index)
					0: if(~&(state_row0 & 2'b11)) state_row0 <= state_row0 + 2'b01;
					1: if(~&(state_row1 & 2'b11)) state_row1 <= state_row1 + 2'b01;
					2: if(~&(state_row2 & 2'b11)) state_row2 <= state_row2 + 2'b01;
					3: if(~&(state_row3 & 2'b11)) state_row3 <= state_row3 + 2'b01;
					4: if(~&(state_row4 & 2'b11)) state_row4 <= state_row4 + 2'b01;
					5: if(~&(state_row5 & 2'b11)) state_row5 <= state_row5 + 2'b01;
					6: if(~&(state_row6 & 2'b11)) state_row6 <= state_row6 + 2'b01;
					7: if(~&(state_row7 & 2'b11)) state_row7 <= state_row7 + 2'b01;
				endcase
			else
				case(row_index)
					0: if(|(state_row0 | 2'b00)) state_row0 <= state_row0 + 2'b01;
					1: if(|(state_row1 | 2'b00)) state_row1 <= state_row1 + 2'b01;
					2: if(|(state_row2 | 2'b00)) state_row2 <= state_row2 + 2'b01;
					3: if(|(state_row3 | 2'b00)) state_row3 <= state_row3 + 2'b01;
					4: if(|(state_row4 | 2'b00)) state_row4 <= state_row4 + 2'b01;
					5: if(|(state_row5 | 2'b00)) state_row5 <= state_row5 + 2'b01;
					6: if(|(state_row6 | 2'b00)) state_row6 <= state_row6 + 2'b01;
					7: if(|(state_row7 | 2'b00)) state_row7 <= state_row7 + 2'b01;
				endcase

			row_index = current_pc[LOWER - 1:0]/4;
			
			case(row_index)
				0: if(~|(current_pc ^ state_row0[127:64])) r_predicted_branch_pc <= state_row0[63:0]; else r_predicted_branch_pc <= 0; 
				1: if(~|(current_pc ^ state_row1[127:64])) r_predicted_branch_pc <= state_row1[63:0]; else r_predicted_branch_pc <= 0; 
				2: if(~|(current_pc ^ state_row2[127:64])) r_predicted_branch_pc <= state_row2[63:0]; else r_predicted_branch_pc <= 0; 
				3: if(~|(current_pc ^ state_row3[127:64])) r_predicted_branch_pc <= state_row3[63:0]; else r_predicted_branch_pc <= 0; 
				4: if(~|(current_pc ^ state_row4[127:64])) r_predicted_branch_pc <= state_row4[63:0]; else r_predicted_branch_pc <= 0; 
				5: if(~|(current_pc ^ state_row5[127:64])) r_predicted_branch_pc <= state_row5[63:0]; else r_predicted_branch_pc <= 0; 
				6: if(~|(current_pc ^ state_row6[127:64])) r_predicted_branch_pc <= state_row6[63:0]; else r_predicted_branch_pc <= 0; 
				7: if(~|(current_pc ^ state_row7[127:64])) r_predicted_branch_pc <= state_row7[63:0]; else r_predicted_branch_pc <= 0; 
			endcase
		end
	end

	assign prediction = r_predicted;
endmodule