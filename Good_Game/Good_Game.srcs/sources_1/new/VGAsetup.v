`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module VGAsetup(
    input clk,
    input rst,
    output hsync,
    output vsync,
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue
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
    //reg [11:0] vga_RGB, n_vga_RGB;
    //assign {vgaRed, vgaGreen, vgaBlue} = valid ? vga_RGB : 12'h0;
    assign {vgaRed, vgaGreen, vgaBlue} = (valid==1'b1) ? pixel_6: 12'h0;
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
    vga_controller vga_inst(.pclk(clk_25MHz), .reset(rst), .hsync(hsync), .vsync(vsync), .valid(valid), .h_cnt(h_cnt), .v_cnt(v_cnt));
endmodule
