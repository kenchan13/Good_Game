`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.10.2017 23:36:15
// Design Name: 
// Module Name: clock_divider
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clock_divider(clk, clk_div);
    parameter n = 25;
    input clk;
    output clk_div;
    reg [n-1:0] curr_num;
    wire [n-1:0] next_num; 
    assign next_num = curr_num + 1;
    assign clk_div = curr_num[n-1];    
    always@(posedge clk) curr_num <= next_num;  
endmodule
