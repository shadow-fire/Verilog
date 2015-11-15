module ALU(zero, ALUOut, ALUcontrol, Operand1, Operand2, clk);
  input wire [31:0] Operand1, Operand2;
  input wire [3:0]ALUcontrol;
  input wire clk;
  output reg zero;
  output reg [31:0]ALUOut;
  
  
  initial
    begin
        ALUOut = 32'h0000_0000;
        zero = 1'b1;
    end
    
  always@({Operand1, Operand2, clk})  
      begin 

          casex(ALUcontrol)
          4'b0010: ALUOut <= Operand1 + Operand2;
          4'b0110: ALUOut <= Operand1 - Operand2;
          4'b0000: ALUOut <= Operand1 & Operand2;
          4'b0001: ALUOut <= Operand1 | Operand2;
          4'b0011: ALUOut <= ~(Operand1 | Operand2);
          4'b1001: ALUOut <= Operand1 << Operand2 ;
          4'b1111: ;
          default: ALUOut <= 32'h0000_0000;
          endcase
      end
      
 always@(ALUOut)       
      begin
        if(ALUOut == 32'h0000_0000)
            zero = 1'b1;
        else
            zero = 1'b0;
            
        
      end
                                       
endmodule
