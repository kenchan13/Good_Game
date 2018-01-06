`timescale 1ns / 1ps

module top(
    input clk,
    input rst, //BTNC
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
    
    wire clk_25MHz, clk_13, clk_16, clk_22, clk_25;
    clock_divider #(.n(2)) _clk_25MHz(clk, clk_25MHz);
    clock_divider #(.n(13)) _clk_13(clk, clk_13);
    clock_divider #(.n(16)) _clk_16(clk, clk_16);
    clock_divider #(.n(22)) _clk_22(clk, clk_22);
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
    reg print_0, n_print_0; // print blank or original part
    wire cmd_move = up || left || down || right;
    
    reg [63:0] game_map, n_game_map;
    /*
        63:60 59:56 55:52 51:48
        47:44 43:40 39:36 35:32
        31:28 27:24 23:20 19:16
        15:12 11:08 07:04 03:00
        */  
    
    reg [3:0] blank_pos, n_blank_pos;
    /*
        15 14 13 12
        11 10 09 08
        07 06 05 04
        03 02 01 00
        */    
    
    reg finished;
    
    always@(posedge clk_16 or posedge rst_1p)begin
        if(rst_1p)begin
            curr_state <= INIT;
            steps <= 14'd0;
            blank_pos <= 4'd0;
            game_map <= {4'd8, 4'd12, 4'd14, 4'd7, 4'd4, 4'd10, 4'd5, 4'd11, 4'd6, 4'd3, 4'd2, 4'd1, 4'd9, 4'd13, 4'd15, 4'd0};
            finished <= 1'b0;
            print_0 <= 1'b0;
        end else begin
            curr_state <= next_state;
            steps <= n_steps;
            blank_pos <= n_blank_pos;
            game_map <= n_game_map;
            finished <= (game_map=={4'd15, 4'd14, 4'd13, 4'd12, 4'd11, 4'd10, 4'd9, 4'd8, 4'd7, 4'd6, 4'd5, 4'd4, 4'd3, 4'd2, 4'd1, 4'd0});
            print_0 <= n_print_0;
        end    
    end
    
    always@(*)begin
        case(curr_state)
            INIT:begin
                next_state = RANDOM;
                n_steps = 14'd0;
                n_blank_pos = 4'd0;
                n_game_map = {4'd8, 4'd12, 4'd14, 4'd7, 4'd4, 4'd10, 4'd5, 4'd11, 4'd6, 4'd3, 4'd2, 4'd1, 4'd9, 4'd13, 4'd15, 4'd0};
                n_print_0 = 1'b0;
            end
            RANDOM:begin
                if(start) next_state = PLAY;
                else next_state = RANDOM;
                n_steps = 14'd0;
                n_blank_pos = 4'd0;
                n_game_map = {game_map[59:4], game_map[63:60], game_map[3:0]};
                n_print_0 = 1'b0;
            end
            PLAY:begin
                if(cmd_move) next_state = MOVE;
                else next_state = PLAY;
                n_steps = steps;
                n_blank_pos = blank_pos;
                n_game_map = game_map;
                n_print_0 = 1'b0;
            end
            MOVE:begin
                if(last_change==W_CODES)begin // UP
                    if(blank_pos==4'd3 || blank_pos==4'd2 || blank_pos==4'd1 || blank_pos==4'd0)begin // 3 2 1 0 are invalid for moving upward
                        next_state = PLAY;
                        n_steps = steps;
                        n_blank_pos = blank_pos;
                        n_game_map = game_map;
                        n_print_0 = 1'b0;
                    end else begin
                        next_state = CHECK;
                        n_steps = steps;
                        n_blank_pos = blank_pos - 4'd4;
                        case(blank_pos) // {unchanged(0~44), swapped(4), unchanged(12), swapped(4), unchanged(44~0)}
                            4'd15: n_game_map = {                 game_map[47:44], game_map[59:48], game_map[63:60], game_map[43:0]};
                            4'd14: n_game_map = {game_map[63:60], game_map[43:40], game_map[55:44], game_map[59:56], game_map[39:0]};
                            4'd13: n_game_map = {game_map[63:56], game_map[39:36], game_map[51:40], game_map[55:52], game_map[35:0]};
                            4'd12: n_game_map = {game_map[63:52], game_map[35:32], game_map[47:36], game_map[51:48], game_map[31:0]};
                            4'd11: n_game_map = {game_map[63:48], game_map[31:28], game_map[43:32], game_map[47:44], game_map[27:0]};
                            4'd10: n_game_map = {game_map[63:44], game_map[27:24], game_map[39:28], game_map[43:40], game_map[23:0]};
                            4'd9:  n_game_map = {game_map[63:40], game_map[23:20], game_map[35:24], game_map[39:36], game_map[19:0]};
                            4'd8:  n_game_map = {game_map[63:36], game_map[19:16], game_map[31:20], game_map[35:32], game_map[15:0]};
                            4'd7:  n_game_map = {game_map[63:32], game_map[15:12], game_map[27:16], game_map[31:28], game_map[11:0]};
                            4'd6:  n_game_map = {game_map[63:28], game_map[11:8] , game_map[23:12], game_map[27:24], game_map[7:0] };
                            4'd5:  n_game_map = {game_map[63:24], game_map[7:4]  , game_map[19:8] , game_map[23:20], game_map[3:0] };
                            4'd4:  n_game_map = {game_map[63:20], game_map[3:0]  , game_map[15:4] , game_map[19:16]                };
                            default: n_game_map = game_map;
                        endcase
                        n_print_0 = 1'b0;
                    end
                end else if(last_change==A_CODES)begin // LEFT
                    if(blank_pos==4'd12 || blank_pos==4'd8 || blank_pos==4'd4 || blank_pos==4'd0)begin
                        next_state = PLAY;
                        n_steps = steps;
                        n_blank_pos = blank_pos;
                        n_game_map = game_map;
                        n_print_0 = 1'b0;
                    end else begin
                        next_state = CHECK;
                        n_steps = steps;
                        n_blank_pos = blank_pos - 4'd1;
                        case(blank_pos) // {unchanged(0~56), swapped(4), swapped(4), unchanged(56~0)}
                            4'd15: n_game_map = {                 game_map[59:56], game_map[63:60], game_map[55:0]};
                            4'd14: n_game_map = {game_map[63:60], game_map[55:52], game_map[59:56], game_map[51:0]};
                            4'd13: n_game_map = {game_map[63:56], game_map[51:48], game_map[55:52], game_map[47:0]};
                            
                            4'd11: n_game_map = {game_map[63:48], game_map[43:40], game_map[47:44], game_map[39:0]};
                            4'd10: n_game_map = {game_map[63:44], game_map[39:36], game_map[43:40], game_map[35:0]};
                            4'd9:  n_game_map = {game_map[63:40], game_map[35:32], game_map[39:36], game_map[31:0]};
                            
                            4'd7:  n_game_map = {game_map[63:32], game_map[27:24], game_map[31:28], game_map[23:0]};
                            4'd6:  n_game_map = {game_map[63:28], game_map[23:20], game_map[27:24], game_map[19:0]};
                            4'd5:  n_game_map = {game_map[63:24], game_map[19:16], game_map[23:20], game_map[15:0]};
                            
                            4'd3:  n_game_map = {game_map[63:16], game_map[11:8] , game_map[15:12], game_map[7:0] };
                            4'd2:  n_game_map = {game_map[63:12], game_map[7:4]  , game_map[11:8] , game_map[3:0] };
                            4'd1:  n_game_map = {game_map[63:8] , game_map[3:0]  , game_map[7:4]                  };
                            default: n_game_map = game_map;
                        endcase
                        n_print_0 = 1'b0;
                    end 
                end else if(last_change==S_CODES)begin // DOWN
                    if(blank_pos==4'd15 || blank_pos==4'd14 || blank_pos==4'd13 || blank_pos==4'd12)begin
                        next_state = PLAY;
                        n_steps = steps;
                        n_blank_pos = blank_pos;
                        n_game_map = game_map;
                        n_print_0 = 1'b0;
                    end else begin
                        next_state = CHECK;
                        n_steps = steps;
                        n_blank_pos = blank_pos + 4'd4;
                        case(blank_pos) // {unchanged(0~44), swapped(4), unchanged(12), swapped(4), unchanged(44~0)}
                            4'd11: n_game_map = {                 game_map[47:44], game_map[59:48], game_map[63:60], game_map[43:0]};
                            4'd10: n_game_map = {game_map[63:60], game_map[43:40], game_map[55:44], game_map[59:56], game_map[39:0]};
                            4'd9:  n_game_map = {game_map[63:56], game_map[39:36], game_map[51:40], game_map[55:52], game_map[35:0]};
                            4'd8:  n_game_map = {game_map[63:52], game_map[35:32], game_map[47:36], game_map[51:48], game_map[31:0]};
                            4'd7:  n_game_map = {game_map[63:48], game_map[31:28], game_map[43:32], game_map[47:44], game_map[27:0]};
                            4'd6:  n_game_map = {game_map[63:44], game_map[27:24], game_map[39:28], game_map[43:40], game_map[23:0]};
                            4'd5:  n_game_map = {game_map[63:40], game_map[23:20], game_map[35:24], game_map[39:36], game_map[19:0]};
                            4'd4:  n_game_map = {game_map[63:36], game_map[19:16], game_map[31:20], game_map[35:32], game_map[15:0]};
                            4'd3:  n_game_map = {game_map[63:32], game_map[15:12], game_map[27:16], game_map[31:28], game_map[11:0]};
                            4'd2:  n_game_map = {game_map[63:28], game_map[11:8] , game_map[23:12], game_map[27:24], game_map[7:0] };
                            4'd1:  n_game_map = {game_map[63:24], game_map[7:4]  , game_map[19:8] , game_map[23:20], game_map[3:0] };
                            4'd0:  n_game_map = {game_map[63:20], game_map[3:0]  , game_map[15:4] , game_map[19:16]                };
                            default: n_game_map = game_map;
                        endcase
                        n_print_0 = 1'b0;
                    end
                end else if(last_change==D_CODES)begin // RIGHT
                    if(blank_pos==4'd15 || blank_pos==4'd11 || blank_pos==4'd7 || blank_pos==4'd3)begin
                        next_state = PLAY;
                        n_steps = steps;
                        n_blank_pos = blank_pos;
                        n_game_map = game_map;
                        n_print_0 = 1'b0;
                    end else begin
                        next_state = CHECK;
                        n_steps = steps;
                        n_blank_pos = blank_pos + 4'd1;
                        case(blank_pos) // {unchanged(0~56), swapped(4), swapped(4), unchanged(56~0)}
                            4'd14: n_game_map = {                 game_map[59:56], game_map[63:60], game_map[55:0]};
                            4'd13: n_game_map = {game_map[63:60], game_map[55:52], game_map[59:56], game_map[51:0]};
                            4'd12: n_game_map = {game_map[63:56], game_map[51:48], game_map[55:52], game_map[47:0]};
                            
                            4'd10: n_game_map = {game_map[63:48], game_map[43:40], game_map[47:44], game_map[39:0]};
                            4'd9:  n_game_map = {game_map[63:44], game_map[39:36], game_map[43:40], game_map[35:0]};
                            4'd8:  n_game_map = {game_map[63:40], game_map[35:32], game_map[39:36], game_map[31:0]};
                            
                            4'd6:  n_game_map = {game_map[63:32], game_map[27:24], game_map[31:28], game_map[23:0]};
                            4'd5:  n_game_map = {game_map[63:28], game_map[23:20], game_map[27:24], game_map[19:0]};
                            4'd4:  n_game_map = {game_map[63:24], game_map[19:16], game_map[23:20], game_map[15:0]};
                            
                            4'd2:  n_game_map = {game_map[63:16], game_map[11:8] , game_map[15:12], game_map[7:0] };
                            4'd1:  n_game_map = {game_map[63:12], game_map[7:4]  , game_map[11:8] , game_map[3:0] };
                            4'd0:  n_game_map = {game_map[63:8] , game_map[3:0]  , game_map[7:4]                  };
                            default: n_game_map = game_map;
                        endcase
                        n_print_0 = 1'b0;
                    end              
                end else begin
                    next_state = PLAY;
                    n_steps = steps;
                    n_blank_pos = blank_pos;
                    n_game_map = game_map;  
                    n_print_0 = 1'b0;     
                end
            end
            CHECK:begin // check if player win
                if(finished)begin
                    next_state = WIN;
                    n_print_0 = 1'b1;
                end else begin
                    next_state = PLAY;
                    n_print_0 = 1'b0;
                end
                if(steps<14'd9999) n_steps = steps + 14'd1;
                else n_steps = 14'd0; // Who would play over 10000 moves tho
                n_blank_pos = blank_pos;
                n_game_map = game_map;
            end
            WIN:begin
                next_state = WIN;
                n_steps = steps;
                n_blank_pos = blank_pos;
                n_game_map = {4'd15, 4'd14, 4'd13, 4'd12, 4'd11, 4'd10, 4'd9, 4'd8, 4'd7, 4'd6, 4'd5, 4'd4, 4'd3, 4'd2, 4'd1, 4'd0};
                n_print_0 = 1'b1;
            end
            default:begin
                next_state = INIT;
                n_steps = 14'd0;
                n_blank_pos = 4'd0;
                n_game_map = game_map;
                n_print_0 = 1'b0;
            end
        endcase
    end
    
    VGAsetup _setup(clk, rst, game_map, finished, hsync, vsync, vgaRed, vgaGreen, vgaBlue);
    
    wire [3:0] s1000 = (steps / 1000) % 10;
    wire [3:0] s100 = (steps / 100) % 10;
    wire [3:0] s10 = (steps / 10) % 10;
    wire [3:0] s1 = steps % 10;
    wire [15:0] nums = {s1000, s100, s10, s1};
    SevenSegment _display(DISPLAY, DIGIT, nums, rst_1p, clk);
endmodule
