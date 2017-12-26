`timescale 1ns / 1ps

module top(
    input clk,
    input rst, //BTNC
    //input difficulty, //sw[0]
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
    parameter RANDOM = 6'b000010;
    parameter PLAY = 6'b000100;
    parameter CHECK = 6'b001000;
    parameter MOVE = 6'b010000;
    parameter WIN = 6'b100000;
    
    parameter [8:0] W_CODES = 9'h1D;
    parameter [8:0] A_CODES = 9'h1C;
    parameter [8:0] S_CODES = 9'h1B;
    parameter [8:0] D_CODES = 9'h23;
    parameter [8:0] ENTER_CODES = 9'h5A;
    
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
    wire up, left, down, right, start;
    OnePulse _up(up, key_down[W_CODES], clk_16);
    OnePulse _left(left, key_down[A_CODES], clk_16);
    OnePulse _down(down, key_down[S_CODES], clk_16);
    OnePulse _right(right, key_down[D_CODES], clk_16);
    OnePulse _start(start, key_down[ENTER_CODES], clk_16);
    ////////////////////////////////////////////////////////////////
    
    reg [5:0] curr_state, next_state;
    reg [13:0] steps, n_steps;
    wire cmd_move = up || left || down || right;
    
    reg [15:0] blank, n_blank;
    reg valid, n_valid;
    
    always@(posedge clk_16 or posedge rst_1p)begin
        if(rst_1p)begin
            curr_state <= INIT;
            steps <= 14'd0;
            blank <= 16'b1000_0000_0000_0000;
            valid <= 1'b1;
        end else begin
            curr_state <= next_state;
            steps <= n_steps;
            blank <= n_blank;
            valid <= n_valid;
        end    
    end
    
    always@(*)begin
        case(curr_state)
            INIT:begin
                next_state = RANDOM;
                n_steps = 14'd0;
                n_blank = blank;
                n_valid = 1'b0;
            end
            RANDOM:begin
                if(start) next_state = PLAY;
                else next_state = RANDOM;
                n_steps = 14'd0;
                n_blank = blank;
                n_valid = 1'b0;
            end
            PLAY:begin
                if(cmd_move) next_state = CHECK;
                else next_state = PLAY;
                n_steps = steps;
                n_blank = blank;
                n_valid = 1'b0;
            end
            CHECK:begin
                if(last_change==W_CODES)begin // UP
                    if(blank[0] || blank[1] || blank[2] || blank[3])begin 
                        next_state = PLAY;
                        n_steps = steps;
                        n_blank = blank;
                        n_valid = 1'b0;
                    end else begin
                        next_state = MOVE;
                        n_steps = steps;
                        n_blank = {4'b0000, blank[15:4]};
                        n_valid = 1'b1;
                    end
                end else if(last_change==A_CODES)begin // LEFT
                    if(blank[0] || blank[4] || blank[8] || blank[12])begin
                        next_state = PLAY;
                        n_steps = steps;
                        n_blank = blank;
                        n_valid = 1'b0;
                    end else begin
                        next_state = MOVE;
                        n_steps = steps;
                        n_blank = blank >> 1;
                        n_valid = 1'b1;
                    end 
                end else if(last_change==S_CODES)begin // DOWN
                    if(blank[12] || blank[13] || blank[14] || blank[15])begin
                        next_state = PLAY;
                        n_steps = steps;
                        n_blank = {blank[11:0], 4'b0000};
                        n_valid = 1'b0;
                    end else begin
                        next_state = MOVE;
                        n_steps = steps;
                        n_blank = blank;
                        n_valid = 1'b1;
                    end
                end else if(last_change==D_CODES)begin // RIGHT
                    if(blank[3] || blank[7] || blank[11] || blank[15])begin
                        next_state = PLAY;
                        n_steps = steps;
                        n_blank = blank;
                        n_valid = 1'b0;
                    end else begin
                        next_state = MOVE;
                        n_steps = steps;
                        n_blank = blank << 1;
                        n_valid = 1'b1;
                    end              
                end else begin
                    next_state = PLAY;
                    n_steps = steps;
                    n_blank = blank;
                    n_valid = 1'b0;              
                end
            end
            MOVE:begin
                next_state = PLAY;
                if(steps<14'd9999) n_steps = steps + 14'd1;
                else n_steps = 14'd0; // Who would play over 10000 moves tho
                n_blank = blank;
                n_valid = 1'b0;
            end
            WIN:begin
                
            
            end
            default:begin
                next_state = INIT;
                n_steps = 14'd0;
                n_blank = 16'b1000_0000_0000_0000;
            end
        endcase
    end
    
    wire s1000 = (steps / 1000) % 10;
    wire s100 = (steps / 100) % 10;
    wire s10 = (steps / 10) % 10;
    wire s1 = steps % 10;
    SevenSegment _display(DISPLAY, DIGIT,,rst_1p, clk_16);
        /*output reg [6:0] display,
        output reg [3:0] digit,
        input wire [15:0] nums,
        input wire rst,
        input wire clk*/
    
endmodule
