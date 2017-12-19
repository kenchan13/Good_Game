`timescale 1ns / 1ps

module Dir_simulation;
    reg clk;
    reg rst;
    wire [1:0] random;
    
    initial begin
        clk = 0;
        rst = 0;
        #10 rst = 1;
        #10 rst = 0;
    end
    
    always begin
        #5 clk = ~clk;
    end
    
    Random_Direction sim_Dir(random, clk, rst);
    
endmodule
