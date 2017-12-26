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
    parameter MOVE = 6'b001000;
    parameter CHECK = 6'b010000;
    parameter WIN = 6'b100000;
    
    parameter [8:0] W_CODES = 9'h1D;
    parameter [8:0] A_CODES = 9'h1C;
    parameter [8:0] S_CODES = 9'h1B;
    parameter [8:0] D_CODES = 9'h23;
    parameter [8:0] ENTER_CODES = 9'h5A;
    
    wire clk_13, clk_16, clk_25;
    clock_divider #(.n(13)) _clk_13(clk, clk_13);
    clock_divider #(.n(16)) _clk_16(clk, clk_16);
    clock_divider #(.n(25)) _clk_25(clk, clk_25);
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
    
    reg [59:0] gamepad, n_gamepad;
    reg [3:0] blank, n_blank;
    
    //reg [15:0] FSM_sim, nFSM_sim;
    
    always@(posedge clk_16 or posedge rst_1p)begin
        if(rst_1p)begin
            curr_state <= INIT;
            steps <= 14'd0;
            blank <= 4'd15;
            gamepad <= {4'd8, 4'd4, 4'd2, 4'd9, 4'd12, 4'd6, 4'd11, 4'd5, 4'd10, 4'd13, 4'd14, 4'd15, 4'd7, 4'd3, 4'd1, 4'd0};
            //FSM_sim <= 16'd0;
        end else begin
            curr_state <= next_state;
            steps <= n_steps;
            blank <= n_blank;
            gamepad <= n_gamepad;
            //FSM_sim <= nFSM_sim;
        end    
    end
    
    always@(*)begin
        case(curr_state)
            INIT:begin
                next_state = RANDOM;
                n_steps = 14'd0;
                n_blank = blank;
                n_gamepad = gamepad;
                //nFSM_sim = 16'd0;
            end
            RANDOM:begin
                if(start) next_state = PLAY;
                else next_state = RANDOM;
                n_steps = 14'd0;
                n_blank = blank;
                n_gamepad = {gamepad[55:4], gamepad[59:56], gamepad[3:0]};
                //nFSM_sim = 16'd1;
            end
            PLAY:begin
                if(cmd_move) next_state = MOVE;
                else next_state = PLAY;
                n_steps = steps;
                n_blank = blank;
                n_gamepad = gamepad;
                //nFSM_sim = 16'd2;
            end
            MOVE:begin
                if(last_change==W_CODES)begin // UP
                    if(blank==4'd12 || blank==4'd13 || blank==4'd14 || blank==4'd15)begin // 12 13 14 15 are invalid for moving upward
                        next_state = PLAY;
                        n_steps = steps;
                        n_blank = blank;
                        n_gamepad = gamepad;
                    end else begin
                        next_state = CHECK;
                        n_steps = steps;
                        n_blank = blank - 4'd4;
                        n_gamepad[59-blank*4'd4 -: 4] = gamepad[59-(blank+4'd4)*4'd4 -: 4]; // shard moved upward
                        n_gamepad[59-(blank+4'd4)*4'd4 -: 4] = gamepad[59-blank*4'd4 -: 4]; // blank move downward
                        //latch
                    end
                end else if(last_change==A_CODES)begin // LEFT
                    if(blank==4'd3 || blank==4'd7 || blank==4'd11 || blank==4'd15)begin // 3 7 11 15
                        next_state = PLAY;
                        n_steps = steps;
                        n_blank = blank;
                        n_gamepad = gamepad;
                    end else begin
                        next_state = CHECK;
                        n_steps = steps;
                        n_blank = blank - 4'd1;
                        n_gamepad = gamepad;
                    end 
                end else if(last_change==S_CODES)begin // DOWN
                    if(blank==4'd0 || blank==4'd1 || blank==4'd2 || blank==4'd3)begin
                        next_state = PLAY;
                        n_steps = steps;
                        n_blank = blank;
                        n_gamepad = gamepad;
                    end else begin
                        next_state = CHECK;
                        n_steps = steps;
                        n_blank = blank + 4'd4;
                        n_gamepad = gamepad;
                    end
                end else if(last_change==D_CODES)begin // RIGHT
                    if(blank==4'd0 || blank==4'd4 || blank==4'd8 || blank==4'd12)begin
                        next_state = PLAY;
                        n_steps = steps;
                        n_blank = blank;
                        n_gamepad = gamepad;
                    end else begin
                        next_state = CHECK;
                        n_steps = steps;
                        n_blank = blank + 4'd1;
                        n_gamepad = gamepad;
                    end              
                end else begin
                    next_state = PLAY;
                    n_steps = steps;
                    n_blank = blank;
                    n_gamepad = gamepad;           
                end
                //nFSM_sim = 16'd3;
            end
            CHECK:begin // check if player win
                next_state = PLAY;
                if(steps<14'd9999) n_steps = steps + 14'd1;
                else n_steps = 14'd0; // Who would play over 10000 moves tho
                n_blank = blank;
                n_gamepad = gamepad;
                //nFSM_sim = 16'd4;
            end
            WIN:begin
                
            
            end
            default:begin
                next_state = INIT;
                n_steps = 14'd0;
                n_blank = 16'b0000_0000_0000_0001;
                n_gamepad = gamepad;
                //nFSM_sim = 16'd0;
            end
        endcase
    end
    
    wire [3:0] s1000 = (steps / 1000) % 10;
    wire [3:0] s100 = (steps / 100) % 10;
    wire [3:0] s10 = (steps / 10) % 10;
    wire [3:0] s1 = steps % 10;
    wire [15:0] nums = {s1000, s100, s10, s1};
    SevenSegment _display(DISPLAY, DIGIT, nums, rst_1p, clk_16);
    //SevenSegment _test(DISPLAY, DIGIT, FSM_sim, rst_1p, clk);
    
endmodule
