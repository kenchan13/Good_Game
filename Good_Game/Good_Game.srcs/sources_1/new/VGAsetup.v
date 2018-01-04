`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module VGAsetup(
    input clk,
    input rst,
    //input [63:0] game_map,
    output hsync,
    output vsync,
    output reg [3:0] vgaRed,
    output reg [3:0] vgaGreen,
    output reg [3:0] vgaBlue
    );
    
    wire clk_25MHz, clk_22;
    clock_divider #(.n(2)) _clk_25MHz(clk, clk_25MHz);
    clock_divider #(.n(22)) _clk_22(clk, clk_22);
    
    // VGA part
    wire [11:0] data_0_origin, data_0_blank, data_1, data_2, data_3, data_4, data_5, data_6, data_7, data_8, data_9, data_10, data_11, data_12, data_13, data_14, data_15;
    wire [16:0] pixel_addr_0_origin, pixel_addr_0_blank, pixel_addr_1, pixel_addr_2, pixel_addr_3, pixel_addr_4, pixel_addr_5, pixel_addr_6, pixel_addr_7, pixel_addr_8;
    wire [16:0] pixel_addr_9, pixel_addr_10, pixel_addr_11, pixel_addr_12, pixel_addr_13, pixel_addr_14, pixel_addr_15;
    wire [11:0] pixel_0_origin, pixel_0_blank, pixel_1, pixel_2, pixel_3, pixel_4, pixel_5, pixel_6, pixel_7, pixel_8, pixel_9, pixel_10, pixel_11, pixel_12, pixel_13, pixel_14, pixel_15;
    wire valid;
    wire [9:0] h_cnt; //300
    wire [9:0] v_cnt; //300
    wire [3:0] pic_selected;
    mem_addr_gen addr_12(.clk(clk_22), .rst(rst), .pair_with(4'd12), .h_cnt(h_cnt), .v_cnt(v_cnt), .pixel_addr(pixel_addr_12), .pic_selected());
    mem_addr_gen addr_13(.clk(clk_22), .rst(rst), .pair_with(4'd13), .h_cnt(h_cnt), .v_cnt(v_cnt), .pixel_addr(pixel_addr_13), .pic_selected());
    mem_addr_gen addr_14(.clk(clk_22), .rst(rst), .pair_with(4'd14), .h_cnt(h_cnt), .v_cnt(v_cnt), .pixel_addr(pixel_addr_14), .pic_selected());
    mem_addr_gen addr_15(.clk(clk_22), .rst(rst), .pair_with(4'd15), .h_cnt(h_cnt), .v_cnt(v_cnt), .pixel_addr(pixel_addr_15), .pic_selected(pic_selected));
//    blk_mem_gen_0_origin blk_mem_gen_0_origin_inst(.clka(clk_25MHz), .wea(0), .addra(pixel_addr_0_origin), .dina(data_0_origin[11:0]), .douta(pixel_0_origin)); 
//    blk_mem_gen_0_blank blk_mem_gen_0_blank_inst(.clka(clk_25MHz), .wea(0), .addra(pixel_addr_0_blank), .dina(data_0_blank[11:0]), .douta(pixel_0_blank));
//    blk_mem_gen_1 blk_mem_gen_1_inst(.clka(clk_25MHz), .wea(0), .addra(pixel_addr_1), .dina(data_1[11:0]), .douta(pixel_1));
//    blk_mem_gen_2 blk_mem_gen_2_inst(.clka(clk_25MHz), .wea(0), .addra(pixel_addr_2), .dina(data_2[11:0]), .douta(pixel_2));
//    blk_mem_gen_3 blk_mem_gen_3_inst(.clka(clk_25MHz), .wea(0), .addra(pixel_addr_3), .dina(data_3[11:0]), .douta(pixel_3));
//    blk_mem_gen_4 blk_mem_gen_4_inst(.clka(clk_25MHz), .wea(0), .addra(pixel_addr_4), .dina(data_4[11:0]), .douta(pixel_4));
//    blk_mem_gen_5 blk_mem_gen_5_inst(.clka(clk_25MHz), .wea(0), .addra(pixel_addr_5), .dina(data_5[11:0]), .douta(pixel_5));
//    blk_mem_gen_6 blk_mem_gen_6_inst(.clka(clk_25MHz), .wea(0), .addra(pixel_addr_6), .dina(data_6[11:0]), .douta(pixel_6));
//    blk_mem_gen_7 blk_mem_gen_7_inst(.clka(clk_25MHz), .wea(0), .addra(pixel_addr_7), .dina(data_7[11:0]), .douta(pixel_7));
//    blk_mem_gen_8 blk_mem_gen_8_inst(.clka(clk_25MHz), .wea(0), .addra(pixel_addr_8), .dina(data_8[11:0]), .douta(pixel_8));
//    blk_mem_gen_9 blk_mem_gen_9_inst(.clka(clk_25MHz), .wea(0), .addra(pixel_addr_9), .dina(data_9[11:0]), .douta(pixel_9));
//    blk_mem_gen_10 blk_mem_gen_10_inst(.clka(clk_25MHz), .wea(0), .addra(pixel_addr_10), .dina(data_10[11:0]), .douta(pixel_10));
//    blk_mem_gen_11 blk_mem_gen_11_inst(.clka(clk_25MHz), .wea(0), .addra(pixel_addr_11), .dina(data_11[11:0]), .douta(pixel_11));
    blk_mem_gen_12 blk_mem_gen_12_inst(.clka(clk_25MHz), .wea(0), .addra(pixel_addr_12), .dina(data_12[11:0]), .douta(pixel_12));
    blk_mem_gen_13 blk_mem_gen_13_inst(.clka(clk_25MHz), .wea(0), .addra(pixel_addr_13), .dina(data_13[11:0]), .douta(pixel_13));
    blk_mem_gen_14 blk_mem_gen_14_inst(.clka(clk_25MHz), .wea(0), .addra(pixel_addr_14), .dina(data_14[11:0]), .douta(pixel_14));
    blk_mem_gen_15 blk_mem_gen_15_inst(.clka(clk_25MHz), .wea(0), .addra(pixel_addr_15), .dina(data_15[11:0]), .douta(pixel_15));
    
    always@(*)begin
        if(valid)begin
            case(pic_selected)
                //4'd0: {vgaRed, vgaGreen, vgaBlue} = finished ? pixel_0_origin : pixel_0_blank;
                4'd1: {vgaRed, vgaGreen, vgaBlue} = pixel_1;
                4'd2: {vgaRed, vgaGreen, vgaBlue} = pixel_2;
                4'd3: {vgaRed, vgaGreen, vgaBlue} = pixel_3;
                4'd4: {vgaRed, vgaGreen, vgaBlue} = pixel_4;
                4'd5: {vgaRed, vgaGreen, vgaBlue} = pixel_5;
                4'd6: {vgaRed, vgaGreen, vgaBlue} = pixel_6;
                4'd7: {vgaRed, vgaGreen, vgaBlue} = pixel_7;
                4'd8: {vgaRed, vgaGreen, vgaBlue} = pixel_8;
                4'd9: {vgaRed, vgaGreen, vgaBlue} = pixel_9;
                4'd10: {vgaRed, vgaGreen, vgaBlue} = pixel_10;
                4'd11: {vgaRed, vgaGreen, vgaBlue} = pixel_11;
                4'd12: {vgaRed, vgaGreen, vgaBlue} = pixel_12;
                4'd13: {vgaRed, vgaGreen, vgaBlue} = pixel_13;
                4'd14: {vgaRed, vgaGreen, vgaBlue} = pixel_14;
                4'd15: {vgaRed, vgaGreen, vgaBlue} = pixel_15;
                default: {vgaRed, vgaGreen, vgaBlue} = 12'h0;
            endcase
        end else {vgaRed, vgaGreen, vgaBlue} = 12'h0;
    end
    
    vga_controller vga_inst(.pclk(clk_25MHz), .reset(rst), .hsync(hsync), .vsync(vsync), .valid(valid), .h_cnt(h_cnt), .v_cnt(v_cnt));
endmodule
