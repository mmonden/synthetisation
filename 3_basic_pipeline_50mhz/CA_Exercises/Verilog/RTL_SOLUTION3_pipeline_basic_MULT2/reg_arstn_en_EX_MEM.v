// Configurable register for variable width with enable

module reg_arstn_en_EX_MEM#(
   parameter integer DATA_W     = 20,
   parameter integer PRESET_VAL = 0
	  )(
		input clk,        
		input arst_n,     
		input [63:0] branchpc,	
		input zero,		
		input [31:0] aluout,		
		input [31:0] dreg2,		
		input [4:0] inst2,	

		//	Control 
		input writeback1,	
		input writeback2,	
		input memwrite,	
		input memread,	
		input membranch,	
		input en,

		//	Output
		output [31:0] dreg2,      
		output [63:0] branchpc,	
		output [31:0] aluout,		
		output zero,				
		output writeback1,	
		output writeback2,	
		output memwrite,	
		output memread,	
		output membranch,	
		output [4:0] inst2
   );

	reg temp_writeback1, temp_writeback2, temp_memwrite, temp_memread, temp_membranch, temp_zero;
	reg [DATA_W-1:0] temp_dreg2, temp_inst2;
	reg [63:0] temp_branchpc, temp_aluout;

	reg r_writeback1, r_writeback2, r_memwrite, r_memread, r_membranch, r_zero;
	reg [DATA_W-1:0] r_dreg2, r_inst2;
	reg [63:0] r_branchpc, r_aluout;

   always@(posedge clk, negedge arst_n)begin
		if(arst_n==0)begin
			r_writeback1 <= PRESET_VAL;
			r_writeback2 <= PRESET_VAL;
			r_memwrite <= PRESET_VAL;
			r_memread <= PRESET_VAL;
			r_membranch <= PRESET_VAL;
			r_zero <= PRESET_VAL;
			r_dreg2 <= PRESET_VAL;
			r_inst2 <= PRESET_VAL;
			r_branchpc <= PRESET_VAL;
			r_aluout <= PRESET_VAL;
		end else begin
			r_writeback1 <= temp_writeback1;
			r_writeback2 <= temp_writeback2;
			r_memwrite <= temp_memwrite;
			r_memread <= temp_memread;
			r_membranch <= temp_membranch;
			r_zero <= temp_zero;
			r_dreg2 <= temp_dreg2;
			r_inst2 <= temp_inst2;
			r_branchpc <= temp_branchpc;
			r_aluout <= temp_aluout;
		end
   end

   always@(*) begin
		if(en == 1'b1)begin
			temp_writeback1 = writeback1;
			temp_writeback2 = writeback2;
			temp_memwrite = memwrite;
			temp_memread = memread;
			temp_membranch = membranch;
			temp_zero = zero;
			temp_dreg2 = dreg2;
			temp_inst2 = inst2;
			temp_branchpc = branchpc;
			temp_aluout = aluout;
		end else begin
			temp_writeback1 = r;
			temp_writeback2 = r;
			temp_memwrite = r;
			temp_memread = r;
			temp_membranch = r;
			temp_zero = r;
			temp_dreg2 = r;
			temp_inst2 = r;
			temp_branchpc = r;
			temp_aluout = r;
		end
   end

	assign writeback1 = r_writeback1;
	assign writeback2 = r_writeback2;
	assign memwrite = r_memwrite;
	assign memread = r_memread;
	assign membranch = r_membranch;
	assign zero = r_zero;
	assign dreg2 = r_dreg2;
	assign inst2 = r_inst2;
	assign branchpc = r_branchpc;
	assign aluout = r_aluout;
endmodule
