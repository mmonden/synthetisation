module check_equality 
(
    input wire [63:0] regfile_rdata_1,
    input wire [63:0] regfile_rdata_2,
    
    output reg eq
);
    always@(*) begin
        if(~|(regfile_rdata_1 ^ regfile_rdata_2)) begin
            eq = 1'b1;
        end else begin
            eq = 1'b0;
        end
    end
endmodule