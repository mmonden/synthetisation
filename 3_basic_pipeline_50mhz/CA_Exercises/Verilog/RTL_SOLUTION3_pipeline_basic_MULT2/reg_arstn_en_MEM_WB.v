// Configurable register for variable width with enable

module reg_arstn_en_MEM_WB #(
   parameter integer DATA_W     = 20,
   parameter integer PRESET_VAL = 0
	  )(
		input clk,        
		input arst_n,     
		input [31:0] aluout,		
		input [31:0] memreg,		
		input [4:0] inst2,		
		input en,         
		
		//	Control 
		input writeback1,	
		input writeback2,	
		
		//	Output
		output writeback1,	
		output writeback2,	
		output [31:0] aluout,		
		output [31:0] memreg,		
		output [4:0] inst2
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
			temp_writeback1 = writeback1;
			temp_writeback2 = writeback2;
			temp_inst2 = inst2;
			temp_memreg = memreg;
			temp_aluout = aluout;
		end else begin
			temp_writeback1 = r;
			temp_writeback2 = r;
			temp_inst2 = r;
			temp_memreg = r;
			temp_aluout = r;
		end
   end

	assign writeback1 = r_writeback1;
	assign writeback2 = r_writeback2;
	assign inst2 = r_inst2;
	assign memreg = r_memreg;
	assign aluout = r_aluout;
endmodule
