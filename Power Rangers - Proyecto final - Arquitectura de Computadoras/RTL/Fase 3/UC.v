module UC(
    input [5:0] OP,
    output reg RegDst,
    output reg ALUSrc,
    output reg MemToReg,
    output reg MemWrite,
    output reg MemRead,
    output reg Branch,
    output reg [2:0] ALUOp,
    output reg RegWrite
);

    always @(*) begin
        case(OP)
            6'b000000: begin // Tipo-R
                RegDst   = 1'b1;
                ALUSrc   = 1'b0;
                MemToReg = 1'b0;
                RegWrite = 1'b1;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 1'b0;
                ALUOp    = 3'b010;
            end
            6'b100011: begin // lw
                RegDst   = 1'b0;
                ALUSrc   = 1'b1;
                MemToReg = 1'b1;
                RegWrite = 1'b1;
                MemRead  = 1'b1;
                MemWrite = 1'b0;
                Branch   = 1'b0;
                ALUOp    = 3'b000;
            end
            6'b101011: begin // sw
                RegDst   = 1'bx;
                ALUSrc   = 1'b1;
                MemToReg = 1'bx;
                RegWrite = 1'b0;
                MemRead  = 1'b0;
                MemWrite = 1'b1;
                Branch   = 1'b0;
                ALUOp    = 3'b000;
            end
            6'b000100: begin // beq
                RegDst   = 1'bx;
                ALUSrc   = 1'b0;
                MemToReg = 1'bx;
                RegWrite = 1'b0;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 1'b1;
                ALUOp    = 3'b001;
            end
            default: begin
                RegDst   = 1'b0;
                ALUSrc   = 1'b0;
                MemToReg = 1'b0;
                RegWrite = 1'b0;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 1'b0;
                ALUOp    = 3'b000;
            end
        endcase
    end

endmodule