module Memory(MemData, Address, WriteData, MemWrite, MemRead, Clk); 
    input wire[31:0] Address, WriteData; 
    input wire MemRead, MemWrite, Clk; 
    output reg [31:0] MemData; 
   
    reg [7:0] MainMemory [0:1023]; 
   
    
    always @ (MemWrite, Address) 
      begin 
        
        if(MemWrite==1'b1)
          begin 
            MainMemory[Address] <= WriteData[31:24]; 
            MainMemory[Address+1] <= WriteData[23:16]; 
            MainMemory[Address+2] <= WriteData[15:8]; 
            MainMemory[Address+3] <= WriteData[7:0]; 
          end 
          
      end
        
    always@(MemRead, Address)
       begin
         #1
           if(MemRead == 1'b1)
             begin
              MemData[31:24] <= MainMemory[Address];
              MemData[23:16] <= MainMemory[Address+1];
              MemData[15:8] <= MainMemory[Address+2];
              MemData[7:0] <= MainMemory[Address+3];
             end
        
      end 
  
    
    initial 
      begin    
      // Load the Data and Instructions of program 
      
      
      // j 100h
      MainMemory[0] <= 8'b000110_00;
      MainMemory[1] <= 8'b000_00000;
      MainMemory[2] <= 8'b00000_000;
      MainMemory[3] <= 8'b01_100100;
      
      
      /*
      // beq r3,r0, 10h
      MainMemory[0] <= 8'b000101_00;
      MainMemory[1] <= 8'b011_00000;
      MainMemory[2] <= 8'b00000_000;
      MainMemory[3] <= 8'b00_001010;

      /*
      // addi r0, r2, 8h
      MainMemory[0] <= 8'b000100_00;
      MainMemory[1] <= 8'b010_00000;
      MainMemory[2] <= 8'b00000_000;
      MainMemory[3] <= 8'b00_000001;      
      
      /*
      // sw r2, 4(r3)
      MainMemory[0] <= 8'b000010_00;
      MainMemory[1] <= 8'b011_00010;
      MainMemory[2] <= 8'b00000_000;
      MainMemory[3] <= 8'b00_000100;
      
      /*
      // lw r0, 0(r3)
      MainMemory[0] <= 8'b000001_00;
      MainMemory[1] <= 8'b011_00000;
      MainMemory[2] <= 8'b00000_000;
      MainMemory[3] <= 8'b00_000000;
      
            
      /*
      // sll r3,r2,5h      
      MainMemory[0] <= 8'b000000_00;
      MainMemory[1] <= 8'b010_00001;
      MainMemory[2] <= 8'b00011_001;
      MainMemory[3] <= 8'b01_110111;
      
      
      /*
      // nor r3,r2,r1
      MainMemory[0] <= 8'b000000_00;
      MainMemory[1] <= 8'b010_00001;
      MainMemory[2] <= 8'b00011_000;
      MainMemory[3] <= 8'b00_110101;
      
      /*
      // nor r3,r2,r1
      MainMemory[0] <= 8'b000000_00;
      MainMemory[1] <= 8'b010_00001;
      MainMemory[2] <= 8'b00011_000;
      MainMemory[3] <= 8'b00_110110;
     
      /*
      // and r3,r2,r1
      MainMemory[0] <= 8'b000000_00;
      MainMemory[1] <= 8'b010_00001;
      MainMemory[2] <= 8'b00011_000;
      MainMemory[3] <= 8'b00_110100;
     
     
      /*
      // sub r3,r2,r1
      MainMemory[0] <= 8'b000000_00;
      MainMemory[1] <= 8'b010_00001;
      MainMemory[2] <= 8'b00011_000;
      MainMemory[3] <= 8'b00_110010;
      
      /*
      // add r3,r2,r1
      MainMemory[0] <= 8'b000000_00;
      MainMemory[1] <= 8'b010_00001;
      MainMemory[2] <= 8'b00011_000;
      MainMemory[3] <= 8'b00_110010;
      */
      end 
endmodule
