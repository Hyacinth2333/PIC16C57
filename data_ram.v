module data_ram#(parameter data_width=8,data_depth=128)(
               input clk,write,rst_n,POR,MCLR_rst,WDT_timeout,
               input Z,DC,C,
               input load_PC_from_Literal,load_PC_from_stack1,inc_PC,PCH8_mux_sel,
               input load_C,load_Z,load_DC,load_TO,load_PD,set_TO,set_PD,
               input en_addr,
               input[7:0] data_in,
               input[10:0] stack1,
               input[8:0] code,
               input[3:0] TRISA,
               input[7:0] TRISB,TRISC,
               inout[3:0] PORTA_IO,
               inout[7:0] PORTB_IO,PORTC_IO,
               output sleep,
               output[10:0] PC_out,
               output[7:0] TMR0_out,
               output reg[7:0] read_out,
               output status_C);
      parameter INDF=7'h00;
      parameter TMR0=7'h01;
      parameter PCL=7'h02;
      parameter STATUS=7'h03;
      parameter FSR=7'h04;
      parameter PORTA=7'h05;
      parameter PORTB=7'h06;
      parameter PORTC=7'h07;
      reg[7:0] mem[127:0];
      reg[3:0] PCH;
      wire[4:0] addrl_i;
      reg[4:0] addrl_o;
      wire[6:0] addr,FSR_o;
      reg[1:0] addrh_o;

      assign FSR_o=mem[FSR][6:0];
      assign addrl_i=en_addr?code[4:0]:addrl_i;
      always@(*)
        if(addrl_i==5'b0)
          addrl_o=FSR_o[4:0];
        else
          addrl_o=addrl_i;

      always@(*)
        if(5'h00<=addrl_o&&addrl_o<=5'h0F)
          case(FSR_o[6:5])
            2'b01,2'b10,2'b11: addrh_o=2'b0;
            default:   addrh_o=FSR_o[6:5];
          endcase
        else
          addrh_o=FSR_o[6:5];

       assign addr={addrh_o,addrl_o};

       always@(*)
         if(addr==PORTA)
           read_out=PORTA_IO;
         else if(addr==PORTB)
           read_out=PORTB_IO;
         else if(addr==PORTC)
           read_out=PORTC_IO;
         else
           read_out=mem[addr];


       always@(posedge clk)
       begin
         if(!rst_n)
         begin
           PCH<=3'b111;
           mem[PCL]<=8'hFF;
           mem[FSR][7:5]<=3'b100;
           mem[STATUS][7:5]<=3'b000;
           if(POR)
             mem[STATUS][4:3]<=2'b11;
           else if(mem[STATUS][4]==1'b1&&mem[STATUS][3]==1'b0)
             begin
               if(WDT_timeout)
                 mem[STATUS][4:3]<=2'b00;
               else if(MCLR_rst)
                 mem[STATUS][4:3]<=2'b10;
             end
           else
              if(WDT_timeout)
                mem[STATUS][4:3]<=2'b01;
         end
         else
          begin 
           if(write)
             mem[addr]<=data_in;

           if(inc_PC)
             {PCH,mem[PCL]}<={PCH,mem[PCL]}+1'b1;
           else if(load_PC_from_Literal)
            begin
             mem[PCL]<=code[7:0];
             PCH[2:1]<=mem[STATUS][6:5];
             if(PCH8_mux_sel)
               PCH[0]<=code[8];
             else
               PCH[0]<=1'b0;
            end
           else if(load_PC_from_stack1)
             {PCH,mem[PCL]}<=stack1;

           if(load_C)
            mem[STATUS][0]<=C;

           if(load_Z)
            mem[STATUS][1]<=Z;
   
           if(load_DC)
            mem[STATUS][2]<=DC;
          
           if(load_PD)
             if(set_PD)
               mem[STATUS][3]<=1'b1;
             else
               mem[STATUS][3]<=1'b0;

           if(load_TO)
             if(set_TO)
               mem[STATUS][4]<=1'b1;
             else
               mem[STATUS][4]<=1'b0;
         end 
    end

    genvar i;
    generate
    for(i=0;i<=3;i=i+1)
      assign PORTA_IO[i]=(TRISA[i]==1'b0)?mem[PORTA][i]:1'bz;

    for(i=0;i<=7;i=i+1)
      assign PORTB_IO[i]=(TRISB[i]==1'b0)?mem[PORTB][i]:1'bz;

    for(i=0;i<=7;i=i+1)
      assign PORTC_IO[i]=(TRISC[i]==1'b0)?mem[PORTC][i]:1'bz;
    endgenerate

    assign status_C=mem[STATUS][0];
    assign PC_out={PCH,mem[PCL]};
    assign TMR0_out=mem[TMR0];
    assign sleep=mem[STATUS][4]&(~mem[STATUS][3]);
endmodule
