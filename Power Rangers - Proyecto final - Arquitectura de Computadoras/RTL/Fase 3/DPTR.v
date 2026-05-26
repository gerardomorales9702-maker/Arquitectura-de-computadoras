module DPTR(
    input clk,
    input reset
);

    wire [31:0] pc_actual;
    wire [31:0] pc_sig;
    wire [31:0] insTR;
    wire [31:0] next_pc_mux_out;
    wire pc_src;
    wire [31:0] ex_mem_branch_target;
    
    pc my_pc(
        .clk(clk),
        .reset(reset),
        .addnew(next_pc_mux_out),
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

    MUX2_1 pc_src_mux(
        .ALUR(pc_sig),
        .Read_data(ex_mem_branch_target),
        .MemToReg(pc_src),
        .Write_data(next_pc_mux_out)
    );

    wire [31:0] if_id_pc_plus_4;
    wire [31:0] if_id_instruction;

    IF_ID buffer_if_id(
        .clk(clk),
        .reset(reset),
        .pc_plus_4_in(pc_sig),
        .instruction_in(insTR),
        .pc_plus_4_out(if_id_pc_plus_4),
        .instruction_out(if_id_instruction)
    );

    wire C_RegDst, C_ALUSrc, C_Branch, C_MemToRead, C_MemToWrite, C_RegWrite, C_MemToReg;
    wire [2:0] C_ALUOp;
    wire [31:0] DR1_wire, DR2_wire;
    wire [31:0] sign_extended_wire;
    wire [4:0] wb_write_reg;
    wire [31:0] wb_write_data;
    wire wb_regWrite;

    UC uc(
        .OP(if_id_instruction[31:26]),
        .RegDst(C_RegDst),
        .ALUSrc(C_ALUSrc),
        .MemToReg(C_MemToReg),
        .MemWrite(C_MemToWrite), 
        .MemRead(C_MemToRead),   
        .Branch(C_Branch),
        .ALUOp(C_ALUOp),
        .RegWrite(C_RegWrite)
    );

    BR br(
        .clk(clk),                 
        .WE(wb_regWrite),
        .AR1(if_id_instruction[25:21]),
        .AR2(if_id_instruction[20:16]),
        .AW(wb_write_reg),
        .DW(wb_write_data),
        .DR1(DR1_wire),
        .DR2(DR2_wire)
    );

    sign_extend se(
        .in(if_id_instruction[15:0]),
        .out(sign_extended_wire)
    );

    wire id_ex_regDst, id_ex_aluSrc, id_ex_branch, id_ex_memRead, id_ex_memWrite, id_ex_regWrite, id_ex_memToReg;
    wire [2:0] id_ex_aluOp;
    wire [31:0] id_ex_pc_plus_4, id_ex_read_data_1, id_ex_read_data_2, id_ex_sign_extend;
    wire [4:0] id_ex_rt, id_ex_rd;
    wire [5:0] id_ex_funct;

    ID_EX buffer_id_ex(
        .clk(clk),
        .reset(reset),
        .regDst_in(C_RegDst),
        .aluOp_in(C_ALUOp),
        .aluSrc_in(C_ALUSrc),
        .branch_in(C_Branch),
        .memRead_in(C_MemToRead),