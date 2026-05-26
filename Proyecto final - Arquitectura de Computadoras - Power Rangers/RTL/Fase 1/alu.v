module ALU(
input [31:0]A,
input [31:0]B,
input [3:0]sel,
output [31:0]R
);

wire [31:0] c_1,c_2,c_3,c_4,c_5;

M_SUM32B_COMP sumaComp(
.a(A[31:0]),
.b(B[31:0]),
.s(c_1[31:0])
);

M_R32B_COMP restaComp(
.a(A[31:0]),
.b(B[31:0]),
.s(c_2[31:0])
);

M_OR32B_COMP orComp(
.a(A[31:0]),
.b(B[31:0]),
.s(c_3[31:0])
);

M_AND32B_COMP andComp(
.a(A[31:0]),
.b(B[31:0]),
.s(c_4[31:0])
);

M_SLT32B_COMP sltComp(
.a(A[31:0]),
.b(B[31:0]),
.s(c_5[31:0])
);

M_MUX5A1 multiplexor(
.suma(c_1),
.resta(c_2),
._or(c_3),
._and(c_4),
.slt(c_5),
.ALUctl(sel),
.Resultado(R)
);

endmodule


module M_AND32B_COMP(
input [31:0]a,
input [31:0]b,
output [31:0]s
);

assign s=a&b;

endmodule

module M_OR32B_COMP(
input [31:0]a,
input [31:0]b,
output [31:0]s
);

assign s=a|b;

endmodule

module M_SLT32B_COMP(
input [31:0]a,
input [31:0]b,
output [31:0]s
);

assign s=(a<b)?32'b1:32'b0;

endmodule


module M_SUM32B_COMP(
input [31:0]a,
input [31:0]b,
output [31:0]s
);

assign s=a+b;

endmodule

module M_R32B_COMP(
input [31:0]a,
input [31:0]b,
output [31:0]s
);

assign s=a-b;

endmodule

module M_MUX5A1(
input [31:0]suma,resta,_or,_and,slt,
input [3:0]ALUctl,
output reg [31:0]Resultado
);

always @(ALUctl)
	begin
		case(ALUctl)
			4'b0000:Resultado=suma;
			4'b0001:Resultado=resta;
			4'b0010:Resultado=_or;
			4'b0011:Resultado=_and;
			4'b0100:Resultado=slt;
		endcase
	end

endmodule
