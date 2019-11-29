module stack(input clk,load_from_PC,load_from_stk1,load_from_stk2,
             input[10:0] PC_out,
             output[10:0] stack_out);

       reg[10:0] stack1,stack2;

       always@(posedge clk)
         if(load_from_PC)
           stack1<=PC_out;
         else if(load_from_stk2)
           stack1<=stack2;

       always@(posedge clk)
         if(load_from_stk1)
           stack2<=stack1;

      assign stack_out=stack1;
endmodule



