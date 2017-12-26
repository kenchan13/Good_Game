`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.10.2017 00:10:37
// Design Name: 
// Module Name: debouncer
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


module debouncer(pb, clk, pb_debounced);
    input pb, clk;
    output pb_debounced;
    reg [3:0] shift_reg;
    always@(posedge clk) shift_reg[3:0] <= {shift_reg[2:0], pb};
    assign pb_debounced = shift_reg==4'b1111 ? 1'b1 : 1'b0;
endmodule
