`timescale 1ns/1ps
module TB_DPTR;

    reg clk;
    reg reset;

    DPTR uut(
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1; 

        #10;
        reset = 0; 

        #500;      
        $stop;
    end

endmodule

