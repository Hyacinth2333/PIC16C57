module TRISA_reg(input clk,rst_n,load_TRISA,
                 input[7:0] ALU_out,
                 output[3:0] TRISA_out);
       reg[7:0] TRISA_reg;
       assign TRISA_out=TRISA_reg[3:0];
       always@(posedge clk)
         if(!rst_n)
           TRISA_reg<=8'hFF;
         else
           TRISA_reg<=ALU_out;
endmodule

