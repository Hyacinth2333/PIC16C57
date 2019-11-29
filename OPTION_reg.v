module OPTION_reg(input clk,rst_n,load_option,
                  input[7:0] ALU_out,
                  output[5:0] OPTION_out);

       reg[7:0] OPTION_reg;
       assign OPTION_out=OPTION_reg[5:0];
       always@(posedge clk)
         if(!rst_n)
           OPTION_reg[5:0]<=6'h3F;
         else if(load_option)
           OPTION_reg<=ALU_out;
endmodule

