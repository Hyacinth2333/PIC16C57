`timescale 1ns/1ns
module PIC16C57_tb;
 reg clk,rst_n,POR,WDT_timeout,MCLR_rst;
 wire sleep,clear_WDT,clear_prescaler;
 wire[7:0] TMR0_out,PORTB_IO,PORTC_IO;
 wire[5:0] OPTION_out;
 wire[3:0] PORTA_IO;
 
 PIC16C57 M13(clk,rst_n,POR,WDT_timeout,MCLR_rst,sleep,clear_WDT,clear_prescaler,TMR0_out,OPTION_out,PORTA_IO,PORTB_IO,PORTC_IO);

initial
 begin
	clk<=0;
        rst_n=1;
        POR=0;
        WDT_timeout=0;
        MCLR_rst=0;
      #10 POR=1;
      #10 rst_n=0;
      #50 rst_n=1;
 end

always #10 clk<=~clk;

initial 
  $readmemb("D:/MODELSIMgcb/PIC16C5X/test2.dat",M13.M12.M6.mem_P);
endmodule