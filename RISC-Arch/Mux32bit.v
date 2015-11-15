module Mux32bit (y,a,b,sel);
  output reg [31:0] y;
  input wire [31:0] a,b;
  input wire sel;

always@(*)

begin
  casez(sel)
    1'b0: y<=a;
    1'b1: y<=b;
    default: y<=1'bz;
  endcase
end

endmodule


