module branch_adder(
    input  [31:0] pc_mas_4,
    input  [31:0] desplazado,
    output [31:0] direccion_branch
);

assign direccion_branch = pc_mas_4 + desplazado;

endmodule
