module mem_addr_gen(
    input clk,
    input rst,
    input [9:0] h_cnt,
    input [9:0] v_cnt,
    output [9:0] pixel_addr
    );

    assign pixel_addr = ((h_cnt>>2) % 30 + (v_cnt>>2) * 30) % 900;
   
endmodule
