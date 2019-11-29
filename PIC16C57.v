module PIC16C57(
                input clk,rst_n,POR,WDT_timeout,MCLR_rst,
                output sleep,clear_WDT,clear_prescaler,
                output[7:0] TMR0_out,
                output[5:0] OPTION_out,
                inout[3:0] PORTA_IO,
                inout[7:0] PORTB_IO,PORTC_IO);

       wire en_addr,load_C,load_Z,load_DC,write,load_PC_from_Literal,Inc_PC,load_stk1_to_PC,PCH8_mux_sel,set_TO,set_PD,load_TO,load_PD,load_from_PC,load_from_stk1,load_from_stk2,load_W,load_TRISA,load_TRISB,load_TRISC,load_OPTION;
       wire load_ins,sel_code,test,Z;
       wire[11:0] instruction_reg_out;
       wire link;
       assign link=OPTION_out[3];

       control_unit M11(clk,rst_n,instruction_reg_out,test,Z,link,load_W,load_TRISA,load_TRISB,load_TRISC,load_OPTION,write,load_ins,sel_code,load_from_PC,load_from_stk1,load_from_stk2,en_addr,load_PC_from_Literal,Inc_PC,
                        load_stk1_to_PC,PCH8_mux_sel,load_C,load_Z,load_DC,set_TO,set_PD,load_TO,load_PD,clear_WDT,clear_prescaler);

       data_path M12(clk,rst_n,POR,WDT_timeout,MCLR_rst,en_addr,load_C,load_Z,load_DC,write,load_PC_from_Literal,Inc_PC,load_stk1_to_PC,PCH8_mux_sel,set_TO,set_PD,load_TO,load_PD,load_from_PC,load_from_stk1,load_from_stk2,
                     load_W,load_TRISA,load_TRISB,load_TRISC,load_OPTION,load_ins,sel_code,sleep,test,Z,TMR0_out,PORTA_IO,PORTB_IO,PORTC_IO,OPTION_out,instruction_reg_out);

endmodule