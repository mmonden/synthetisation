module hazard_detection_unit
(
	input memread_ID_EX_input,
	input [1:0] alu_op_input,
	input reg_dst_input,
	input branch_input,
	input mem_read_input,
	input mem_2_reg_input,
	input mem_write_input,
	input alu_src_input,
	input reg_write_input,
	input jump_input,
	input wire [4:0] IF_ID_rs1_input,			// rs1
	input wire [4:0] IF_ID_rs2_input,			// rs2
	input wire [4:0] inst2_ID_EX_input,

	output reg [1:0] alu_op_output,
	output reg reg_dst_output,
	output reg branch_output,
	output reg mem_read_output,
	output reg mem_2_reg_output,
	output reg mem_write_output,
	output reg alu_src_output,
	output reg reg_write_output,
	output reg jump_output,
	output reg prevent_update_pc,
	output reg prevent_update_reg_IF_ID
);
	always@(*) begin
		if(memread_ID_EX_input & (~|(inst2_ID_EX_input ^ IF_ID_rs1_input) | ~|(inst2_ID_EX_input ^ IF_ID_rs2_input))) begin
			alu_op_output = 2'b00;
			reg_dst_output = 1'b0;
			branch_output = 1'b0;
			mem_read_output = 1'b0;
			mem_2_reg_output = 1'b0;
			mem_write_output = 1'b0;
			alu_src_output = 1'b0;
			reg_write_output = 1'b0;
			jump_output = 1'b0;
			prevent_update_pc = 1'b1;
			prevent_update_reg_IF_ID = 1'b1;
		end else begin
			alu_op_output = alu_op_input;
			reg_dst_output = reg_dst_input;
			branch_output = branch_input;
			mem_read_output = mem_read_input;
			mem_2_reg_output = mem_2_reg_input;
			mem_write_output = mem_write_input;
			alu_src_output = alu_src_input;
			reg_write_output = reg_write_input;
			jump_output = jump_input;
			prevent_update_pc = 1'b0;
			prevent_update_reg_IF_ID = 1'b0;
		end
	end

endmodule