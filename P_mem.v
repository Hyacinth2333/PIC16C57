module P_mem(input[10:0] PC_out,
             output[11:0] P_mem_out);
       reg[11:0] mem_P[2047:0];
       always@(*)
	mem_P[2047]<=12'h000;
       assign P_mem_out=mem_P[PC_out];
      
endmodule

