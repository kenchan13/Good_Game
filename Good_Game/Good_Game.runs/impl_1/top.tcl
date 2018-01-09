proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}


start_step init_design
set ACTIVE_STEP init_design
set rc [catch {
  create_msg_db init_design.pb
  set_param xicom.use_bs_reader 1
  create_project -in_memory -part xc7a35tcpg236-1
  set_property design_mode GateLvl [current_fileset]
  set_param project.singleFileAddWarning.threshold 0
  set_property webtalk.parent_dir C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.cache/wt [current_project]
  set_property parent.project_path C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.xpr [current_project]
  set_property ip_repo_paths C:/Users/user/Desktop/KeyboardSampleCode/ip [current_project]
  set_property ip_output_repo C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.cache/ip [current_project]
  set_property ip_cache_permissions {read write} [current_project]
  set_property XPM_LIBRARIES XPM_MEMORY [current_project]
  add_files -quiet C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.runs/synth_1/top.dcp
  read_ip -quiet C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/ip/blk_mem_gen_15/blk_mem_gen_15.xci
  set_property is_locked true [get_files C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/ip/blk_mem_gen_15/blk_mem_gen_15.xci]
  read_ip -quiet C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/ip/blk_mem_gen_14/blk_mem_gen_14.xci
  set_property is_locked true [get_files C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/ip/blk_mem_gen_14/blk_mem_gen_14.xci]
  read_ip -quiet C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/ip/blk_mem_gen_13/blk_mem_gen_13.xci
  set_property is_locked true [get_files C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/ip/blk_mem_gen_13/blk_mem_gen_13.xci]
  read_ip -quiet C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/ip/blk_mem_gen_12/blk_mem_gen_12.xci
  set_property is_locked true [get_files C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/ip/blk_mem_gen_12/blk_mem_gen_12.xci]
  read_ip -quiet C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/ip/blk_mem_gen_11/blk_mem_gen_11.xci
  set_property is_locked true [get_files C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/ip/blk_mem_gen_11/blk_mem_gen_11.xci]
  read_ip -quiet C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/ip/blk_mem_gen_10/blk_mem_gen_10.xci
  set_property is_locked true [get_files C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/ip/blk_mem_gen_10/blk_mem_gen_10.xci]
  read_ip -quiet C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/ip/blk_mem_gen_9/blk_mem_gen_9.xci
  set_property is_locked true [get_files C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/ip/blk_mem_gen_9/blk_mem_gen_9.xci]
  read_ip -quiet C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/ip/blk_mem_gen_8/blk_mem_gen_8.xci
  set_property is_locked true [get_files C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/ip/blk_mem_gen_8/blk_mem_gen_8.xci]
  read_ip -quiet C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/ip/blk_mem_gen_7/blk_mem_gen_7.xci
  set_property is_locked true [get_files C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/ip/blk_mem_gen_7/blk_mem_gen_7.xci]
  read_ip -quiet C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/ip/blk_mem_gen_6/blk_mem_gen_6.xci
  set_property is_locked true [get_files C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/ip/blk_mem_gen_6/blk_mem_gen_6.xci]
  read_ip -quiet C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/ip/blk_mem_gen_5/blk_mem_gen_5.xci
  set_property is_locked true [get_files C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/ip/blk_mem_gen_5/blk_mem_gen_5.xci]
  read_ip -quiet C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/ip/blk_mem_gen_4/blk_mem_gen_4.xci
  set_property is_locked true [get_files C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/ip/blk_mem_gen_4/blk_mem_gen_4.xci]
  read_ip -quiet C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/ip/blk_mem_gen_3/blk_mem_gen_3.xci
  set_property is_locked true [get_files C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/ip/blk_mem_gen_3/blk_mem_gen_3.xci]
  read_ip -quiet C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/ip/blk_mem_gen_2/blk_mem_gen_2.xci
  set_property is_locked true [get_files C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/ip/blk_mem_gen_2/blk_mem_gen_2.xci]
  read_ip -quiet C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/ip/blk_mem_gen_1/blk_mem_gen_1.xci
  set_property is_locked true [get_files C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/ip/blk_mem_gen_1/blk_mem_gen_1.xci]
  read_ip -quiet C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/ip/blk_mem_gen_0_blank/blk_mem_gen_0_blank.xci
  set_property is_locked true [get_files C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/ip/blk_mem_gen_0_blank/blk_mem_gen_0_blank.xci]
  read_ip -quiet C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/ip/blk_mem_gen_0_origin/blk_mem_gen_0_origin.xci
  set_property is_locked true [get_files C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/ip/blk_mem_gen_0_origin/blk_mem_gen_0_origin.xci]
  read_ip -quiet C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/ip/KeyboardCtrl_0/KeyboardCtrl_0.xci
  set_property is_locked true [get_files C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/ip/KeyboardCtrl_0/KeyboardCtrl_0.xci]
  read_xdc C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/constrs_1/imports/Downloads/Basys3_Constraints.xdc
  link_design -top top -part xc7a35tcpg236-1
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
  unset ACTIVE_STEP 
}

start_step opt_design
set ACTIVE_STEP opt_design
set rc [catch {
  create_msg_db opt_design.pb
  opt_design 
  write_checkpoint -force top_opt.dcp
  catch { report_drc -file top_drc_opted.rpt }
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
  unset ACTIVE_STEP 
}

start_step place_design
set ACTIVE_STEP place_design
set rc [catch {
  create_msg_db place_design.pb
  implement_debug_core 
  place_design 
  write_checkpoint -force top_placed.dcp
  catch { report_io -file top_io_placed.rpt }
  catch { report_utilization -file top_utilization_placed.rpt -pb top_utilization_placed.pb }
  catch { report_control_sets -verbose -file top_control_sets_placed.rpt }
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
  unset ACTIVE_STEP 
}

start_step route_design
set ACTIVE_STEP route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force top_routed.dcp
  catch { report_drc -file top_drc_routed.rpt -pb top_drc_routed.pb -rpx top_drc_routed.rpx }
  catch { report_methodology -file top_methodology_drc_routed.rpt -rpx top_methodology_drc_routed.rpx }
  catch { report_power -file top_power_routed.rpt -pb top_power_summary_routed.pb -rpx top_power_routed.rpx }
  catch { report_route_status -file top_route_status.rpt -pb top_route_status.pb }
  catch { report_clock_utilization -file top_clock_utilization_routed.rpt }
  catch { report_timing_summary -warn_on_violation -max_paths 10 -file top_timing_summary_routed.rpt -rpx top_timing_summary_routed.rpx }
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  write_checkpoint -force top_routed_error.dcp
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
  unset ACTIVE_STEP 
}

start_step write_bitstream
set ACTIVE_STEP write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  set_property XPM_LIBRARIES XPM_MEMORY [current_project]
  catch { write_mem_info -force top.mmi }
  write_bitstream -force top.bit 
  catch {write_debug_probes -no_partial_ltxfile -quiet -force debug_nets}
  catch {file copy -force debug_nets.ltx top.ltx}
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
  unset ACTIVE_STEP 
}

