// Take size = 32 --> ideal for amount of instructions + is factor of 2
// This means we need 2^n = 32 or n = 5 bits of the lower part of the PC
// Each memory cell has 2 bits

module branch_target_buffer(
		input wire			       clk,
		input wire	      [4:0] addr,
		input wire	      [4:0] addr_ext,
        input wire               wen,
        input wire               wen_ext,
        input wire               ren,
        input wire               ren_ext,
		input wire 	      [1:0] wdata,
		input wire 	      [1:0] wdata_ext,
		output reg	      [1:0] rdata,
		output reg	      [1:0] rdata_ext
   );
   parameter integer SEL_W       = 0;
   parameter integer N_MEMS      = 1;

   reg  [      4:0] addr_i, addr_ext_i;
   reg  mem_sel;
   reg  mem_sel_ext;
   wire [     1:0] data_i;
   wire [     1:0] data_ext_i;
   reg              cs_i;
   reg              cs_ext_i;
   
   reg web0, web1, csb0, csb1;

   always@(*)begin
      rdata     = data_i    [mem_sel][1:0];
      rdata_ext = data_ext_i[mem_sel_ext][1:0]; 
   end 

   always@(*)begin
      addr_i      = addr;
      addr_ext_i  = addr_ext;
      web0        = (~wen) | ren ;
      csb0        = wen ~^ ren;
      web1        = (~wen_ext) | ren_ext; 
      csb1        = wen_ext ~^ ren_ext;
      mem_sel     = 1'b0;
      mem_sel_ext = 1'b0;
   end

//    genvar index_depth;
   generate
    //   for (index_depth = 0; index_depth < N_MEMS; index_depth = index_depth+1) begin: process_for_mem
            always@(*)begin
               cs_i[index_depth] = (mem_sel == index_depth) ? 1'b0 : 1'b1;
               cs_ext_i[index_depth] = (mem_sel == index_depth) ? 1'b0 : 1'b1;
            end
            sky130_sram_2rw_2x32_2  dram_inst(
               .clk0         ( ~clk                         ),
               .csb0         ( csb0 | cs_i[index_depth]     ),
               .web0         ( web0                         ),
               .addr0        ( addr_i                       ),
               .din0         ( wdata                        ),
               .dout0        ( data_i[index_depth]          ),
               .clk1         ( ~clk                         ),
               .csb1         ( csb1 | cs_ext_i[index_depth] ),
               .web1         ( web1                         ),
               .addr1        ( addr_ext_i                   ),
               .din1         ( wdata_ext                    ),
               .dout1        ( data_ext_i[index_depth]      )
            );
    //   end
   endgenerate
endmodule