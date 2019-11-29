module TRIS_reg(input clk,rst_n,load,
                input[7:0] ALU_out,
                output[7:0] TRIS_out);
       reg[7:0] TRIS_reg;
       assign TRIS_out=TRIS_reg;
       always@(posedge clk)
         if(!rst_n)
           TRIS_reg<=8'hFF;
         else if(load)
           TRIS_reg<=ALU_out;
endmodule

