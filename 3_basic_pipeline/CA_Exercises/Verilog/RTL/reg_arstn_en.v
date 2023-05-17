module reg_arstn_en_IF_ID #(
   parameter integer DATA_W     = 20,
   parameter integer PRESET_VAL = 0
	  )(
		input clk,
		input arst_n,
		input [31:0] din,
		input [63:0] pc,
		input en,
		
		output [DATA_W-1:0] dout,
		output [63:0]		pcout
   );

   reg [DATA_W-1:0] r_inst, inst;
   reg [63:0] r_pc, currpc;

   always@(posedge clk, negedge arst_n)begin
		if(arst_n==0)begin
			r_inst <= PRESET_VAL;
			r_pc <= PRESET_VAL;
		end else begin
			r_inst <= inst;
			r_pc <= currpc;
		end
   end

   always@(*) begin
	  if(en == 1'b1)begin
		 inst = din;
		 currpc = pc;
	  end else begin
		 inst = r_inst;
		 currpc = r_pc;
	  end
   end

   assign dout = r_inst;
   assign pcout = r_pc;
endmodule

module reg_arstn_en_ID_EX #(
   parameter integer DATA_W     = 20,
   parameter integer PRESET_VAL = 0
	  )(
		input clk,      
		input arst_n,    
		input [63:0] dreg1_ID_EX_input,     
		input [63:0] dreg2_ID_EX_input,     
		input [63:0] inst_imm_ID_EX_input,
		input [4:0] inst1_ID_EX_input,	
		input [4:0] inst2_ID_EX_input,	
		input [63:0] pc_ID_EX_input,

		//	Control
		input writeback1_ID_EX_input,
		input writeback2_ID_EX_input,
		input memwrite_ID_EX_input,
		input memread_ID_EX_input,
		input membranch_ID_EX_input,
		input memjump_ID_EX_input,
		input alusrc_ID_EX_input,	
		input [1:0] aluop_ID_EX_input,	
		input en,

		//	Output
		output [63:0] dreg1_ID_EX_output,      
		output [63:0] dreg2_ID_EX_output,      
		output [63:0] inst_imm_ID_EX_output, 
		output [4:0] inst1_ID_EX_output, 	
		output [4:0] inst2_ID_EX_output, 	
		output [63:0] pc_ID_EX_output, 		
		output writeback1_ID_EX_output, 
		output writeback2_ID_EX_output, 
		output memwrite_ID_EX_output, 
		output memread_ID_EX_output, 
		output membranch_ID_EX_output,
		output memjump_ID_EX_output, 
		output alusrc_ID_EX_output, 	
		output [1:0] aluop_ID_EX_output	    
   );

	reg temp_writeback1, temp_writeback2, temp_memwrite, temp_memread, temp_membranch, temp_memjump, temp_alusrc;
	reg [1:0] temp_aluop;
	reg [4:0] temp_dreg1, temp_dreg2, temp_inst1, temp_inst2;
	reg [63:0] temp_pc, temp_inst_imm;

	reg r_writeback1, r_writeback2, r_memwrite, r_memread, r_membranch, r_memjump, r_alusrc;
	reg [1:0] r_aluop;
	reg [4:0] r_dreg1, r_dreg2, r_inst1, r_inst2;
	reg [63:0] r_pc, r_inst_imm;

	always@(posedge clk, negedge arst_n) begin
		if(arst_n==0)begin
			r_writeback1 <= PRESET_VAL;
			r_writeback2 <= PRESET_VAL;
			r_memwrite <= PRESET_VAL;
			r_memread <= PRESET_VAL;
			r_membranch <= PRESET_VAL;
			r_memjump <= PRESET_VAL;
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
			r_memjump <= temp_memjump;
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
			temp_writeback1 = writeback1_ID_EX_input;
			temp_writeback2 = writeback2_ID_EX_input;
			temp_memwrite = memwrite_ID_EX_input;
			temp_memread = memread_ID_EX_input;
			temp_membranch = membranch_ID_EX_input;
			temp_memjump = memjump_ID_EX_input;
			temp_alusrc = alusrc_ID_EX_input;
			temp_aluop = aluop_ID_EX_input;
			temp_dreg1 = dreg1_ID_EX_input;
			temp_dreg2 = dreg2_ID_EX_input;
			temp_inst1 = inst1_ID_EX_input;
			temp_inst2 = inst2_ID_EX_input;
			temp_pc = pc_ID_EX_input;
			temp_inst_imm = inst_imm_ID_EX_input;
		end else begin
			temp_writeback1 = r_writeback1;
			temp_writeback2 = r_writeback2;
			temp_memwrite = r_memwrite;
			temp_memread = r_memread;
			temp_membranch = r_membranch;
			temp_memjump = r_memjump;
			temp_alusrc = r_alusrc;
			temp_aluop = r_aluop;
			temp_dreg1 = r_dreg1;
			temp_dreg2 = r_dreg2;
			temp_inst1 = r_inst1;
			temp_inst2 = r_inst2;
			temp_pc = r_pc;
			temp_inst_imm = r_inst_imm;
		end
   end

	assign writeback1_ID_EX_output = r_writeback1;
	assign writeback2_ID_EX_output = r_writeback2;
	assign memwrite_ID_EX_output = r_memwrite;
	assign memread_ID_EX_output = r_memread;
	assign membranch_ID_EX_output = r_membranch;
	assign memjump_ID_EX_output = r_memjump;
	assign alusrc_ID_EX_output = r_alusrc;
	assign aluop_ID_EX_output = r_aluop;
	assign dreg1_ID_EX_output = r_dreg1;
	assign dreg2_ID_EX_output = r_dreg2;
	assign inst1_ID_EX_output = r_inst1;
	assign inst2_ID_EX_output = r_inst2;
	assign pc_ID_EX_output = r_pc;
	assign inst_imm_ID_EX_output = r_inst_imm;
endmodule

module reg_arstn_en_EX_MEM#(
   parameter integer DATA_W     = 20,
   parameter integer PRESET_VAL = 0
	  )(
		input clk,        
		input arst_n,     
		input [63:0] branchpc_EX_MEM_input,
		input [63:0] jumppc_EX_MEM_input,
		input zero_EX_MEM_input,		
		input [63:0] aluout_EX_MEM_input,		
		input [63:0] dreg2_EX_MEM_input,		
		input [4:0] inst2_EX_MEM_input,	

		//	Control 
		input writeback1_EX_MEM_input,	
		input writeback2_EX_MEM_input,	
		input memwrite_EX_MEM_input,	
		input memread_EX_MEM_input,	
		input membranch_EX_MEM_input,
		input memjump_EX_MEM_input,	
		input en,

		//	Output
		output [63:0] dreg2_EX_MEM_output,      
		output [63:0] branchpc_EX_MEM_output,
		output [63:0] jumppc_EX_MEM_output,	
		output [63:0] aluout_EX_MEM_output,		
		output zero_EX_MEM_output,				
		output writeback1_EX_MEM_output,	
		output writeback2_EX_MEM_output,	
		output memwrite_EX_MEM_output,	
		output memread_EX_MEM_output,	
		output membranch_EX_MEM_output,
		output memjump_EX_MEM_output,	
		output [4:0] inst2_EX_MEM_output
   );

	reg temp_writeback1, temp_writeback2, temp_memwrite, temp_memread, temp_membranch, temp_memjump, temp_zero;
	reg [63:0] temp_dreg2, temp_inst2, temp_branchpc, temp_jumppc, temp_aluout;

	reg r_writeback1, r_writeback2, r_memwrite, r_memread, r_membranch, r_memjump, r_zero;
	reg [63:0] r_dreg2, r_inst2, r_branchpc, r_jumppc, r_aluout;

   always@(posedge clk, negedge arst_n)begin
		if(arst_n==0)begin
			r_writeback1 <= PRESET_VAL;
			r_writeback2 <= PRESET_VAL;
			r_memwrite <= PRESET_VAL;
			r_memread <= PRESET_VAL;
			r_membranch <= PRESET_VAL;
			r_memjump <= PRESET_VAL;
			r_zero <= PRESET_VAL;
			r_dreg2 <= PRESET_VAL;
			r_inst2 <= PRESET_VAL;
			r_branchpc <= PRESET_VAL;
			r_jumppc <= PRESET_VAL;
			r_aluout <= PRESET_VAL;
		end else begin
			r_writeback1 <= temp_writeback1;
			r_writeback2 <= temp_writeback2;
			r_memwrite <= temp_memwrite;
			r_memread <= temp_memread;
			r_membranch <= temp_membranch;
			r_memjump <= temp_memjump;
			r_zero <= temp_zero;
			r_dreg2 <= temp_dreg2;
			r_inst2 <= temp_inst2;
			r_branchpc <= temp_branchpc;
			r_jumppc <= temp_jumppc;
			r_aluout <= temp_aluout;
		end
   end

   always@(*) begin
		if(en == 1'b1)begin
			temp_writeback1 = writeback1_EX_MEM_input;
			temp_writeback2 = writeback2_EX_MEM_input;
			temp_memwrite = memwrite_EX_MEM_input;
			temp_memread = memread_EX_MEM_input;
			temp_membranch = membranch_EX_MEM_input;
			temp_memjump = memjump_EX_MEM_input;
			temp_zero = zero_EX_MEM_input;
			temp_dreg2 = dreg2_EX_MEM_input;
			temp_inst2 = inst2_EX_MEM_input;
			temp_branchpc = branchpc_EX_MEM_input;
			temp_jumppc = jumppc_EX_MEM_input;
			temp_aluout = aluout_EX_MEM_input;
		end else begin
			temp_writeback1 = r_writeback1;
			temp_writeback2 = r_writeback2;
			temp_memwrite = r_memwrite;
			temp_memread = r_memread;
			temp_membranch = r_membranch;
			temp_memjump = r_memjump;
			temp_zero = r_zero;
			temp_dreg2 = r_dreg2;
			temp_inst2 = r_inst2;
			temp_branchpc = r_branchpc;
			temp_jumppc = r_jumppc;
			temp_aluout = r_aluout;
		end
   end

	assign writeback1_EX_MEM_output = r_writeback1;
	assign writeback2_EX_MEM_output = r_writeback2;
	assign memwrite_EX_MEM_output = r_memwrite;
	assign memread_EX_MEM_output = r_memread;
	assign membranch_EX_MEM_output = r_membranch;
	assign memjump_EX_MEM_output = r_memjump;
	assign zero_EX_MEM_output = r_zero;
	assign dreg2_EX_MEM_output = r_dreg2;
	assign inst2_EX_MEM_output = r_inst2;
	assign branchpc_EX_MEM_output = r_branchpc;
	assign jumppc_EX_MEM_output = r_jumppc;
	assign aluout_EX_MEM_output = r_aluout;
endmodule

module reg_arstn_en_MEM_WB #(
   parameter integer DATA_W     = 20,
   parameter integer PRESET_VAL = 0
	  )(
		input clk,        
		input arst_n,     
		input [63:0] aluout_MEM_WB_input,		
		input [63:0] memreg_MEM_WB_input,		
		input [4:0] inst2_MEM_WB_input,		
		input en,         
		
		//	Control 
		input writeback1_MEM_WB_input,	
		input writeback2_MEM_WB_input,	
		
		//	Output
		output writeback1_MEM_WB_output,	
		output writeback2_MEM_WB_output,	
		output [63:0] aluout_MEM_WB_output,		
		output [63:0] memreg_MEM_WB_output,		
		output [4:0] inst2_MEM_WB_output
   );

	reg temp_writeback1, temp_writeback2;
	reg [4:0] temp_inst2;
	reg [DATA_W-1:0] temp_memreg;
	reg [63:0] temp_aluout;

	reg r_writeback1, r_writeback2;
	reg [4:0] r_inst2;
	reg [DATA_W-1:0] r_memreg;
	reg [63:0] r_aluout;

   always@(posedge clk, negedge arst_n)begin
		if(arst_n==0)begin
			r_writeback1 <= PRESET_VAL;
			r_writeback2 <= PRESET_VAL;
			r_inst2 <= PRESET_VAL;
			r_memreg <= PRESET_VAL;
			r_aluout <= PRESET_VAL;
		end else begin
			r_writeback1 <= temp_writeback1;
			r_writeback2 <= temp_writeback2;
			r_inst2 <= temp_inst2;
			r_memreg <= temp_memreg;
			r_aluout <= temp_aluout;
	  	end
   end

   always@(*) begin
		if(en == 1'b1)begin
			temp_writeback1 = writeback1_MEM_WB_input;
			temp_writeback2 = writeback2_MEM_WB_input;
			temp_inst2 = inst2_MEM_WB_input;
			temp_memreg = memreg_MEM_WB_input;
			temp_aluout = aluout_MEM_WB_input;
		end else begin
			temp_writeback1 = r_writeback1;
			temp_writeback2 = r_writeback2;
			temp_inst2 = r_inst2;
			temp_memreg = r_memreg;
			temp_aluout = r_aluout;
		end
   end

	assign writeback1_MEM_WB_output = r_writeback1;
	assign writeback2_MEM_WB_output = r_writeback2;
	assign inst2_MEM_WB_output = r_inst2;
	assign memreg_MEM_WB_output = r_memreg;
	assign aluout_MEM_WB_output = r_aluout;
endmodule

// Configurable register for variable width with enable

module reg_arstn_en#(
parameter integer DATA_W     = 20,
parameter integer PRESET_VAL = 0
   )(
      input                  clk,
      input                  arst_n,
      input                  en,
      input  [ DATA_W-1:0]   din,
      output [ DATA_W-1:0]   dout
);

reg [DATA_W-1:0] r,nxt;

always@(posedge clk, negedge arst_n)begin
   if(arst_n==0)begin
      r <= PRESET_VAL;
   end else begin
      r <= nxt;
   end
end

always@(*) begin
   if(en == 1'b1)begin
      nxt = din;
   end else begin
      nxt = r;
   end
end

assign dout = r;

endmodule
