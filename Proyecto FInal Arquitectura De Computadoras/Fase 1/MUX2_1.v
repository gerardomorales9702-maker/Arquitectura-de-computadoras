module MUX2_1(
input [31:0]ALUR,
input [31:0]Read_data,
input MemToReg,
output [31:0]Write_data
);

assign Write_data=(MemToReg)?Read_data:ALUR;

endmodule
