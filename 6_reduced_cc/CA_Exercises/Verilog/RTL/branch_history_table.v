// Take size = 32 --> ideal for amount of instructions + is factor of 2
// This means we need 2^n = 32 or n = 5 bits of the lower part of the PC
// Each memory cell has 2 bits

//  The non ext will correspond to always read
//  The ext signal will correspond to write
//  There will be only one memory module: mem_sel=0 and N_MEMS=1
module branch_history_table(
		input wire			       clk,
		input wire	      [4:0] read_addr,
		input wire	      [4:0] write_addr,	// the prev pc
		input wire 	      was_taken,
		output reg	      prediction
	);
	parameter integer SEL_W       = 0;
	parameter integer N_MEMS      = 1;

	wire[1:0] new_pred;
	wire wen, wen_ext, ren, ren_ext;

	reg  [      4:0] addr_i, addr_ext_i;
	reg  mem_sel;
	reg  mem_sel_ext;
	wire [     1:0] data_i;
	wire [     1:0] data_ext_i;
	reg              cs_i;
	reg              cs_ext_i;

	reg web0, web1, csb0, csb1;

	always@(*) begin
		case(data_i)
			2'b00:	prediction <= 1'b0;
			2'b01:	prediction <= 1'b0;
			2'b10:	prediction <= 1'b1;
			2'b11:	prediction <= 1'b1;
			default:	prediction <= 1'b0;
		endcase
	end

	always@(*) begin
		case(data_i)
			2'b00:
				if(was_taken)
					new_pred = 2'b01;
				else
					new_pred = 2'b00;
			2'b01:
				if(was_taken)
					new_pred = 2'b11;
				else
					new_pred = 2'b00;
			2'b10:
				if(was_taken)
					new_pred = 2'b11;
				else
					new_pred = 2'b00;
			2'b11:
				if(!was_taken)
					new_pred = 2'b10;
				else
					new_pred = 2'b11;
			default:
				new_pred = 2'b00;
		endcase
	end

	always@(*) begin
		addr_i      = read_addr;
		addr_ext_i  = write_addr;
		web0        = 1'b0;
		csb0        = 1'b1;
		web1        = 1'b1; 
		csb1        = 1'b0;
		mem_sel     = 1'b0;
		mem_sel_ext = 1'b0;
	end

//    genvar index_depth;
   generate
	//   for (index_depth = 0; index_depth < N_MEMS; index_depth = index_depth+1) begin: process_for_mem
			always@(*) begin
			   cs_i[0] = (mem_sel == 0) ? 1'b0 : 1'b1;
			   cs_ext_i[0] = (mem_sel == 0) ? 1'b0 : 1'b1;
			end

			sky130_sram_2rw_2x32_2 dram_inst(
			   .clk0         ( ~clk                         ),
			   .csb0         ( csb0 | cs_i[0]     ),
			   .web0         ( web0                         ),
			   .addr0        ( addr_i                       ),
			   .din0         (                              ),
			   .dout0        ( data_i[0]          ),
			   .clk1         ( ~clk                         ),
			   .csb1         ( csb1 | cs_ext_i[0] ),
			   .web1         ( web1                         ),
			   .addr1        ( addr_ext_i                   ),
			   .din1         ( new_pred                    	),
			   .dout1        ( data_ext_i[0]      )
			);
	//   end
   endgenerate
endmodule