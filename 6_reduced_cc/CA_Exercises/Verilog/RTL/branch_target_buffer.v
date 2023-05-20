module branch_target_buffer#(
      parameter integer LOWER = 5
   )(
		input wire	clk,
		input wire	arst_n,
		input wire	en,
		input wire	[4:0] read_addr,
		input wire	[4:0] write_addr,	// the prev pc
		input wire 	was_taken,
		output reg  [63:0]	predicted_branch_pc
	);
	integer upper_bit_read, upper_bit_write;
   integer i;

	reg r_prediction;
	reg[64-LOWER+63:0] states[0:2**LOWER - 1]; // higer_pc_part (x-bits) | branch_pc_part (64-bits)
	initial for(i = 0; i < 2**LOWER; i++) states[i] = 0;

	always@(posedge clk, negedge arst_n) begin
		if(arst_n==0)begin
         // for(i = 0; i < 2**LOWER; i++)
			   r_prediction <= 0;
		end
   end

	always@(*) begin
		if(en == 1'b1) begin
			upper_bit_write = write_addr*2 + 1;
			upper_bit_read = read_addr*2 + 1;

			// case(states[upper_bit_write -: 1])
			// 	2'b00:
			// 		if(was_taken)
			// 			states[upper_bit_write -: 1] <= 2'b01;
			// 		else
			// 			states[upper_bit_write -: 1] <= 2'b00;
			// 	2'b01:
			// 		if(was_taken)
			// 			states[upper_bit_write -: 1] <= 2'b11;
			// 		else
			// 			states[upper_bit_write -: 1] <= 2'b00;
			// 	2'b10:
			// 		if(was_taken)
			// 			states[upper_bit_write -: 1] <= 2'b11;
			// 		else
			// 			states[upper_bit_write -: 1] <= 2'b00;
			// 	2'b11:
			// 		if(!was_taken)
			// 			states[upper_bit_write -: 1] <= 2'b10;
			// 		else
			// 			states[upper_bit_write -: 1] <= 2'b11;
			// 	default:
			// 		states[upper_bit_write -: 1] <= 2'b00;
			// endcase

			// case(states[upper_bit_read -: 1])
			// 	2'b00:	r_prediction <= 1'b0;
			// 	2'b01:	r_prediction <= 1'b0;
			// 	2'b10:	r_prediction <= 1'b1;
			// 	2'b11:	r_prediction <= 1'b1;
			// 	default:	r_prediction <= 1'b0;
			// endcase
		end
	end

	assign prediction = r_prediction;

endmodule