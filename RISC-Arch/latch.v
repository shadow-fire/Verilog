module latch(OutputData, InputData, clock);
  // Latch for A, B, MDROut, ALUOut
  input wire [31:0]InputData;
  output reg [31:0]OutputData;
  input wire clock;
  
  always@(posedge clock)
      begin
        assign OutputData = InputData;
      end
      
endmodule
