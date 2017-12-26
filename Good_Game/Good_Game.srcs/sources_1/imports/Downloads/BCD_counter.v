`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.10.2017 00:16:01
// Design Name: 
// Module Name: BCD_counter
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


module BCD_counter(clk, reset, en, dir, BCD, cout);
    input clk, reset, en, dir;
    output [3:0] BCD;
    output cout;
    wire [3:0] inputs, outputs;
    counter _count(inputs, en, dir, outputs, cout);
    DFF is_reset(clk, reset, outputs, inputs);
    assign BCD = inputs;
endmodule

module DFF(clk, reset, BCD_in, BCD_out);
    input clk, reset;
    input [3:0] BCD_in;
    output reg [3:0] BCD_out;
    always@(negedge clk or posedge reset)begin //posedge reset added for asynchronous control signal
        if(reset) BCD_out = 4'b0000;
        else BCD_out = BCD_in;    
    end
endmodule

module counter(inputs, en, dir, outputs, cout);
    input [3:0] inputs;
    input en, dir;
    output reg [3:0] outputs;
    output reg cout;
    wire [1:0] to_do = {en, dir};
    always@(*)begin
        case(to_do)
            2'b00, 2'b01:begin //Do nothing
                outputs = inputs;
                cout = 1'b0;
            end
            2'b10:begin //Sub
                outputs = (inputs==4'b0000) ? 4'b1001 : (inputs>4'b0000 && inputs<4'b1010) ? (inputs - 4'b0001) : 4'b0000;
                cout = (inputs==4'b0000) ? 1'b1 : 1'b0;
            end
            2'b11:begin //Add
                outputs = (inputs<4'b1001) ? (inputs + 4'b0001) : 4'b0000;
                cout = (inputs==4'b1001) ? 1'b1 : 1'b0;
            end
        endcase
    end
endmodule