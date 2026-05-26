module IMEM(
    input [31:0] Address,
    output [31:0] Instruction
);

reg [31:0] mem [0:31];

initial
begin
    $readmemb("bubble_decodificado.mem", mem);
end

// Address[6:2]:
// divide entre 4 para direccionamiento por palabra
assign Instruction = mem[Address[6:2]];

endmodule
