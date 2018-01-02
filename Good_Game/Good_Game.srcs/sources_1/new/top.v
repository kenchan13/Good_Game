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
    clock_divider #(.n(1)) _clk_25MHz(clk, clk_25MHz);
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
    // VGA part
    wire [11:0] data_0_origin, data_0_blank, data_1, data_2, data_3, data_4, data_5, data_6, data_7, data_8, data_9, data_10, data_11, data_12, data_13, data_14, data_15;
    wire [16:0] pixel_addr_0_origin, pixel_addr_0_blank, pixel_addr_1, pixel_addr_2, pixel_addr_3, pixel_addr_4, pixel_addr_5, pixel_addr_6, pixel_addr_7, pixel_addr_8;
    wire [16:0] pixel_addr_9, pixel_addr_10, pixel_addr_11, pixel_addr_12, pixel_addr_13, pixel_addr_14, pixel_addr_15;
    wire [11:0] pixel_0_origin, pixel_0_blank, pixel_1, pixel_2, pixel_3, pixel_4, pixel_5, pixel_6, pixel_7, pixel_8, pixel_9, pixel_10, pixel_11, pixel_12, pixel_13, pixel_14, pixel_15;
    wire valid;
    wire [9:0] h_cnt; //300
    wire [9:0] v_cnt; //300
    reg [11:0] vga_RGB, n_vga_RGB;
    assign {vgaRed, vgaGreen, vgaBlue} = valid ? vga_RGB : 12'h0;
    blk_mem_gen_0_origin blk_mem_gen_0_origin_inst(.clka(clk_25MHz), .wea(0), .addra(pixel_addr_0_origin), .dina(data_0_origin[11:0]), .douta(pixel_0_origin)); 
    blk_mem_gen_0_blank blk_mem_gen_0_blank_inst(.clka(clk_25MHz), .wea(0), .addra(pixel_addr_0_blank), .dina(data_0_blank[11:0]), .douta(pixel_0_blank));
    blk_mem_gen_1 blk_mem_gen_1_inst(.clka(clk_25MHz), .wea(0), .addra(pixel_addr_1), .dina(data_1[11:0]), .douta(pixel_1));
    blk_mem_gen_2 blk_mem_gen_2_inst(.clka(clk_25MHz), .wea(0), .addra(pixel_addr_2), .dina(data_2[11:0]), .douta(pixel_2));
    blk_mem_gen_3 blk_mem_gen_3_inst(.clka(clk_25MHz), .wea(0), .addra(pixel_addr_3), .dina(data_3[11:0]), .douta(pixel_3));
    blk_mem_gen_4 blk_mem_gen_4_inst(.clka(clk_25MHz), .wea(0), .addra(pixel_addr_4), .dina(data_4[11:0]), .douta(pixel_4));
    blk_mem_gen_5 blk_mem_gen_5_inst(.clka(clk_25MHz), .wea(0), .addra(pixel_addr_5), .dina(data_5[11:0]), .douta(pixel_5));
    blk_mem_gen_6 blk_mem_gen_6_inst(.clka(clk_25MHz), .wea(0), .addra(pixel_addr_6), .dina(data_6[11:0]), .douta(pixel_6));
    blk_mem_gen_7 blk_mem_gen_7_inst(.clka(clk_25MHz), .wea(0), .addra(pixel_addr_7), .dina(data_7[11:0]), .douta(pixel_7));
    blk_mem_gen_8 blk_mem_gen_8_inst(.clka(clk_25MHz), .wea(0), .addra(pixel_addr_8), .dina(data_8[11:0]), .douta(pixel_8));
    blk_mem_gen_9 blk_mem_gen_9_inst(.clka(clk_25MHz), .wea(0), .addra(pixel_addr_9), .dina(data_9[11:0]), .douta(pixel_9));
    blk_mem_gen_10 blk_mem_gen_10_inst(.clka(clk_25MHz), .wea(0), .addra(pixel_addr_10), .dina(data_10[11:0]), .douta(pixel_10));
    blk_mem_gen_11 blk_mem_gen_11_inst(.clka(clk_25MHz), .wea(0), .addra(pixel_addr_11), .dina(data_11[11:0]), .douta(pixel_11));
    blk_mem_gen_12 blk_mem_gen_12_inst(.clka(clk_25MHz), .wea(0), .addra(pixel_addr_12), .dina(data_12[11:0]), .douta(pixel_12));
    blk_mem_gen_13 blk_mem_gen_13_inst(.clka(clk_25MHz), .wea(0), .addra(pixel_addr_13), .dina(data_13[11:0]), .douta(pixel_13));
    blk_mem_gen_14 blk_mem_gen_14_inst(.clka(clk_25MHz), .wea(0), .addra(pixel_addr_14), .dina(data_14[11:0]), .douta(pixel_14));
    blk_mem_gen_15 blk_mem_gen_15_inst(.clka(clk_25MHz), .wea(0), .addra(pixel_addr_15), .dina(data_15[11:0]), .douta(pixel_15));
    vga_controller vga_inst(.pclk(clk_25MHz), .reset(rst_1p), .hsync(hsync), .vsync(vsync), .valid(valid), .h_cnt(h_cnt), .v_cnt(v_cnt));
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
                n_blank_pos = blank_pos;
                n_game_map = game_map;
                n_print_0 = 1'b0;
            end
            RANDOM:begin
                if(start) next_state = PLAY;
                else next_state = RANDOM;
                n_steps = 14'd0;
                n_blank_pos = blank_pos;
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
                            4'd6:  n_game_map = {game_map[63:28], game_map[11:8] , game_map[23:15], game_map[27:24], game_map[7:0] };
                            4'd5:  n_game_map = {game_map[63:24], game_map[7:4]  , game_map[19:8] , game_map[23:20], game_map[3:0] };
                            4'd4:  n_game_map = {game_map[63:20], game_map[3:0]  , game_map[15:4] , game_map[19:16]                };
                            default: n_game_map = game_map;
                        endcase
                        n_print_0 = 1'b0;
                    end
                end else if(last_change==A_CODES)begin // LEFT
                    if(blank_pos==4'd12 || blank_pos==4'd8 || blank_pos==4'd4 || blank_pos==4'd0)begin // 3 7 11 15
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
                            4'd11: n_game_map = {                 game_map[47:43], game_map[59:48], game_map[63:60], game_map[43:0]};
                            4'd10: n_game_map = {game_map[63:60], game_map[43:40], game_map[55:44], game_map[59:56], game_map[39:0]};
                            4'd9:  n_game_map = {game_map[63:56], game_map[39:36], game_map[51:40], game_map[55:52], game_map[35:0]};
                            4'd8:  n_game_map = {game_map[63:52], game_map[35:32], game_map[47:36], game_map[51:48], game_map[31:0]};
                            4'd7:  n_game_map = {game_map[63:48], game_map[31:28], game_map[43:32], game_map[47:44], game_map[27:0]};
                            4'd6:  n_game_map = {game_map[63:44], game_map[27:24], game_map[39:28], game_map[43:40], game_map[23:0]};
                            4'd5:  n_game_map = {game_map[63:40], game_map[23:20], game_map[35:24], game_map[39:36], game_map[19:0]};
                            4'd4:  n_game_map = {game_map[63:36], game_map[19:16], game_map[31:20], game_map[35:32], game_map[15:0]};
                            4'd3:  n_game_map = {game_map[63:32], game_map[15:12], game_map[27:16], game_map[31:28], game_map[11:0]};
                            4'd2:  n_game_map = {game_map[63:28], game_map[11:8] , game_map[23:15], game_map[27:24], game_map[7:0] };
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
                n_game_map = game_map;
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
        ////////////////////////////////////////////////////////////////
        case(curr_part)
            4'd0: vga_RGB = print_0 ? pixel_0_origin : pixel_0_blank;
            4'd1: vga_RGB = pixel_1;
            4'd2: vga_RGB = pixel_2;
            4'd3: vga_RGB = pixel_3;
            4'd4: vga_RGB = pixel_4;
            4'd5: vga_RGB = pixel_5;
            4'd6: vga_RGB = pixel_6;
            4'd7: vga_RGB = pixel_7;
            4'd8: vga_RGB = pixel_8;
            4'd9: vga_RGB = pixel_9;
            4'd10: vga_RGB = pixel_10;
            4'd11: vga_RGB = pixel_11;
            4'd12: vga_RGB = pixel_12;
            4'd13: vga_RGB = pixel_13;
            4'd14: vga_RGB = pixel_14;
            4'd15: vga_RGB = pixel_15;
            default: vga_RGB = 12'h0;
        endcase
    end
    
    wire [3:0] s1000 = (steps / 1000) % 10;
    wire [3:0] s100 = (steps / 100) % 10;
    wire [3:0] s10 = (steps / 10) % 10;
    wire [3:0] s1 = steps % 10;
    wire [15:0] nums = {s1000, s100, s10, s1};
    SevenSegment _display(DISPLAY, DIGIT, nums, rst_1p, clk_16);
endmodule
