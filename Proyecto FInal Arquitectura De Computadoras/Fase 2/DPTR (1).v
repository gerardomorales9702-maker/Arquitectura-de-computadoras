module DPTR(
    input clk,
    input reset
);

    wire [31:0] pc_next, pc_plus_4_if, instruction_if;
    reg [31:0] pc_current;
    wire branch_taken;
    wire [31:0] branch_target_mem;

    Mux21 #(32) pc_mux (
        .d0(pc_plus_4_if),
        .d1(branch_target_mem),
        .sel(branch_taken),
        .out(pc_next)
    );

    always @(posedge clk or posedge reset) begin
        if (reset)
            pc_current <= 32'b0;
        else
            pc_current <= pc_next;
    end

    assign pc_plus_4_if = pc_current + 4;

    wire [31:0] pc_plus_4_id, instruction_id;
    IF_ID buffer_if_id (
        .clk(clk), .reset(reset),
        .pc_plus_4_in(pc_plus_4_if), .instruction_in(instruction_if),
        .pc_plus_4_out(pc_plus_4_id), .instruction_out(instruction_id)
    );

    wire regDst_id, aluSrc_id, branch_id, memRead_id, memWrite_id, regWrite_id, memToReg_id;
    wire [2:0] aluOp_id;
    wire [31:0] read_data_1_id, read_data_2_id, sign_extend_id;
    
    wire regWrite_wb;
    wire [4:0] write_reg_wb;
    wire [31:0] write_data_wb;

    wire regDst_ex, aluSrc_ex, branch_ex, memRead_ex, memWrite_ex, regWrite_ex, memToReg_ex;
    wire [2:0] aluOp_ex;
    wire [31:0] pc_plus_4_ex, read_data_1_ex, read_data_2_ex, sign_extend_ex;
    wire [4:0] rt_ex, rd_ex;

    ID_EX buffer_id_ex (
        .clk(clk), .reset(reset),
        .regDst_in(regDst_id), .aluOp_in(aluOp_id), .aluSrc_in(aluSrc_id),
        .branch_in(branch_id), .memRead_in(memRead_id), .memWrite_in(memWrite_id),
        .regWrite_in(regWrite_id), .memToReg_in(memToReg_id),
        .pc_plus_4_in(pc_plus_4_id), .read_data_1_in(read_data_1_id),
        .read_data_2_in(read_data_2_id), .sign_extend_in(sign_extend_id),
        .rt_in(instruction_id[20:16]), .rd_in(instruction_id[15:11]),
        
        .regDst_out(regDst_ex), .aluOp_out(aluOp_ex), .aluSrc_out(aluSrc_ex),
        .branch_out(branch_ex), .memRead_out(memRead_ex), .memWrite_out(memWrite_ex),
        .regWrite_out(regWrite_ex), .memToReg_out(memToReg_ex),
        .pc_plus_4_out(pc_plus_4_ex), .read_data_1_out(read_data_1_ex),
        .read_data_2_out(read_data_2_ex), .sign_extend_out(sign_extend_ex),
        .rt_out(rt_ex), .rd_out(rd_ex)
    );

    wire [31:0] alu_in_b, alu_result_ex, branch_target_ex, shift_left_ex;
    wire [4:0] write_reg_ex;
    wire zero_ex;

    Mux21 #(5) regDst_mux (
        .d0(rt_ex),
        .d1(rd_ex),
        .sel(regDst_ex),
        .out(write_reg_ex)
    );

    Mux21 #(32) aluSrc_mux (
        .d0(read_data_2_ex),
        .d1(sign_extend_ex),
        .sel(aluSrc_ex),
        .out(alu_in_b)
    );

    assign shift_left_ex = sign_extend_ex << 2;
    assign branch_target_ex = pc_plus_4_ex + shift_left_ex;

    wire branch_mem, memRead_mem, memWrite_mem, regWrite_mem, memToReg_mem, zero_mem;
    wire [31:0] alu_result_mem, write_data_mem;
    wire [4:0] write_reg_mem;

    EX_MEM buffer_ex_mem (
        .clk(clk), .reset(reset),
        .branch_in(branch_ex), .memRead_in(memRead_ex), .memWrite_in(memWrite_ex),
        .regWrite_in(regWrite_ex), .memToReg_in(memToReg_ex),
        .branch_target_in(branch_target_ex), .zero_in(zero_ex),
        .alu_result_in(alu_result_ex), .write_data_in(read_data_2_ex), .write_reg_in(write_reg_ex),
        
        .branch_out(branch_mem), .memRead_out(memRead_mem), .memWrite_out(memWrite_mem),
        .regWrite_out(regWrite_mem), .memToReg_out(memToReg_mem),
        .branch_target_out(branch_target_mem), .zero_out(zero_mem),
        .alu_result_out(alu_result_mem), .write_data_out(write_data_mem), .write_reg_out(write_reg_mem)
    );

    wire [31:0] read_data_mem;

    assign branch_taken = branch_mem & zero_mem;

    wire memToReg_wb;
    wire [31:0] read_data_wb, alu_result_wb;

    MEM_WB buffer_mem_wb (
        .clk(clk), .reset(reset),
        .regWrite_in(regWrite_mem), .memToReg_in(memToReg_mem),
        .read_data_in(read_data_mem), .alu_result_in(alu_result_mem), .write_reg_in(write_reg_mem),
        
        .regWrite_out(regWrite_wb), .memToReg_out(memToReg_wb),
        .read_data_out(read_data_wb), .alu_result_out(alu_result_wb), .write_reg_out(write_reg_wb)
    );
    
    Mux21 #(32) memToReg_mux (
        .d0(alu_result_wb),
        .d1(read_data_wb),
        .sel(memToReg_wb),
        .out(write_data_wb)
    );

endmodule