module UC(
input [5:0]OP,
output reg MemToReg,
output reg MemToWrite,
output reg MemToRead,
output reg [2:0]ALUOp,
output reg RegWrite
);

always @* begin

 case(OP)
 6'b000000:
 begin
   MemToReg=1'b0;
   MemToWrite=1'b0;
   MemToRead=1'b0;
   ALUOp=3'b010;
   RegWrite=1'b1;
  end
  default: 
    begin
	MemToReg=1'b0;
   	MemToWrite=1'b0;
	MemToRead=1'b0;
   	ALUOp=3'b000;
   	RegWrite=1'b0;
    end
 endcase

end

endmodule