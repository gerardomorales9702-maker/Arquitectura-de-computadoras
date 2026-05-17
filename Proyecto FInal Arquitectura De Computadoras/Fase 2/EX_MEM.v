module EX_MEM(
    input clk,
    input reset,
    input branch_in,
    input memRead_in,
    input memWrite_in,
    input regWrite_in,
    input memToReg_in,
    input [31:0] branch_target_in, 
    input zero_in,                
    input [31:0] alu_result_in,   
    input [31:0] write_data_in,    
    input [4:0] write_reg_in,      
    output reg branch_out,
    output reg memRead_out,
    output reg memWrite_out,
    output reg regWrite_out,
    output reg memToReg_out,
    output reg [31:0] branch_target_out,
    output reg zero_out,
    output reg [31:0] alu_result_out,
    output reg [31:0] write_data_out,
    output reg [4:0] write_reg_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // En caso de reset, limpia todas las salidas
            branch_out <= 0;
            memRead_out <= 0;
            memWrite_out <= 0;
            regWrite_out <= 0;
            memToReg_out <= 0;

            branch_target_out <= 32'b0;
            zero_out <= 0;
            alu_result_out <= 32'b0;
            write_data_out <= 32'b0;
            write_reg_out <= 5'b00000;
        end else begin
            // En cada ciclo de reloj, pasa las entradas a las salidas
            branch_out <= branch_in;
            memRead_out <= memRead_in;
            memWrite_out <= memWrite_in;
            regWrite_out <= regWrite_in;
            memToReg_out <= memToReg_in;

            branch_target_out <= branch_target_in;
            zero_out <= zero_in;
            alu_result_out <= alu_result_in;
            write_data_out <= write_data_in;
            write_reg_out <= write_reg_in;
        end
    end

endmodule
