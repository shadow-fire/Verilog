module IR(OutputInstruction, IRWrite, InputInstruction);
  input wire [31:0]InputInstruction;
  output reg [31:0]OutputInstruction;
  input wire IRWrite;
  
  always@(IRWrite)
      begin
        if( IRWrite == 1'b1)
          begin
            assign OutputInstruction = InputInstruction;
          end
      end
      
endmodule

