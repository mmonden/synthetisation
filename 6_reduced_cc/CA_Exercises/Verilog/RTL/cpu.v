//Module: CPU
//Function: CPU is the top design of the RISC-V processor

//Inputs:
//	clk: main clock
//	arst_n: reset 
// enable: Starts the execution
//	addr_ext: Address for reading/writing content to Instruction Memory
//	wen_ext: Write enable for Instruction Memory
// ren_ext: Read enable for Instruction Memory
//	wdata_ext: Write word for Instruction Memory
//	addr_ext_2: Address for reading/writing content to Data Memory
//	wen_ext_2: Write enable for Data Memory
// ren_ext_2: Read enable for Data Memory
//	wdata_ext_2: Write word for Data Memory

// Outputs:
//	rdata_ext: Read data from Instruction Memory
//	rdata_ext_2: Read data from Data Memory

module cpu(
		input  wire			  clk,
		input  wire         arst_n,
		input  wire         enable,
		input  wire	[63:0]  addr_ext,
		input  wire         wen_ext,
		input  wire         ren_ext,
		input  wire [31:0]  wdata_ext,
		input  wire	[63:0]  addr_ext_2,
		input  wire         wen_ext_2,
		input  wire         ren_ext_2,
		input  wire [63:0]  wdata_ext_2,
		
		output wire	[31:0]  rdata_ext,
		output wire	[63:0]  rdata_ext_2

	);

wire              zero_flag;
wire [      63:0] branch_pc,updated_pc,current_pc,jump_pc;
wire [      31:0] instruction;
wire [       1:0] alu_op;
wire [       3:0] alu_control;
wire              reg_dst, branch, mem_read, mem_2_reg,
						mem_write, alu_src, reg_write, jump;
wire [       4:0] regfile_waddr;
wire [      63:0] regfile_wdata, mem_data, alu_out,
						regfile_rdata_1, regfile_rdata_2,
						alu_operand_2;

wire signed [63:0] immediate_extended;

wire [31:0]	instruction_IF_ID;
wire [63:0] current_pc_IF_ID, regfile_rdata_1_ID_EX, regfile_rdata_2_ID_EX, regfile_rdata_2_EX_MEM, immediate_extended_ID_EX, alu_out_EX_MEM, alu_out_MEM_WB, mem_data_MEM_WB; //current_pc_ID_EX, branch_pc_EX_MEM, jump_pc_EX_MEM,;
wire [1:0] alu_op_ID_EX;
wire [4:0] inst1_ID_EX;	//also includes one extra bit for the extra operation that was implemented.
wire [4:0] inst2_ID_EX, inst2_EX_MEM, inst2_MEM_WB, IF_ID_rs1, IF_ID_rs2;

wire [1:0]	mux_control_A, mux_control_B, alu_op_tomux;
wire [63:0]	mux_output_A, mux_output_B;

wire flush_ID_EX, BHT_signal, prediction;
wire [63:0] predicted_branch_pc, predicted_pc_IF_ID;

immediate_extend_unit immediate_extend_u(
	 .instruction         (instruction_IF_ID),
	 .immediate_extended  (immediate_extended)
);

pc #(
	.DATA_W(64)
) program_counter (
	.clk       (clk       ),
	.arst_n    (arst_n    ),
	.hazard		(PCWrite),
	.branch_pc (branch_pc ),
	.jump_pc   (jump_pc   ),
	.predicted_pc(predicted_branch_pc),
	.zero_flag (zero_flag_imposter_immediately_caculated_in_ID_stage),
	.prediction (prediction),
	.branch    (branch    ),
	.jump      (jump    ),
	.current_pc(current_pc),
	.enable    (enable    ),
	.updated_pc(updated_pc),
	.was_taken(BHT_signal)
);

check_equality brc (
	.regfile_rdata_1(regfile_rdata_1),
	.regfile_rdata_2(regfile_rdata_2),
	.eq(zero_flag_imposter_immediately_caculated_in_ID_stage)
);

branch_history_table BHT (
	.clk		(clk),
	.arst_n		(arst_n),
	.en			(enable),
	.read_addr	(updated_pc[6:0]),
	.write_addr	(current_pc_IF_ID[6:0]),
	.was_taken	(BHT_signal),
	.jumped		(jump),

	.prediction	(prediction)
);

branch_target_buffer BTB (
	.clk		(clk),
	.arst_n		(arst_n),
	.en			(enable),
	.current_pc	(updated_pc),
	.prev_pc	(current_pc_IF_ID),
	.branch_pc	(branch_pc),
	.jump_pc	(jump_pc),
	.was_taken	(BHT_signal),
	.jumped		(jump),

	.predicted_branch_pc	(predicted_branch_pc)
);

sram_BW32 #(
	.ADDR_W(9 )
) instruction_memory(
	.clk      (clk           ),
	.addr     (current_pc    ),
	.wen      (1'b0          ),
	.ren      (1'b1          ),
	.wdata    (32'b0         ),
	.rdata    (instruction   ),   
	.addr_ext (addr_ext      ),
	.wen_ext  (wen_ext       ), 
	.ren_ext  (ren_ext       ),
	.wdata_ext(wdata_ext     ),
	.rdata_ext(rdata_ext     )
);

sram_BW64 #(
	.ADDR_W(10)
) data_memory(
	.clk      (clk            ),
	.addr     (alu_out_EX_MEM ),
	.wen      (mem_write_EX_MEM),
	.ren      (mem_read_EX_MEM ),
	.wdata    (regfile_rdata_2_EX_MEM),
	.rdata    (mem_data       ),  // output of data memory 
	.addr_ext (addr_ext_2     ),
	.wen_ext  (wen_ext_2      ),
	.ren_ext  (ren_ext_2      ),
	.wdata_ext(wdata_ext_2    ),
	.rdata_ext(rdata_ext_2    )
);

reg_arstn_en_IF_ID #(
	.DATA_W(32)
) signal_pipe_IF_ID (
	.clk        (clk),
	.arst_n     (arst_n),
	.flush		(flush_ID_EX),
	.predicted_pc_IF (predicted_branch_pc),
	.hazard		(IF_IDWrite),
	.din        (instruction),
	.pc			(current_pc),
	.en         (enable),

	.dout       (instruction_IF_ID),
	.pcout		(current_pc_IF_ID),
	.predicted_pc_IF_out (predicted_pc_IF_ID)
);

reg_arstn_en_ID_EX #(
	.DATA_W(32)
) signal_pipe_ID_EX (
	.clk        (clk),
	.arst_n     (arst_n),
	.dreg1_ID_EX_input      (regfile_rdata_1),
	.dreg2_ID_EX_input      (regfile_rdata_2),
	.inst_imm_ID_EX_input	(immediate_extended),
	.inst1_ID_EX_input		({instruction_IF_ID[30], instruction_IF_ID[25], instruction_IF_ID[14:12]}),	//modified
	.inst2_ID_EX_input		(instruction_IF_ID[11:7]),
	.IF_ID_rs1_input		(instruction_IF_ID[19:15]),
	.IF_ID_rs2_input		(instruction_IF_ID[24:20]),
	// .pc_ID_EX_input			(current_pc_IF_ID),

	//	Control signals
	.writeback1_ID_EX_input		(reg_write),
	.writeback2_ID_EX_input		(mem_2_reg),
	.memwrite_ID_EX_input		(mem_write),
	.memread_ID_EX_input		(mem_read),
	// .memjump_ID_EX_input		(jump),
	// .membranch_ID_EX_input		(branch),
	.alusrc_ID_EX_input			(alu_src),
	.aluop_ID_EX_input			(alu_op),
	.en         (enable),

	//	Output
	.dreg1_ID_EX_output      (regfile_rdata_1_ID_EX),
	.dreg2_ID_EX_output      (regfile_rdata_2_ID_EX),
	.inst_imm_ID_EX_output	(immediate_extended_ID_EX),
	.inst1_ID_EX_output		(inst1_ID_EX),
	.inst2_ID_EX_output		(inst2_ID_EX),
	.IF_ID_rs1_output		(IF_ID_rs1),
	.IF_ID_rs2_output		(IF_ID_rs2),
	// .pc_ID_EX_output			(current_pc_ID_EX),
	.writeback1_ID_EX_output		(reg_write_ID_EX),
	.writeback2_ID_EX_output		(mem_2_reg_ID_EX),
	.memwrite_ID_EX_output		(mem_write_ID_EX),
	.memread_ID_EX_output		(mem_read_ID_EX),
	// .memjump_ID_EX_output		(jump_ID_IX),
	// .membranch_ID_EX_output		(branch_ID_EX),
	.alusrc_ID_EX_output			(alu_src_ID_EX),
	.aluop_ID_EX_output			(alu_op_ID_EX)
);

reg_arstn_en_EX_MEM #(
	.DATA_W(32)
) signal_pipe_EX_MEM (
	.clk        (clk),
	.arst_n     (arst_n),
	// .branchpc_EX_MEM_input	(branch_pc),
	// .jumppc_EX_MEM_input	(jump_pc),
	// .zero_EX_MEM_input		(zero_flag),
	.aluout_EX_MEM_input	(alu_out),
	.dreg2_EX_MEM_input		(mux_output_B),
	.inst2_EX_MEM_input		(inst2_ID_EX),

	//	Control signals
	.writeback1_EX_MEM_input	(reg_write_ID_EX),
	.writeback2_EX_MEM_input	(mem_2_reg_ID_EX),
	.memwrite_EX_MEM_input		(mem_write_ID_EX),
	.memread_EX_MEM_input		(mem_read_ID_EX),
	// .memjump_EX_MEM_input		(jump_ID_EX),
	// .membranch_EX_MEM_input		(branch_ID_EX),
	.en         (enable),

	//	Output
	.dreg2_EX_MEM_output		(regfile_rdata_2_EX_MEM),
	// .branchpc_EX_MEM_output		(branch_pc_EX_MEM),
	// .jumppc_EX_MEM_output		(jump_pc_EX_MEM),
	.aluout_EX_MEM_output		(alu_out_EX_MEM),
	// .zero_EX_MEM_output			(zero_flag_EX_MEM),
	.writeback1_EX_MEM_output		(reg_write_EX_MEM),
	.writeback2_EX_MEM_output		(mem_2_reg_EX_MEM),
	.memwrite_EX_MEM_output		(mem_write_EX_MEM),
	.memread_EX_MEM_output		(mem_read_EX_MEM),
	// .memjump_EX_MEM_output		(jump_EX_MEM),
	// .membranch_EX_MEM_output		(branch_EX_MEM),
	.inst2_EX_MEM_output		(inst2_EX_MEM)
);

reg_arstn_en_MEM_WB #(
	.DATA_W(32)
) signal_pipe_MEM_WB (
	.clk        (clk),
	.arst_n     (arst_n),
	.aluout_MEM_WB_input		(alu_out_EX_MEM),
	.memreg_MEM_WB_input		(mem_data),
	.inst2_MEM_WB_input		(inst2_EX_MEM),
	.en         (enable),

	//	Control signals
	.writeback1_MEM_WB_input		(reg_write_EX_MEM),
	.writeback2_MEM_WB_input		(mem_2_reg_EX_MEM),

	//	Output
	.writeback1_MEM_WB_output		(reg_write_MEM_WB),
	.writeback2_MEM_WB_output		(mem_2_reg_MEM_WB),
	.aluout_MEM_WB_output		(alu_out_MEM_WB),
	.memreg_MEM_WB_output		(mem_data_MEM_WB),
	.inst2_MEM_WB_output		(inst2_MEM_WB)
);

control_unit control_unit(
	.opcode   (instruction_IF_ID[6:0]),
	.predicted_pc	(predicted_pc_IF_ID),
	.prediction		(prediction),
	.branchtaken(zero_flag_imposter_immediately_caculated_in_ID_stage & branch),
	.alu_op   (alu_op_tomux),
	.reg_dst  (reg_dst_tomux),
	.branch   (branch_tomux),
	.mem_read (mem_read_tomux),
	.mem_2_reg(mem_2_reg_tomux),
	.mem_write(mem_write_tomux),
	.alu_src  (alu_src_tomux),
	.reg_write(reg_write_tomux),
	.jump     (jump_tomux),
	.flush_ID_EX	(flush_ID_EX)
);

register_file #(
	.DATA_W(64)
) register_file(
	.clk      (clk               ),
	.arst_n   (arst_n            ),
	.reg_write(reg_write_MEM_WB  ),	//modified latest
	.raddr_1  (instruction_IF_ID[19:15]),
	.raddr_2  (instruction_IF_ID[24:20]),
	.waddr    (inst2_MEM_WB		 ),
	.wdata    (regfile_wdata     ),
	.rdata_1  (regfile_rdata_1   ),
	.rdata_2  (regfile_rdata_2   )
);

alu_control alu_ctrl(
	.func7_5      	(inst1_ID_EX[4:3]),
	.func3          (inst1_ID_EX[2:0]),
	.alu_op         (alu_op_ID_EX    ),
	.alu_control    (alu_control       )
);

forward_unit #(
	.DATA_W(64)
) forward_unit_b(
	.writeback1_EX_MEM_output	(reg_write_EX_MEM),	
	.writeback1_MEM_WB_output	(reg_write_MEM_WB),	
	.IF_ID_rs1_output			(IF_ID_rs1),    
	.IF_ID_rs2_output			(IF_ID_rs2),
	.inst2_EX_MEM_output		(inst2_EX_MEM),   
	.inst2_MEM_WB_output		(inst2_MEM_WB),   
	.mux_bottom		(mux_control_B),
	.mux_top		(mux_control_A)
);

hazard_detection_unit hazard_detection (
	.memread_ID_EX_input	(mem_read_EX_MEM),
	.alu_op_input 			(alu_op_tomux),
	.reg_dst_input 			(reg_dst_tomux),
	.branch_input 			(branch_tomux),
	.mem_read_input 		(mem_read_tomux),	
	.mem_2_reg_input		(mem_2_reg_tomux), 	
	.mem_write_input		(mem_write_tomux), 	
	.alu_src_input 			(alu_src_tomux),
	.reg_write_input		(reg_write_tomux),	
	.jump_input 			(jump_tomux),
	.IF_ID_rs1_input		(instruction_IF_ID[19:15]),
	.IF_ID_rs2_input		(instruction_IF_ID[24:20]),
	.inst2_ID_EX_input		(inst2_ID_EX),

	.alu_op_output   		(alu_op),
	.reg_dst_output  		(reg_dst),
	.branch_output   		(branch),
	.mem_read_output 		(mem_read),
	.mem_2_reg_output		(mem_2_reg),
	.mem_write_output		(mem_write),
	.alu_src_output  		(alu_src),
	.reg_write_output		(reg_write),
	.jump_output     		(jump),
	.prevent_update_pc		(PCWrite),			// TODO: setup
	.prevent_update_reg_IF_ID	(IF_IDWrite)
);

mux_3 mux_A(
	.input_reg		(regfile_rdata_1_ID_EX),
	.input_alu		(alu_out_EX_MEM),
	.input_wb		(regfile_wdata),
	.select_fwunit	(mux_control_A),
	.mux_out		(mux_output_A)
);

mux_3 mux_B(
	.input_reg		(regfile_rdata_2_ID_EX),
	.input_alu		(alu_out_EX_MEM),
	.input_wb		(regfile_wdata),
	.select_fwunit	(mux_control_B),
	.mux_out		(mux_output_B)
);

mux_2 #(
	.DATA_W(64)
) alu_operand_mux (
	.input_a (immediate_extended_ID_EX),
	.input_b (mux_output_B      ),
	.select_a(alu_src_ID_EX     ),
	.mux_out (alu_operand_2     )
);

alu#(
	.DATA_W(64)
) alu(
	.alu_in_0 (mux_output_A		),
	.alu_in_1 (alu_operand_2   ),
	.alu_ctrl (alu_control     ),
	.alu_out  (alu_out         ),
	.zero_flag(zero_flag       ),
	.overflow (                )
);

mux_2 #(
	.DATA_W(64)
) regfile_data_mux (
	.input_a  (mem_data_MEM_WB	),
	.input_b  (alu_out_MEM_WB	),
	.select_a (mem_2_reg_MEM_WB	),
	.mux_out  (regfile_wdata 	)
);

branch_unit#(
	.DATA_W(64)
)branch_unit(
	.updated_pc         (current_pc_IF_ID       ),	// Was updated_pc (?) but is weird right? // current_pc_IF_ID
	.immediate_extended (immediate_extended ),
	.branch_pc          (branch_pc         ),		// these are both the same actually, probably just not split up as in de pipelined picture...
	.jump_pc            (jump_pc           )		// these are both the same actually, probably just not split up as in de pipelined picture...
);
endmodule