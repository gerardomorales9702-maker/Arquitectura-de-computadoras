module ALuControl(
input [2:0]ALUOp,
input [5:0]FUNC,
output reg [3:0]salidaAC
);

always @* begin
  salidaAC=4'b0000;
	case (ALUOp)
	3'b010:
	  begin
		case(FUNC)
		6'b100000: salidaAC=4'b0000;
		6'b100010: salidaAC=4'b0001;
		6'b100100: salidaAC=4'b0011;
		6'b100101: salidaAC=4'b0010;
		6'b101010: salidaAC=4'b0100;
		endcase
	  end
	endcase
end
endmodule
