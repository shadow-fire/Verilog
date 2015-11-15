module ControlUnit(PCWriteCond, PCWrite, IorD, MemRead, MemWrite, MemtoReg, IRWrite, PCSource, ALUControl, ALUSrcB, ALUSrcA, RegWrite, RegDst, sll, opcode, funct,zero, clock);
  output reg PCWriteCond, PCWrite, IorD, MemRead, MemWrite, MemtoReg, IRWrite, ALUSrcA, RegWrite, RegDst, sll;
  output reg [1:0] ALUSrcB, PCSource;
  output reg [3:0] ALUControl; 
  input wire [5:0]opcode, funct;
  input wire zero, clock;
  reg [3:0]next_state;


initial
    begin
      PCWriteCond = 1'b0;
      PCWrite = 1'b0;
      IorD = 1'b0;
      MemRead = 1'b0;
      MemWrite = 1'b0;
      MemtoReg = 1'b0;
      IRWrite = 1'b0;
      PCWrite = 1'b0;
      ALUSrcA = 1'b0;
      RegWrite = 1'b0;
      RegWrite = 1'b0;
      RegDst = 1'b0;
      sll = 1'b0;
      next_state = 4'h0; 
      ALUSrcB = 2'b00;
      PCSource = 2'b00;
      ALUControl = 4'b1111;
      
    end
    
    
    
    always @(posedge clock)
      begin
        IRWrite = 1'b0;
        MemRead = 1'b0;
        MemWrite <= 1'b0;
        RegWrite = 1'b0;
        PCWriteCond <= 1'b0;
        PCWrite = 1'b0;
        IorD <= 1'b0;
        case({next_state})
          4'h0:begin
                  MemRead <= 1'b1;
                  ALUSrcA <= 1'b0;
                  IorD <= 1'b0;
                  IRWrite <= 1'b1;
                  ALUSrcB <= 2'b01;
                  ALUControl <= 4'b0010;
                  PCWrite <= 1'b1;
                  PCSource <= 2'b00;
                  next_state <=4'h1;
                end
          4'h1:begin
                  ALUSrcA <= 1'b0;
                  ALUSrcB <= 2'b11;
                  ALUControl <= 4'b0010;
                  sll <= 1'b0;
                  if(opcode == 6'b000000)
                    begin
                      if(funct == 6'h37)
                        begin
                          sll <= 1'b1;
                          next_state <= 4'hA;
                        end
                      else
                        begin
                          next_state <= 4'h6;
                        end
                    end
                  else if((opcode == 6'h01)||(opcode == 6'h02))
                      next_state <= 4'h2;  
                  else if((opcode == 6'h3)||(opcode == 6'h4))
                      next_state <= 4'hC;
                  else if(opcode == 6'h5)
                      next_state <= 4'h8;
                  else if(opcode == 6'h6)
                      next_state <= 4'h9;
                end       
          4'h2:begin
                  ALUSrcA <= 1'b1;
                  ALUSrcB <= 2'b10;
                  ALUControl <= 4'b0010;
                  IorD <= 1'b1;
                  if(opcode == 6'h01)
                    next_state <= 4'h3;
                  else if(opcode == 6'h02)
                    next_state <= 4'h5;                
                end
          4'h3:begin
                  MemRead <= 1'b1;
                  IorD <= 1'b1;
                  ALUControl <= 4'b1111;
                  next_state <= 4'h4;
                end
          4'h4:begin
                  RegWrite <= 1'b1;
                  MemtoReg <= 1'b1;
                  RegDst <= 1'b0;
                  next_state <= 4'h0;
                end
          4'h5:begin
                  MemWrite <= 1'b1;
                  IorD <= 1'b1;
                  next_state <= 4'h0;
                end
          4'h6:
                begin
                  ALUSrcA <= 1'b1;
                  ALUSrcB <= 2'b00;
                  case(funct)
                      6'h32: ALUControl <= 4'b0010;
                      6'h33: ALUControl <= 4'b0110;
                      6'h34: ALUControl <= 4'b0000;
                      6'h35: ALUControl <= 4'b0001;
                      6'h36: ALUControl <= 4'b0011;
                  endcase
                  next_state <= 4'h7;
               end
          4'h7:begin
                  RegDst <= 1'b1;
                  RegWrite <= 1'b1;
                  MemtoReg <= 1'b0;
                  ALUControl <= 4'b1111;
                  next_state <= 4'h0;
                end
          4'h8:begin
                  ALUSrcA <= 1'b1;
                  ALUSrcB <= 2'b00;
                  PCWriteCond <= 1'b1;
                  PCSource <= 2'b01;
                  PCWrite <= 1'b1;
                  ALUControl <= 4'b0110;
                  next_state <= 4'h0; 
                end
          4'h9:begin
                  PCWrite <= 1'b1;
                  PCSource <= 2'b10;
                  ALUControl <= 4'b1111;
                  next_state <= 4'h0;
                end
          4'hA:begin
                  ALUSrcA <= 1'b1;
                  ALUSrcB <= 2'b10;
                  ALUControl <= 4'b1001;
                  next_state <= 4'hB; 
                end
          4'hB:begin
                  RegDst  <= 1'b1;
                  RegWrite <= 1'b1;
                  MemtoReg <= 1'b0;
                  ALUControl <= 4'b1111;
                  next_state <= 4'h0;
                end
          4'hC:begin
                   ALUSrcA <= 1'b1;
                   ALUSrcB <= 2'b10;
                   if(opcode == 6'h3)
                     ALUControl <= 4'b0010; 
                   else
                     ALUControl <= 4'b0110; 
                   next_state <= 4'hD;
                end
          4'hD:begin
                  RegDst <= 1'b0;
                  RegWrite <= 1'b1;
                  MemtoReg <= 1'b0;
                  ALUControl <= 4'b1111;
                  next_state <= 0;
                end
          endcase
      end
    
    
 endmodule
  


