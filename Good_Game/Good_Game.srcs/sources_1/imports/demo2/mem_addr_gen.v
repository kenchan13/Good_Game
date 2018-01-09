module mem_addr_gen(
    input clk,
    input rst,
    input [9:0] h_cnt,
    input [9:0] v_cnt,
    output reg [11:0] pixel_addr
    );

    //assign pixel_addr = ((h_cnt>>2) % 30 + (v_cnt>>2) * 30) % 900;
   
    always@(*)begin
        if(80 <= h_cnt && h_cnt < 560) pixel_addr = (((h_cnt-80)>>1) % 60 + (v_cnt>>1) * 60) % 3600;
        else pixel_addr = 0;
    end
endmodule
