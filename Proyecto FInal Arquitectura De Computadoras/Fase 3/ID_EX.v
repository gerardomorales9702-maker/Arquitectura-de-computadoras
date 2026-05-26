module ID_EX(
    input clk,
    input reset,
    input regDst_in,
    input [2:0] aluOp_in, 
    input aluSrc_in,
    input branch_in,
    input memRead_in,
    input memWrite_in,
    input regWrite_in,
    input memToReg_in,
    input [31:0] pc_plus_4_in,
    input [31:0] read_data_1_in,
    input [31:0] read_data_2_in,
    input [31:0] sign_extend_in,
    input [4:0] rt_in,
    input [4:0] rd_in,
    input [5:0] funct_in,
    output reg [5:0] funct_out,
    output reg regDst_out,
    output reg [2:0] aluOp_out,
    output reg aluSrc_out,
    output reg branch_out,
    output reg memRead_out,
    output reg memWrite_out,
    output reg regWrite_out,
    output reg memToReg_out,
    output reg [31:0] pc_plus_4_out,
    output reg [31:0] read_data_1_out,
    output reg [31:0] read_data_2_out,
    output reg [31:0] sign_extend_out,
    output reg [4:0] rt_out,
    output reg [4:0] rd_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // En caso de reset, limpia todas las salidas
            funct_out <= 6'b000000;
            regDst_out <= 0;
            aluOp_out <= 3'b000; 
            aluSrc_out <= 0;
            branch_out <= 0;
            memRead_out <= 0;
            memWrite_out <= 0;
            regWrite_out <= 0;
            memToReg_out <= 0;
            
            pc_plus_4_out <= 32'b0;
            read_data_1_out <= 32'b0;
            read_data_2_out <= 32'b0;
            sign_extend_out <= 32'b0;
            rt_out <= 5'b00000;
            rd_out <= 5'b00000;
        end else begin
            // En cada ciclo de reloj, pasa las entradas a las salidas
            regDst_out <= regDst_in;
            funct_out <= funct_in;
            aluOp_out <= aluOp_in; 
            aluSrc_out <= aluSrc_in;
            branch_out <= branch_in;
            memRead_out <= memRead_in;
            memWrite_out <= memWrite_in;
            regWrite_out <= regWrite_in;
            memToReg_out <= memToReg_in;
            
            pc_plus_4_out <= pc_plus_4_in;
            read_data_1_out <= read_data_1_in;
            read_data_2_out <= read_data_2_in;
            sign_extend_out <= sign_extend_in;
            rt_out <= rt_in;
            rd_out <= rd_in;
        end
    end

endmodule
