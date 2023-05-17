module forward_unit #(
   parameter integer DATA_W = 16
   )(
	input wire writeback1_EX_MEM_output,	
	input wire writeback1_MEM_WB_output,	
	input wire [4:0] IF_ID_rs2_output,         // rs2 //IF_ID_rs2_output
	input wire [4:0] IF_ID_rs1_output,         // rs1 //inst_imm_ID_EX_output

	input wire [4:0] inst2_EX_MEM_output,    // rd
	input wire [4:0] inst2_MEM_WB_output,    // rd

	output reg [1:0] mux_bottom,
	output reg [1:0] mux_top
   );

	always@(*) begin
		if(writeback1_EX_MEM_output && (inst2_EX_MEM_output != 4'b0) && (inst2_EX_MEM_output == IF_ID_rs1_output)) begin
			mux_top = 2'b10;
		end else if(writeback1_MEM_WB_output && (inst2_MEM_WB_output != 4'b0) 
							&& !(writeback1_EX_MEM_output && (inst2_EX_MEM_output != 0) && (inst2_EX_MEM_output == IF_ID_rs1_output)) 
							&& (inst2_MEM_WB_output == IF_ID_rs1_output)) begin
			mux_top = 2'b01;
		end else begin
			mux_top = 2'b00;
		end

		if(writeback1_EX_MEM_output && (inst2_EX_MEM_output != 4'b0) && (inst2_EX_MEM_output == IF_ID_rs2_output)) begin
			mux_bottom = 2'b10;
		end else if(writeback1_MEM_WB_output && (inst2_MEM_WB_output != 4'b0) 
							&& !(writeback1_EX_MEM_output && (inst2_EX_MEM_output != 0) && (inst2_EX_MEM_output == IF_ID_rs2_output)) 
							&& (inst2_MEM_WB_output == IF_ID_rs2_output)) begin
			mux_bottom = 2'b01;
		end else begin 
			mux_bottom = 2'b00;
		end
	end

endmodule