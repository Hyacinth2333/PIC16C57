module ALU(input[7:0] W_out,
           input[7:0] read_out,
           input[11:0] instruction_reg_out,
           input status_C,
           output reg[7:0] ALU_out,
           output reg Z,DC,C,test);
       always@(*)
         casex(instruction_reg_out)
           //ADDWF
           12'b0001_11xx_xxxx:  begin
                              {DC,ALU_out[3:0]}=W_out[3:0]+read_out[3:0];
                              {C,ALU_out[7:4]}={read_out[7:4]+DC}+W_out[7:4];
                              test=1'bx;
                                end
          //ANDWF
          12'b0001_01xx_xxxx:  begin
                             ALU_out=W_out&read_out;
                             DC=1'bx;
                             C=1'bx;
                             test=1'bx;
                           end
          //CLRF
          12'b0000_011x_xxxx:  begin
                            ALU_out=8'b0;
                            test=1'bx;
                            DC=1'bx;
                            C=1'bx;
                           end
          //CLRW
          12'b0000_0100_0000:  begin
                            ALU_out=8'b0;
                            test=1'bx;
                            DC=1'bx;
                            C=1'bx;
                           end
          //COMF
          12'b0010_01xx_xxxx:  begin
                            ALU_out=~read_out;
                            test=1'bx;
                            DC=1'bx;
                            C=1'bx;
                           end
          //DECF
          12'b0000_11xx_xxxx:  begin
                            ALU_out=read_out-1;
                            test=1'bx;
                            DC=1'bx;
                            C=1'bx;
                           end
          //DECFSZ
          12'b0010_11xx_xxxx:  begin
                            ALU_out=read_out-1;
                            test=1'bx;
                            DC=1'bx;
                            C=1'bx;
                           end
          //INCF
          12'b0010_10xx_xxxx:  begin
                            ALU_out=read_out+1;
                            test=1'bx;
                            DC=1'bx;
                            C=1'bx;
                            end
         //INCFSZ
         12'b0011_11xx_xxxx:  begin 
                            ALU_out=read_out+1;
                            test=1'bx;
                            DC=1'bx;
                            C=1'bx;
                          end
        //IORWF
        12'b0001_00xx_xxxx:  begin
                           ALU_out=W_out|read_out;
                           test=1'bx;
                           DC=1'bx;
                           C=1'bx;
                         end
        //MOVF
        12'b0010_00xx_xxxx:  begin
                          ALU_out=read_out;
                          test=1'bx;
                          DC=1'bx;
                          C=1'bx;
                         end
       //MOVWF
       12'b0000_001x_xxxx: begin
                         ALU_out=W_out;
                         test=1'bx;
                         DC=1'bx;
                         C=1'bx;
                       end
       //NOP
       12'b0000_0000_0000: begin
                         ALU_out=8'bxxxx_xxxx;
                         test=1'bx;
                         DC=1'bx;
                         C=1'bx;
                       end
       //RLF
       12'b0011_01xx_xxxx: begin
                        {C,ALU_out}={read_out,status_C};
                        DC=1'bx;
                        test=1'bx;
                       end
       //RRF
       12'b0011_00xx_xxxx: begin
                        {C,ALU_out}={read_out[0],status_C,read_out[7:1]};
                        DC=1'bx;
                        test=1'bx;
                       end
      //SUBWF
      12'b0000_10xx_xxxx:  begin
                        {DC,ALU_out[3:0]}={1'b1,read_out[3:0]}-{1'b0,W_out[3:0]};
                        {C,ALU_out[7:4]}={1'b1,(read_out[7:4]-~DC)}-{1'b0,W_out[7:4]};
                        test=1'bx;
                      end
      //SWAP
      12'b0011_10xx_xxxx: begin
                        ALU_out={read_out[3:0],read_out[7:4]};
                        test=1'bx;
                        DC=1'bx;
                        C=1'bx;
                      end
      //XORWF
      12'b0001_10xx_xxxx: begin
                        ALU_out=read_out^W_out;
                        test=1'bx;
                        DC=1'bx;
                        C=1'bx;
                      end
      //BCF
      12'b0100_xxxx_xxxx: begin
                          case(instruction_reg_out[7:5])
	                  3'b111: ALU_out={1'b0,read_out[6:0]};
                          3'b110: ALU_out={read_out[7],1'b0,read_out[5:0]};
                          3'b101: ALU_out={read_out[7:6],1'b0,read_out[4:0]};
                          3'b100: ALU_out={read_out[7:5],1'b0,read_out[3:0]};
                          3'b011: ALU_out={read_out[7:4],1'b0,read_out[2:0]};
                          3'b010: ALU_out={read_out[7:3],1'b0,read_out[1:0]};
                          3'b001: ALU_out={read_out[7:2],1'b0,read_out[0]};
                          3'b000: ALU_out={read_out[7:1],1'b0};
                          default: ALU_out=read_out;
                          endcase
                        test=1'bx;
                        DC=1'bx;
                        C=1'bx;
                      end
       //BSF
       12'b0101_xxxx_xxxx: begin
                        case(instruction_reg_out[7:5])
	                  3'b111: ALU_out={1'b1,read_out[6:0]};
                          3'b110: ALU_out={read_out[7],1'b1,read_out[5:0]};
                          3'b101: ALU_out={read_out[7:6],1'b1,read_out[4:0]};
                          3'b100: ALU_out={read_out[7:5],1'b1,read_out[3:0]};
                          3'b011: ALU_out={read_out[7:4],1'b1,read_out[2:0]};
                          3'b010: ALU_out={read_out[7:3],1'b1,read_out[1:0]};
                          3'b001: ALU_out={read_out[7:2],1'b1,read_out[0]};
                          3'b000: ALU_out={read_out[7:1],1'b1};
                          default: ALU_out=read_out;
                          endcase
                        test=1'bx;
                        DC=1'bx;
                        C=1'bx;
                       end
       //BTFSC
       12'b0110_xxxx_xxxx:  begin
                          ALU_out=8'bxxxx_xxxx;
                          test=~read_out[instruction_reg_out[7:5]];
                          DC=1'bx;
                          C=1'bx;
                        end
       //BTFSS
       12'b0111_xxxx_xxxx: begin
                         ALU_out=8'bxxxx_xxxx;
                         test=read_out[instruction_reg_out[7:5]];
                         DC=1'bx;
                         C=1'bx;
                       end
       //ANDLW
       12'b1110_xxxx_xxxx: begin
                          ALU_out=W_out&instruction_reg_out[7:0];
                          DC=1'bx;
                          C=1'bx;
                          test=1'bx;
                        end
       //IORLW
       12'b1101_xxxx_xxxx:  begin 
                          ALU_out=W_out|instruction_reg_out[7:0];
                          DC=1'bx;
                          C=1'bx;
                          test=1'bx;
                        end
       //MOVLW
       12'b1100_xxxx_xxxx: begin
                         ALU_out=instruction_reg_out[7:0];
                         DC=1'bx;
                         C=1'bx;
                         test=1'bx;
                       end
       //OPTION
       12'b0000_0000_0010: begin
                         ALU_out=W_out;
                         DC=1'bx;
                         C=1'bx;
                         test=1'bx;
                       end
       //RETLW
       12'b1000_xxxx_xxxx: begin
                         ALU_out=instruction_reg_out[7:0];
                         DC=1'bx;
                         C=1'bx;
                         test=1'bx;
                       end
       //TRIS
       12'b0000_0000_0xxx: begin
                         ALU_out=W_out;
                         DC=1'bx;
                         C=1'bx;
                         test=1'bx;
                       end
      //XORLW
      12'b1111_xxxx_xxxx: begin
                        ALU_out=instruction_reg_out[7:0]^W_out;
                        DC=1'bx;
                        C=1'bx;
                        test=1'bx;
                      end
      default:        begin
                        ALU_out=8'bxxxx_xxxx;
                        DC=1'bx;
                        C=1'bx;
                        test=1'bx;
                      end
     endcase

  always@(ALU_out)
    if(ALU_out==8'b0)
      Z=1'b1;
    else
      Z=1'b0;
endmodule




                             
