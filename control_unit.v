module control_unit(input clk,rst_n,
                    input[11:0] instruction_reg_out,
                    input test,Z,link,
                    output reg load_W,load_TRISA,load_TRISB,load_TRISC,load_OPTION,write,
                    output reg load_ins,sel_code,
                    output reg load_from_PC,load_from_stk1,load_from_stk2,
                    output reg en_addr,load_PC_from_Literal,Inc_PC,load_stk1_to_PC,PCH8_mux_sel,
                    output reg load_C,load_Z,load_DC,set_TO,set_PD,load_TO,load_PD,
                    output reg clear_WDT,clear_prescaler);
       reg[3:0] state,next_state;
       parameter S_idle=4'b0000,S_PC=4'b0001,S_Nopt1=4'b0010,S_Nopt2=4'b0011,S_get_ins=4'b0100,S_PC_decode=4'b0101,S_perf=4'b0110,S_wait=4'b0111,S_get_ins1=4'b1000;


       always@(posedge clk)
         if(!rst_n)
           state<=S_idle;
         else
           state<=next_state;

       always@(*)
        begin
          load_W=0;load_TRISA=0;load_TRISB=0;load_TRISC=0;load_OPTION=0;write=0;
          load_ins=0;sel_code=0;
          load_from_PC=0;load_from_stk1=0;load_from_stk2=0;
          en_addr=0;load_PC_from_Literal=0;Inc_PC=0;load_stk1_to_PC=0;PCH8_mux_sel=0;
          load_C=0;load_Z=0;load_DC=0;set_TO=0;set_PD=0;load_TO=0;load_PD=0;
          clear_WDT=0;clear_prescaler=0;
          next_state=S_idle;
          case(state)
            S_idle: next_state=S_PC;

            S_PC:   begin
                      next_state=S_Nopt1;
                      Inc_PC=1;
                    end

            S_Nopt1: begin
                        next_state=S_Nopt2;
                     end

            S_Nopt2:  next_state=S_get_ins;

            S_get_ins: begin
                         load_ins=1;
                         next_state=S_PC_decode;
                       end

            S_PC_decode: begin
                            Inc_PC=1;
                            casex(instruction_reg_out)
                              //ADDWF
                              12'b0001_11xx_xxxx: begin
                                                en_addr=1;
                                                next_state=S_perf;
                                              end
                              //ANDWF
                              12'b0001_01xx_xxxx: begin
                                                en_addr=1;
                                                next_state=S_perf;
                                              end
                              //CLRF
                              12'b0000_011X_xxxx: begin
                                                en_addr=1;
                                                next_state=S_perf;
                                              end
                              //CLRW
                              12'b0000_0100_0000: next_state=S_perf;
                              
                              //COMF
                              12'b0010_01xx_xxxx: begin
                                                en_addr=1;
                                                next_state=S_perf;
                                              end

                             //DECF
                             12'b0000_11xx_xxxx: begin
                                                en_addr=1;
                                                next_state=S_perf;
                                              end

                             //DECFSZ
                             12'b0010_11xx_xxxx: begin
                                                en_addr=1;
                                                next_state=S_perf;
                                              end

                             //INCF
                             12'b0010_10xx_xxxx: begin
                                                en_addr=1;
                                                next_state=S_perf;
                                              end

                             //INCFSZ
                             12'b0011_11xx_xxxx: begin
                                                en_addr=1;
                                                next_state=S_perf;
                                              end

                             //IORWF
                             12'b0001_00xx_xxxx: begin
                                                en_addr=1;
                                                next_state=S_perf;
                                              end

                             //MOVF
                             12'b0010_00xx_xxxx: begin
                                                en_addr=1;
                                                next_state=S_perf;
                                              end

                             //MOVWF
                             12'b0000_001x_xxxx: begin
                                                en_addr=1;
                                                next_state=S_perf;
                                              end

                             //NOP 
                             12'b0000_0000_0000: next_state=S_perf;

                             //RLF
                             12'b0011_01xx_xxxx: begin
                                                en_addr=1;
                                                next_state=S_perf;
                                              end
                             
                             //RRF
                             12'b0011_00xx_xxxx: begin
                                                en_addr=1;
                                                next_state=S_perf;
                                              end

                             //SUBWF
                             12'b0000_10xx_xxxx: begin
                                                en_addr=1;
                                                next_state=S_perf;
                                              end

                             //SWAPF
                             12'b0011_10xx_xxxx: begin
                                                en_addr=1;
                                                next_state=S_perf;
                                              end

                             //XORWF
                             12'b0001_10xx_xxxx: begin
                                                en_addr=1;
                                                next_state=S_perf;
                                             end

                             //BCF
                             12'b0100_xxxx_xxxx: begin
                                                en_addr=1;
                                                next_state=S_perf;
                                              end

                             //BSF
                             12'b0101_xxxx_xxxx: begin
                                                en_addr=1;
                                                next_state=S_perf;
                                              end

                             //BTFSC
                             12'b0110_xxxx_xxxx: begin
                                               en_addr=1;
                                               next_state=S_perf;
                                             end

                             //BTFSS
                             12'b0111_xxxx_xxxx: begin
                                                en_addr=1;
                                                next_state=S_perf;
                                              end

                             //ANDLW 
                             12'b1110_xxxx_xxxx: next_state=S_perf;

                             //IORLW
                             12'b1101_xxxx_xxxx: next_state=S_perf;

                             //MOVLW
                             12'b1100_xxxx_xxxx: next_state=S_perf;

                             //OPTION
                             12'b0000_0000_0010: next_state=S_perf;

                             //RETLW
                             12'b1000_xxxx_xxxx: next_state=S_perf;

                             //TRIS
                             12'b0000_0000_0xxx: next_state=S_perf;

                             //XORLW
                             12'b1111_xxxx_xxxx: next_state=S_perf;
                             
                             default: next_state=S_perf;
                       endcase
                     end
      
        S_perf:   begin
                    casex(instruction_reg_out)   
                    //ADDWF
                    12'b0001_11xx_xxxx: begin
                                      if(instruction_reg_out[5])
                                        write=1;
                                      else
                                        load_W=1;
                                      load_C=1;
                                      load_Z=1;
                                      load_DC=1;
                                      next_state=S_wait;
                                    end

                    //ANDWF
                    12'b0001_01xx_xxxx: begin
                                      if(instruction_reg_out[5])
                                        write=1;
                                      else
                                        load_W=1;
                                      load_Z=1;
                                      next_state=S_wait;
                                    end

                   //CLRF
                   12'b0000_011x_xxxx: begin
                                      write=1;
                                      load_Z=1;
                                   end 

                   //CLRW
                   12'b0000_0100_0000: begin
                                      load_W=1;
                                      next_state=S_wait;
                                    end

                   //COMF
                   12'b0010_01xx_xxxx: begin
                                      if(instruction_reg_out[5])
                                          write=1;
                                      else
                                          load_W=1;
                                     load_Z=1;
                                     next_state=S_wait;
                                   end

                   //DECF
                   12'b0000_11xx_xxxx:  begin
                                      if(instruction_reg_out[5])
                                          write=1;
                                      else
                                          load_W=1;
                                     load_Z=1;
                                     next_state=S_wait;
                                   end

                  //DECFSZ
                  12'b0010_11xx_xxxx: begin
                                     if(instruction_reg_out[5])
                                       write=1;
                                     else
                                       load_W=1;

                                     next_state=S_wait;
                                   end

                  //INCF
                  12'b0010_10xx_xxxx: begin
                                    if(instruction_reg_out[5])
                                      write=1;
                                    else
                                       load_W=1;
                                     load_Z=1;
                                     next_state=S_wait;
                                   end

                  //INCFSZ
                  12'b0011_11xx_xxxx: begin
                                    if(instruction_reg_out[5])
                                      write=1;
                                    else
                                      load_W=1;
                              
                                    next_state=S_wait;
                                  end

                   //IORWF
                   12'b0001_00xx_xxxx:  begin
                                      if(instruction_reg_out[5])
                                          write=1;
                                      else
                                          load_W=1;
                                     load_Z=1;
                                     next_state=S_wait;
                                   end
                   
                  //MOVF
                  12'b0010_00xx_xxxx:  begin
                                      if(instruction_reg_out[5])
                                          write=1;
                                      else
                                          load_W=1;
                                     load_Z=1;
                                     next_state=S_wait;
                                   end

                  //MOVWF
                  12'b0000_001x_xxxx: begin
                                     write=1;
                                     next_state=S_wait;
                                   end

                  //NOP  
                  12'b0000_0000_0000: next_state=S_wait;

                  //RLF
                  12'b0011_01xx_xxxx:  begin
                                      if(instruction_reg_out[5])
                                          write=1;
                                      else
                                          load_W=1;
                                     load_C=1;
                                     next_state=S_wait;
                                   end

                  //RRF
                  12'b0011_00xx_xxxx:   begin
                                      if(instruction_reg_out[5])
                                          write=1;
                                      else
                                          load_W=1;
                                     load_C=1;
                                     next_state=S_wait;
                                   end

                  //SUBWF
                  12'b0000_10xx_xxxx:  begin
                                      if(instruction_reg_out[5])
                                        write=1;
                                      else
                                        load_W=1;
                                      load_Z=1;
                                      load_DC=1;
                                      load_C=1;
                                      next_state=S_wait;
                                    end

                  //SWAPF
                  12'b0011_10xx_xxxx:  begin
                                      if(instruction_reg_out[5])
                                          write=1;
                                      else
                                          load_W=1;
                                     next_state=S_wait;
                                   end

                  //XORWF
                  12'b0001_10xx_xxxx:   begin
                                      if(instruction_reg_out[5])
                                          write=1;
                                      else
                                          load_W=1;
                                     load_Z=1;
                                     next_state=S_wait;
                                   end
            
                  //BCF
                  12'b0100_xxxx_xxxx:  begin
                                      if(instruction_reg_out[5])
                                          write=1;
                                      else
                                          load_W=1;
                                     next_state=S_wait;
                                   end

                  //BSF
                  12'b0101_xxxx_xxxx:   begin
                                      if(instruction_reg_out[5])
                                          write=1;
                                      else
                                          load_W=1;
                                     next_state=S_wait;
                                   end

                  //BTFSC
                  12'b0110_xxxx_xxxx:  begin
                                      if(instruction_reg_out[5])
                                        write=1;
                                      else
                                        load_W=1;
                                      
                                      next_state=S_wait;
                                    end

                  //BTFSS
                  12'b0111_xxxx_xxxx: begin
                                     if(instruction_reg_out[5])
                                       write=1;
                                     else
                                       load_W=1;

                                     next_state=S_wait;
                                   end

                  //ANDLW
                  12'b1110_xxxx_xxxx: begin
                                     load_W=1;
                                     load_Z=1;
                                   end

                  //CALL
                  12'b1001_xxxx_xxxx: begin
                                     load_from_PC=1;
                                     load_PC_from_Literal=1;
                                     load_from_stk1=1;
                                     next_state=S_wait;
                                   end

                  //CLRWDT
                  12'b0000_0000_0100: begin
                                     clear_WDT=1;
                                     load_TO=1;
                                     load_PD=1;
                                     set_TO=1;
                                     set_PD=1;
                                     if(link)
                                       clear_prescaler=1;
                                     next_state=S_wait;
                                   end

                  //GOTO
                  12'b101x_xxxx_xxxx: begin
                                     load_PC_from_Literal=1;
                                     PCH8_mux_sel=1;
                                     next_state=S_wait;
                                   end

                  //IORLW
                  12'b1101_xxxx_xxxx: begin
                                     load_W=1;
                                     load_Z=1;
                                     next_state=S_wait;
                                   end

                  //MOVLW
                  12'b1100_xxxx_xxxx: begin
                                     load_W=1;
                                     next_state=S_wait;
                                   end

                  //OPTION
                  12'b0000_0000_0010: begin
                                    load_OPTION=1;
                                    next_state=1;
                                  end

                  //RETLW
                  12'b1000_xxxx_xxxx: begin
                                     load_W=1;
                                     load_stk1_to_PC=1;
                                     load_from_stk2=1;
                                     next_state=S_wait;
                                   end

                  //SLEEP
                  12'b0000_0000_0011: begin
                                     clear_WDT=1;
                                     if(link)
                                       clear_prescaler=1;
                                     load_TO=1;
                                     load_PD=1;
                                     set_TO=1;
                                     next_state=S_wait;
                                   end

                  //TRIS
                  12'b0000_0000_0xxx:  begin
                                     if(instruction_reg_out[2:0]==3'b101)
                                       load_TRISA=1;
                                     else if(instruction_reg_out[2:0]==3'b110)
                                       load_TRISB=1;
                                     else if(instruction_reg_out[2:0]==3'b111)
                                       load_TRISC=1;
                                     next_state=S_wait;
                                   end

                  //XORLW
                  12'b1111_xxxx_xxxx: begin
                                    load_W=1;
                                    load_Z=1;
                                    next_state=S_wait;
                                  end

                  default: next_state=S_wait;
                endcase
              end

     S_wait:  next_state=S_get_ins1;

     S_get_ins1:  begin
                      load_ins=1;
                      casex(instruction_reg_out)
                        //DECFSZ,INCFSZ
                        12'b0010_11xx_xxxx,12'b0011_11xx_xxxx: begin
                                                          if(Z)
                                                            sel_code=1;
                                                          next_state=S_PC_decode;
                                                        end

                        //BTFSC,BTFSS
                        12'b0110_xxxx_xxxx,12'b0111_xxxx_xxxx:  begin
                                                           if(test)
                                                             sel_code=1;
                                                           next_state=S_PC_decode;
                                                         end

                        default: next_state=S_PC_decode;
                      endcase
                    end
      endcase
     end
endmodule     
