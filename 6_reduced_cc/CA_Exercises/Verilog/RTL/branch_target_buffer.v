module branch_target_buffer#(
      parameter integer LOWER = 5
   )(
		input wire	clk,
		input wire	arst_n,
		input wire	en,
		input wire 	[63:0] current_pc,
      input wire	[63:0] prev_pc,
      input wire  [63:0] branch_pc,
      input wire  [63:0] jump_pc,
      input wire 	was_taken,
      input wire  jumped,
		output reg  [63:0] predicted_branch_pc
	);
	integer row_index;
   integer i;

   reg [63:0] r_predicted_branch_pc;

	// reg [127:0] states[0:2**LOWER - 1]; // higer_pc_part (x-bits) | branch_pc_part (64-bits)
	// initial for(i = 0; i < 2**LOWER; i++) states[i] <= 0;

   reg [127:0] state_row0;
   reg [127:0] state_row1;
   reg [127:0] state_row2;
   reg [127:0] state_row3;
   reg [127:0] state_row4;
   reg [127:0] state_row5;
   reg [127:0] state_row6;
   reg [127:0] state_row7;

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
			   r_predicted_branch_pc <= 0;
            // for(i = 0; i < 2**LOWER; i++) states[i] <= 0;
		end

      if(en == 1'b1) begin
			row_index = prev_pc[LOWER - 1:0]/4;

         if(was_taken)
			   // states[row_index] <= {prev_pc, branch_pc};
            case(row_index)
               0: state_row0 <= {prev_pc, branch_pc};
               1: state_row1 <= {prev_pc, branch_pc};
               2: state_row2 <= {prev_pc, branch_pc};
               3: state_row3 <= {prev_pc, branch_pc};
               4: state_row4 <= {prev_pc, branch_pc};
               5: state_row5 <= {prev_pc, branch_pc};
               6: state_row6 <= {prev_pc, branch_pc};
               7: state_row7 <= {prev_pc, branch_pc};
            endcase

         if(jumped)
            // states[row_index] <= {prev_pc, jump_pc};
            case(row_index)
               0: state_row0 <= {prev_pc, jump_pc};
               1: state_row1 <= {prev_pc, jump_pc};
               2: state_row2 <= {prev_pc, jump_pc};
               3: state_row3 <= {prev_pc, jump_pc};
               4: state_row4 <= {prev_pc, jump_pc};
               5: state_row5 <= {prev_pc, jump_pc};
               6: state_row6 <= {prev_pc, jump_pc};
               7: state_row7 <= {prev_pc, jump_pc};
            endcase

			row_index = current_pc[LOWER - 1:0]/4;
            // r_predicted_branch_pc <= states[row_index][63:0];
         case(row_index)
            0: if(~|(current_pc ^ state_row0[127:64])) r_predicted_branch_pc = state_row0[63:0]; else r_predicted_branch_pc = 0; 
            1: if(~|(current_pc ^ state_row1[127:64])) r_predicted_branch_pc = state_row1[63:0]; else r_predicted_branch_pc = 0; 
            2: if(~|(current_pc ^ state_row2[127:64])) r_predicted_branch_pc = state_row2[63:0]; else r_predicted_branch_pc = 0; 
            3: if(~|(current_pc ^ state_row3[127:64])) r_predicted_branch_pc = state_row3[63:0]; else r_predicted_branch_pc = 0; 
            4: if(~|(current_pc ^ state_row4[127:64])) r_predicted_branch_pc = state_row4[63:0]; else r_predicted_branch_pc = 0; 
            5: if(~|(current_pc ^ state_row5[127:64])) r_predicted_branch_pc = state_row5[63:0]; else r_predicted_branch_pc = 0; 
            6: if(~|(current_pc ^ state_row6[127:64])) r_predicted_branch_pc = state_row6[63:0]; else r_predicted_branch_pc = 0; 
            7: if(~|(current_pc ^ state_row7[127:64])) r_predicted_branch_pc = state_row7[63:0]; else r_predicted_branch_pc = 0; 
         endcase
		end
   end

	assign predicted_branch_pc = r_predicted_branch_pc;

endmodule