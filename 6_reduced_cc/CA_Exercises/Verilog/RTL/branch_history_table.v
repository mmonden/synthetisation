// Take size = 32 --> ideal for amount of instructions + is factor of 2
// This means we need 2^n = 32 or n = 5 bits of the lower part of the PC
// Each memory cell has 2 bits

//  The non ext will correspond to always read
//  The ext signal will correspond to write
//  There will be only one memory module: mem_sel=0 and N_MEMS=1
module branch_history_table(
		input wire	clk,
		input wire	arst_n,
		input wire	en,
		input wire	[4:0] read_addr,
		input wire	[4:0] write_addr,	// the prev pc
		input wire 	was_taken,
		output reg	prediction
	);
	integer upper_bit_read, upper_bit_write;

	reg r_prediction;
	reg[63:0] states;

	always@(posedge clk, negedge arst_n)begin
		if(arst_n==0)begin
			r_prediction <= 0;
		end
   	end

	always@(*) begin
		if(en == 1'b1) begin
			upper_bit_write = write_addr*2 - 1;
			upper_bit_read = read_addr*2 - 1;

			case(states[upper_bit_write -: 1])
				2'b00:
					if(was_taken)
						states[upper_bit_write -: 1] <= 2'b01;
					else
						states[upper_bit_write -: 1] <= 2'b00;
				2'b01:
					if(was_taken)
						states[upper_bit_write -: 1] <= 2'b11;
					else
						states[upper_bit_write -: 1] <= 2'b00;
				2'b10:
					if(was_taken)
						states[upper_bit_write -: 1] <= 2'b11;
					else
						states[upper_bit_write -: 1] <= 2'b00;
				2'b11:
					if(!was_taken)
						states[upper_bit_write -: 1] <= 2'b10;
					else
						states[upper_bit_write -: 1] <= 2'b11;
				default:
					states[upper_bit_write -: 1] <= 2'b00;
			endcase

			case(states[upper_bit_read -: 1])
				2'b00:	r_prediction <= 1'b0;
				2'b01:	r_prediction <= 1'b0;
				2'b10:	r_prediction <= 1'b1;
				2'b11:	r_prediction <= 1'b1;
				default:	r_prediction <= 1'b0;
			endcase
		end
	end

	assign prediction = r_prediction;
endmodule