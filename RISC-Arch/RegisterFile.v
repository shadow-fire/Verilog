module RegisterFile(Read_data1,Read_data2,Read_register1,Read_register2,Write_register,Write_data,RegWrite, sll, RegDst, clk);
  
  output reg [31:0] Read_data1,Read_data2 ;
  input wire [4:0]  Read_register1,Read_register2,Write_register;
  input wire RegWrite,clk,sll, RegDst;
  input wire[31:0] Write_data;
  reg[5:0] i;
  reg[31:0] RegisterFile[0:31];
  wire [4:0] RegDstMux;
  
  // We assign the Destination Register with the help of RegDstMux.
  assign RegDstMux = RegDst ? Write_register : Read_register2;   
    
    always @({sll, clk})
      begin
            
          if(sll == 1'b1)
            Read_data1<= RegisterFile[Read_register2];
          else
            Read_data1<= RegisterFile[Read_register1];
            
           Read_data2<= RegisterFile[Read_register2];    
       end
        
    always@(RegWrite)
        begin
          #1
           if(RegWrite == 1'b1)
           RegisterFile[RegDstMux]<= Write_data;
        end
        
        
        initial
          begin
            for(i=0;i<32;i=i+1)
                RegisterFile[i] = 32'd0;
                
            RegisterFile[1] <= 32'd1;
            RegisterFile[2] <= 32'd2;
          end 
          
      endmodule