// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
// Date        : Tue Dec 26 16:05:34 2017
// Host        : pc-37 running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ KeyboardCtrl_0_stub.v
// Design      : KeyboardCtrl_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "KeyboardCtrl,Vivado 2017.2" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(key_in, is_extend, is_break, valid, err, PS2_DATA, 
  PS2_CLK, rst, clk)
/* synthesis syn_black_box black_box_pad_pin="key_in[7:0],is_extend,is_break,valid,err,PS2_DATA,PS2_CLK,rst,clk" */;
  output [7:0]key_in;
  output is_extend;
  output is_break;
  output valid;
  output err;
  inout PS2_DATA;
  inout PS2_CLK;
  input rst;
  input clk;
endmodule