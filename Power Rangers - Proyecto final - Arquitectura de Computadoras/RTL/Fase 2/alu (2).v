module ALU(
input [31:0]A,
input [31:0]B,
input [3:0]sel,
output [31:0]R,
output Zero
);

wire [31:0] c_1,c_2,c_3,c_4,c_5;

M_SUM32B_COMP sumaComp(
.a(A),
.b(B),
.s(c_1)
);

M_R32B_COMP restaComp(
.a(A),
.b(B),
.s(c_2)
);

M_OR32B_COMP orComp(
.a(A),
.b(B),
.s(c_3)
);

M_AND32B_COMP andComp(
.a(A),
.b(B),
.s(c_4)
);

M_SLT32B_COMP sltComp(
.a(A),
.b(B),
.s(c_5)
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

assign Zero = (R == 32'b0);

endmodule