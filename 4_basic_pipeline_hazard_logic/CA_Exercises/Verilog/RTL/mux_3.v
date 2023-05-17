module mux_3
  #(
   parameter integer DATA_W = 64
   )(
      input wire [DATA_W-1:0] input_reg,
      input wire [DATA_W-1:0] input_alu,
      input wire [DATA_W-1:0] input_wb,
      input wire [1:0]        select_fwunit,

      output reg  [DATA_W-1:0] mux_out
   );

   always@(*)begin
      if(select_fwunit == 2'b10)begin
         mux_out = input_alu;
      end else if(select_fwunit == 2'b01) begin
         mux_out = input_wb;
      end else begin
         mux_out = input_reg;
      end
   end
endmodule

