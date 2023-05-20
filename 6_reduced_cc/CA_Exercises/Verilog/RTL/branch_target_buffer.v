module branch_target_buffer#(
      parameter integer LOWER = 5
   )(
		input wire	clk,
		input wire	arst_n,
		input wire	en,
		input wire 	[63:0] current_pc,
      input wire	[63:0] prev_pc,
      input wire  [63:0] branch_pc,
      input wire 	was_taken,
		output reg  [63:0] predicted_branch_pc
	);
	integer row_index;
   integer i;

   reg [63:0] r_predicted_branch_pc;

	reg [64-LOWER+63:0] states[0:2**LOWER - 1]; // higer_pc_part (x-bits) | branch_pc_part (64-bits)
	initial for(i = 0; i < 2**LOWER; i++) states[i] <= 0;

	always@(posedge clk, negedge arst_n) begin
		if(arst_n==0)begin
			   r_prediction <= 0;
            for(i = 0; i < 2**LOWER; i++) states[i] <= 0;
		end

      if(en == 1'b1) begin
			row_index = current_pc[LOWER - 1:0];

         if(was_taken)
			   states[row_index] <= {prev_pc[64-LOWER+63:64], branch_pc};

			if(current_pc[63:LOWER] == states[row_index][64-LOWER+63:64]) 
            r_predicted_branch_pc <= states[row_index][63:0];
         else
            r_predicted_branch_pc <= 0; 
		end
   end

	assign predicted_branch_pc = r_predicted_branch_pc;

endmodule