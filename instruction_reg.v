module instruction_reg(input clk,load_ins,sel_code,
                       input[11:0] P_mem_out,
                       output[11:0] instruction_reg_out);
       reg[11:0] instruction_reg;
       assign instruction_reg_out=instruction_reg;
       always@(posedge clk)
         if(load_ins)
           if(!sel_code)
           instruction_reg<=P_mem_out;
         else
           instruction_reg<=12'b0000_0000_0000;
endmodule

