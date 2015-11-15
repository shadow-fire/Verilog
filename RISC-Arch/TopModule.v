module TopModule(clock);
  
         // input/output 
         input wire clock; 
        

         // Control Signals given by the Control Unit.

         wire [1:0] ALUSrcB, PCSource; 
         wire [3:0] ALUControl;
         wire PCWriteCond, PCWrite, IorD, MemRead, MemWrite, MemtoReg, IRWrite, ALUSrcA, RegWrite, RegDst,zero; 
         
         

         // Various Registers and Latches
         wire[31:0] PCmuxout, InputInstruction, MDROut, MemInputMux, SignExtend, SignExtendShift, RD1, 
         RD2, ARegOut, BRegOut, ALUInputA, ALUInputB, ALUResult, ALURegOut, nextpc, pcshift2out, IROut, MemData, sllExtend; 
                  

         // PC is declared as a register as its value is updated with the help of signals and it is required to hold its value.
         reg[31:0] PC, pALUResult; 
         
         
         // To decide whether rt or rd is the Destination Register. 
         wire [4 :0] RegDstMux; 

         // PCWriteEnable decides if the PC can be written or not.
         wire PCWriteEnable; 
         wire tempPCvar; 

             
         assign PCmuxout = IorD ? ALURegOut : PC; 

         /*
          Memory Module instantiation
              PCmuxout is address for memory.
              BRegOut is data to be stored.
         */
         Memory Memory1(MemData, PCmuxout, BRegOut, MemWrite, MemRead,  clock); //PCmuxout is address for memory
                                                                                //BRegOut is data to be stored

         /*
          Instruction Register Instantiation
          It takes input from the memory and writes if IRWrite is 1.
         */
         IR IR1(IROut, IRWrite, MemData);


         //The Memory Data Register.
         latch MDR(MDROut ,MemData, clock); 
         
        
        
         /*
          Control Unit instantiation.
          It sends signals to all other modules to modify their working.
         */
         ControlUnit Control(PCWriteCond, PCWrite, IorD, MemRead, MemWrite, MemtoReg, IRWrite, PCSource, ALUControl, ALUSrcB, ALUSrcA, RegWrite, RegDst, sll, IROut[31:26], IROut[5:0],zero, clock);

       
         // A 32 bit Mux which selects from Output from data or ALURegOut to write into the Destination Register.
         Mux32bit WriteMuxInput(MemInputMux, ALURegOut, MDROut, MemtoReg);

 
 
         // Register File instantiation.
         RegisterFile registers(RD1,RD2,IROut[25:21],IROut[20:16],IROut[15:11],MemInputMux,RegWrite, sll, RegDst, clock); 
         latch A( ARegOut , RD1, clock); 
         latch B( BRegOut , RD2, clock); 


         // Sign Extension for I-type, Shift amount value and shifting for branch.
         assign sllExtend = {{27{1'b0}},IROut[10:6]};
         assign SignExtend = sll ? sllExtend : {{16{IROut[15]}},IROut[15:0]};
         assign SignExtendShift = SignExtend << 2; 



         // 4:1 Mux for Deciding InputB to the ALU depenending on ALUSrcB.
         assign ALUInputA = ALUSrcA ? ARegOut : PC; 
         Mux_4to1 Bmux(ALUInputB, BRegOut, 32'd4, SignExtend, SignExtendShift, ALUSrcB ); 


         //ALU and ALUOut register
         ALU alu1( zero, ALUResult, ALUControl, ALUInputA, ALUInputB, clock);
         
         
         latch aluout(ALURegOut, ALUResult, clock); 

         // Calculation of jumpaddress and choosing the next PC depending on PCSource.
         wire [31:0] jumpaddress; 
         assign jumpaddress = {PC[31:28], IROut[25:0], 2'b00}; 
         Mux_4to1 PCMux(nextpc, ALUResult, pALUResult, jumpaddress, jumpaddress, PCSource); 



         // The PC is updated depending on the value of PCWriteEnable. 
         assign tempPCvar = zero&PCWriteCond; 
         assign PCWriteEnable = tempPCvar | PCWrite; 
         
         always@(posedge clock) 
          begin 
           if(PCWriteEnable==1'b1)
            begin 
                 PC = nextpc; 
           end 
         end 
      
        always@(ALUResult)
          begin
            #40
            pALUResult <= ALUResult;
          end
          

        
        initial
        begin
          PC<=32'h0000_0000;
        end
        

  endmodule