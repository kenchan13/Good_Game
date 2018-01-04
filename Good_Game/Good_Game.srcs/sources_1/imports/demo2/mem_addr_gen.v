module mem_addr_gen(
    input clk,
    input rst,
    input [9:0] h_cnt,
    input [9:0] v_cnt,
    input [3:0] pair_with,
    output reg [9:0] pixel_addr,
    output reg [3:0] pic_selected
    );
   
    reg [9:0] n_pixel_addr;
    reg [3:0] n_pic_selected;
    //assign pixel_addr = ( ((h_cnt>>1) + position) % 30 +(v_cnt>>1)*30) % 900;
   
    always@(posedge clk)begin
        if(rst)begin
            pic_selected <= 4'd15;
            pixel_addr <= 10'd0;
        end else begin
            pic_selected <= n_pic_selected;
            pixel_addr <= n_pixel_addr;
        end
    end
   
    always@(*)begin
        if( (260 < h_cnt && h_cnt <= 290) && (180 < v_cnt && v_cnt <= 210)) n_pic_selected = 4'd15;
        
        ////////////////////////////////////////////////////////////////
        n_pixel_addr = pair_with==pic_selected ? pixel_addr + 10'd1 : pixel_addr;
    end
endmodule
