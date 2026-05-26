`timescale 1ns / 1ps

module TB_DPTR;

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

        $readmemb("TestF2_MemInst.mem", uut.inst_mem.mem_array);
        
        #15;
        reset = 0; 
        
        #200;
        
        $stop;
    end
      
endmodule