module MEM_WB(
    input clk,
    input reset,
    input regWrite_in,
    input memToReg_in,
    input [31:0] read_data_in,   
    input [31:0] alu_result_in,  
    input [4:0] write_reg_in,    
    output reg regWrite_out,
    output reg memToReg_out,
    output reg [31:0] read_data_out,
    output reg [31:0] alu_result_out,
    output reg [4:0] write_reg_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // En caso de reset, limpia todas las salidas
            regWrite_out <= 0;
            memToReg_out <= 0;
            read_data_out <= 32'b0;
            alu_result_out <= 32'b0;
            write_reg_out <= 5'b00000;
        end else begin
            // En cada ciclo de reloj, pasa las entradas a las salidas
            regWrite_out <= regWrite_in;
            memToReg_out <= memToReg_in;
            read_data_out <= read_data_in;
            alu_result_out <= alu_result_in;
            write_reg_out <= write_reg_in;
        end
    end

endmodule
