module data_path(
                  input clk,rst_n,POR,WDT_timeout,MCLR_rst,en_addr,load_C,load_Z,load_DC,write,
                  input load_PC_from_Literal,Inc_PC,load_stk1_to_PC,PCH8_mux_sel,set_TO,set_PD,load_TO,load_PD,
                  input load_from_PC,load_from_stk1,load_from_stk2,
                  input load_W,load_TRISA,load_TRISB,load_TRISC,load_OPTION,
                  input load_ins,sel_code,
                  output sleep,test,Z,
                  output[7:0] TMR0_out,
                  inout[3:0] PORTA_IO,
                  inout[7:0] PORTB_IO,PORTC_IO,
                  output[5:0] OPTION_out,
                  output[11:0] instruction_reg_out);
       wire[8:0] code;
       assign code=instruction_reg_out[8:0];
       wire[11:0] P_MEM_out;
       wire[7:0] read_out;
       wire[3:0] TRISA;
       wire[7:0] TRISB;
       wire[7:0] TRISC;
       wire status_C;
       wire[10:0] PC;
       wire[10:0] stk;
       wire[7:0] W_out;
       wire DC,C;
       wire[7:0] ALU_out;

       OPTION_reg M1(clk,rst_n,load_OPTION,ALU_out,OPTION_out);
       W_reg M2(clk,load_W,ALU_out,W_out);
       TRISA_reg M3(clk,rst_n,load_TRISA,ALU_out,TRISA);
       TRIS_reg M4(clk,rst_n,load_TRISB,ALU_out,TRISB);
       TRIS_reg M5(clk,rst_n,load_TRISC,ALU_out,TRISC);
       P_mem M6(PC,P_MEM_out);
       instruction_reg M7(clk,load_ins,sel_code,P_MEM_out,instruction_reg_out);
       stack M8(clk,load_from_PC,load_from_stk1,load_from_stk2,PC,stk);
       ALU M9(W_out,read_out,instruction_reg_out,status_C,ALU_out,Z,DC,C,test);
       data_ram M10(clk,write,rst_n,POR,MCLR_rst,WDT_timeout,Z,DC,C,load_PC_from_Literal,load_PC_from_stk1,Inc_PC,PCH8_mux_sel,load_C,load_Z,load_DC,load_TO,load_PD,set_TO,set_PD,en_addr,ALU_out,stk,code,TRISA,TRISB,TRISC,PORTA_IO,PORTB_IO,PORTC_IO,sleep,PC,read_out,TMR0_out,status_C);

endmodule


