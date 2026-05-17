module MEM(
input clk,	
input [31:0]Address,
input [31:0]WriteData,
input MemToWrite,
input MemToRead,
output reg [31:0]ReadData
);

reg [31:0]mem[0:31];

initial
begin
	$readmemb("TestF1_MemInst.mem",mem);
end

always @* begin
	if(MemToRead)
		ReadData=mem[Address[6:2]];
	else
		ReadData=32'b0;
   end

always @* begin
	if(MemToWrite)
		mem[Address[6:2]] <= WriteData;
  end
endmodule