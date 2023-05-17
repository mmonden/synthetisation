// Configurable register for variable width with enable

module reg_arstn_en_ID_EX #(
   parameter integer DATA_W     = 20,
   parameter integer PRESET_VAL = 0
	  )(
		input clk,      
		input arst_n,    
		input [31:0] dreg1,     
		input [31:0] dreg2,     
		input [63:0] inst_imm,
		input [3:0] inst1,	
		input [4:0] inst2,	
		input [63:0] pc,

		//	Control
		input writeback1,
		input writeback2,
		input memwrite,
		input memread,
		input membranch,
		input alusrc,	
		input [1:0] aluop,	
		input en,

		//	Output
		output [31:0] dreg1,      
		output [31:0] dreg2,      
		output [63:0] inst_imm, 
		output [31:0] inst1, 	
		output [31:0] inst2, 	
		output [63:0] pc, 		
		output writeback1, 
		output writeback2, 
		output memwrite, 
		output memread, 
		output membranch, 
		output alusrc, 	
		output [1:0] aluop	    
   );

	reg temp_writeback1, temp_writeback2, temp_memwrite, temp_memread, temp_membranch, temp_alusrc;
	reg [1:0] temp_aluop;
	reg [DATA_W-1:0] temp_dreg1, temp_dreg2, temp_inst1, temp_inst2;
	reg [63:0] temp_pc, temp_inst_imm;

	reg r_writeback1, r_writeback2, r_memwrite, r_memread, r_membranch, r_alusrc;
	reg [1:0] r_aluop;
	reg [DATA_W-1:0] r_dreg1, r_dreg2, r_inst1, r_inst2;
	reg [63:0] r_pc, r_inst_imm;

   always@(posedge clk, negedge arst_n)begin
		if(arst_n==0)begin
			r_writeback1 <= PRESET_VAL;
			r_writeback2 <= PRESET_VAL;
			r_memwrite <= PRESET_VAL;
			r_memread <= PRESET_VAL;
			r_membranch <= PRESET_VAL;
			r_alusrc <= PRESET_VAL;
			r_aluop <= PRESET_VAL;
			r_dreg1 <= PRESET_VAL;
			r_dreg2 <= PRESET_VAL;
			r_inst1 <= PRESET_VAL;
			r_inst2 <= PRESET_VAL;
			r_pc <= PRESET_VAL;
			r_inst_imm <= PRESET_VAL;
		end else begin
			r_writeback1 <= temp_writeback1;
			r_writeback2 <= temp_writeback2;
			r_memwrite <= temp_memwrite;
			r_memread <= temp_memread;
			r_membranch <= temp_membranch;
			r_alusrc <= temp_alusrc;
			r_aluop <= temp_aluop;
			r_dreg1 <= temp_dreg1;
			r_dreg2 <= temp_dreg2;
			r_inst1 <= temp_inst1;
			r_inst2 <= temp_inst2;
			r_pc <= temp_pc;
			r_inst_imm <= temp_inst_imm;
		end
   end

   always@(*) begin
		if(en == 1'b1)begin
			temp_writeback1 = writeback1;
			temp_writeback2 = writeback2;
			temp_memwrite = memwritem;
			temp_memread = memread;
			temp_membranch = membranch;
			temp_alusrc = alusrc;
			temp_aluop = aluop;
			temp_dreg1 = dreg1;
			temp_dreg2 = dreg2;
			temp_inst1 = inst1;
			temp_inst2 = inst2;
			temp_pc = pc;
			temp_inst_imm = inst_imm;
		end else begin
			temp_writeback1 = r;
			temp_writeback2 = r;
			temp_memwrite = r;
			temp_memread = r;
			temp_membranch = r;
			temp_alusrc = r;
			temp_aluop = r;
			temp_dreg1 = r;
			temp_dreg2 = r;
			temp_inst1 = r;
			temp_inst2 = r;
			temp_pc = r;
			temp_inst_imm = r;
		end
   end

	assign writeback1 = r_writeback1;
	assign writeback2 = r_writeback2;
	assign memwrite = r_memwrite;
	assign memread = r_memread;
	assign membranch = r_membranch;
	assign alusrc = r_alusrc;
	assign aluop = r_aluop;
	assign dreg1 = r_dreg1;
	assign dreg2 = r_dreg2;
	assign inst1 = r_inst1;
	assign inst2 = r_inst2;
	assign pc = r_pc;
	assign inst_imm = r_inst_imm;
endmodule
