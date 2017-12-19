`timescale 1ns / 1ps

module top(
    input clk,
    input rst, //BTNC
    input difficulty, //sw[0]
    inout PS2_CLK,
    inout PS2_DATA,
    output [3:0] DIGIT,
    output [6:0] DISPLAY,
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue,
    output hsync,
    output vsync
    );
    parameter INIT = 6'b000001;
    parameter IDLE = 6'b000010;
    parameter CHECK = 6'b000100;
    parameter MOVE = 6'b001000;
    parameter WIN = 6'b010000;
    parameter TRAP = 6'b100000;
    
    parameter [8:0] W_CODES = 9'h1D;
    parameter [8:0] A_CODES = 9'h1C;
    parameter [8:0] S_CODES = 9'h1B;
    parameter [8:0] D_CODES = 9'h23;
    
    wire clk_16, clk_25;
    clock_divider #(16) _clk_16(clk, clk_16);
    clock_divider #(25) _clk_25(clk, clk_25);
    wire rst_db;
    debouncer _rst_db(rst, clk_16, rst_db);
    wire rst_1p;
    OnePulse _rst_1p(rst_1p, rst_db, clk_16);
    
    wire [511:0] key_down;
    wire [8:0] last_change;
    wire been_ready;
    KeyboardDecoder key_de(key_down, last_change, been_ready, PS2_DATA, PS2_CLK, rst, clk);
    wire up, left, down, right;
    OnePulse _up(up, key_down[W_CODES], clk_16);
    OnePulse _left(left, key_down[A_CODES], clk_16);
    OnePulse _down(down, key_down[S_CODES], clk_16);
    OnePulse _right(right, key_down[D_CODES], clk_16);
    ////////////////////////////////////////////////////////////////
    
    reg [5:0] curr_state, next_state;
    reg [13:0] steps, n_steps;
    wire cmd_move = up || left || down || right;
    
    always@(posedge clk_16 or posedge rst_1p)begin
        if(rst_1p)begin
            curr_state <= IDLE;
            steps <= 14'd0;
        end else begin
            curr_state <= next_state;
            steps <= n_steps;
        end    
    end
    
    always@(*)begin
        case(curr_state)
            INIT:begin
        
        
            end
            IDLE:begin
                if(cmd_move) next_state = CHECK;
                else next_state = IDLE;
                n_steps = steps;
            end
            CHECK:begin
                
            
            end
            MOVE:begin
            
            end
            WIN:begin
            
            
            end
            TRAP:begin
            
            
            end
            default:begin
                next_state = INIT;
                n_steps = 14'd0;
            end
        endcase
    end
    
    SevenSegment _display(DISPLAY, DIGIT,,rst_1p, clk_16);
        /*output reg [6:0] display,
        output reg [3:0] digit,
        input wire [15:0] nums,
        input wire rst,
        input wire clk*/
    
endmodule
