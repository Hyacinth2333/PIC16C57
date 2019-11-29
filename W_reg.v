module W_reg(input clk,load_W,
             input[7:0] ALU_out,
             output[7:0] W_out);
        reg[7:0] W_reg;
        assign W_out=W_reg;
        always@(posedge clk)
          if(load_W)
            W_reg<=ALU_out;
endmodule
