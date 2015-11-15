module tb_TopModule(); 
  
  reg clock=0; 

  TopModule CPU(clock); 
  
  
  always 
    begin 
      #20 clock<=~clock; 
    end 
    
  initial 
    begin 
      #200 $stop; 
    end 
       
endmodule 
