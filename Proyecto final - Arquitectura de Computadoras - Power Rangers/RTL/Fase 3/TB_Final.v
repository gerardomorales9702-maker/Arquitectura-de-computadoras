`timescale 1ns / 1ps

module DPTR_tb;

    reg clk;
    reg reset;


    DPTR uut (
        .clk(clk),
        .reset(reset)
    );


    always begin
        #5 clk = ~clk;
    end


    initial begin

        clk = 0;
        reset = 1;
    
        #20;
        reset = 0;


        #500000;

        $display("========================================");
        $display("RESULTADO FINAL DE MEMORIA");
        $display("========================================");

        $display("mem[0] = %d", uut.mem.mem[0]);
        $display("mem[1] = %d", uut.mem.mem[1]);
        $display("mem[2] = %d", uut.mem.mem[2]);
        $display("mem[3] = %d", uut.mem.mem[3]);
        $display("mem[4] = %d", uut.mem.mem[4]);
        $display("mem[5] = %d", uut.mem.mem[5]);
        $display("mem[6] = %d", uut.mem.mem[6]);
        $display("mem[7] = %d", uut.mem.mem[7]);
        $display("mem[8] = %d", uut.mem.mem[8]);

        $display("========================================");

        $stop;
    end

endmodule