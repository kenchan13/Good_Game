`timescale 1ns / 1ps

module hv_cnt_find_block(
    input [9:0] h_cnt,
    input [9:0] v_cnt,
    output reg [4:0] curr_block
    );
    
    // Set 20 as out-of-range
    
    always@(*)begin
        if(h_cnt < 80 || h_cnt >= 560) curr_block = 5'd20;
        else if(80 <= h_cnt && h_cnt < 200)begin
            if(0 <= v_cnt && v_cnt < 120) curr_block = 5'd15;
            else if(120 <= v_cnt && v_cnt < 240) curr_block = 5'd11;
            else if(240 <= v_cnt && v_cnt < 360) curr_block = 5'd7;
            else if(360 <= v_cnt && v_cnt < 480) curr_block = 5'd3;
            else curr_block = 5'd20;
        end else if(200 <= h_cnt && h_cnt < 320)begin
            if(0 <= v_cnt && v_cnt < 120) curr_block = 5'd14;
            else if(120 <= v_cnt && v_cnt < 240) curr_block = 5'd10;
            else if(240 <= v_cnt && v_cnt < 360) curr_block = 5'd6;
            else if(360 <= v_cnt && v_cnt < 480) curr_block = 5'd2;
            else curr_block = 5'd20;
        end else if(320 <= h_cnt && h_cnt < 440)begin
            if(0 <= v_cnt && v_cnt < 120) curr_block = 5'd13;
            else if(120 <= v_cnt && v_cnt < 240) curr_block = 5'd9;
            else if(240 <= v_cnt && v_cnt < 360) curr_block = 5'd5;
            else if(360 <= v_cnt && v_cnt < 480) curr_block = 5'd1;
        else curr_block = 5'd20;
        end else if(440 <= h_cnt && h_cnt < 560)begin
            if(0 <= v_cnt && v_cnt < 120) curr_block = 5'd12;
            else if(120 <= v_cnt && v_cnt < 240) curr_block = 5'd8;
            else if(240 <= v_cnt && v_cnt < 360) curr_block = 5'd4;
            else if(360 <= v_cnt && v_cnt < 480) curr_block = 5'd0;
            else curr_block = 5'd20;
        end else curr_block = 5'd20;
    end
endmodule
