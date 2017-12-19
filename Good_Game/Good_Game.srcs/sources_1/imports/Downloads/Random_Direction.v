`timescale 1ns / 1ps

module Random_Direction(dir, clk, rst);
    input rst, clk;
    output wire [1:0] dir;
    wire [3:0] random;
    LFSR LFSR1(random, clk, rst);
    
    assign dir = random % 4;
    
endmodule
