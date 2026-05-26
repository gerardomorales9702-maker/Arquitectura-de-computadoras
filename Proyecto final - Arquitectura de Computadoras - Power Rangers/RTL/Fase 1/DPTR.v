module DPTR(
    input clk,
    input reset
);

    wire [31:0] pc_actual;
    wire [31:0] pc_sig;
    wire [31:0] insTR;
    
    wire C_RegWrite, C_MemToReg, C_MemToWrite, C_MemToRead;
    wire [2:0] C_ALUOp;
    wire [3:0] C_4; 
    
    wire [31:0] C_1; 
    wire [31:0] C_2; 
    wire [31:0] C_3; 
    wire [31:0] C_5; 
    wire [31:0] C_WriteData; 

    pc my_pc(
        .clk(clk),
        .reset(reset),
        .addnew(pc_sig),
        .address(pc_actual)
    );

    add32 pc_adder(
        .operando1(pc_actual),
        .operando2(32'd4),
        .resultado(pc_sig)
    );

    IMEM instruction_memory(
        .Address(pc_actual),
        .Instruction(insTR)
    );

    UC uc(
        .OP(insTR[31:26]),
        .MemToReg(C_MemToReg),
        .MemToWrite(C_MemToWrite),
        .MemToRead(C_MemToRead),
        .ALUOp(C_ALUOp),
        .RegWrite(C_RegWrite)
    );

    BR br(
        .clk(clk),                 
        .WE(C_RegWrite),
        .AR1(insTR[25:21]),
        .AR2(insTR[20:16]),
        .AW(insTR[15:11]),         
        .DW(C_WriteData),
        .DR1(C_1),
        .DR2(C_2)
    );

    ALuControl aluctrl(
        .FUNC(insTR[5:0]),
        .ALUOp(C_ALUOp),
        .salidaAC(C_4)
    );

    ALU alu(
        .A(C_1),
        .B(C_2),
        .sel(C_4),
        .R(C_3)
    );

    MEM mem(
        .clk(clk),                 
        .Address(C_3),
        .WriteData(C_2),
        .MemToWrite(C_MemToWrite),
        .MemToRead(C_MemToRead),
        .ReadData(C_5)
    );

    MUX2_1 mux2_1(
        .ALUR(C_3),
        .Read_data(C_5),
        .MemToReg(C_MemToReg),
        .Write_data(C_WriteData)
    );

endmodule


module IMEM(
    input [31:0] Address,
    output reg [31:0] Instruction
);
    reg [31:0] memory [0:63]; 

    initial begin
        $readmemb("TestF1_MemInst.mem", memory);
    end

    always @(*) begin
        Instruction = memory[Address[7:2]];
    end
endmodule

