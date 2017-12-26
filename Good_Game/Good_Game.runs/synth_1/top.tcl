# 
# Synthesis run script generated by Vivado
# 

create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.cache/wt [current_project]
set_property parent.project_path C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_repo_paths c:/Users/user/Desktop/KeyboardSampleCode/ip [current_project]
set_property ip_output_repo c:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib {
  C:/Users/user/Desktop/KeyboardSampleCode/KeyboardDecoder.v
  C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/imports/KeyboardSampleCode/OnePulse.v
  C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/imports/KeyboardSampleCode/SevenSegment.v
  C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/imports/Downloads/clock_divider.v
  C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/imports/Downloads/debouncer.v
  C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/new/top.v
}
read_ip -quiet C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/ip/KeyboardCtrl_0/KeyboardCtrl_0.xci
set_property is_locked true [get_files C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/sources_1/ip/KeyboardCtrl_0/KeyboardCtrl_0.xci]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/constrs_1/imports/Downloads/Basys3_Constraints.xdc
set_property used_in_implementation false [get_files C:/Users/user/Desktop/Good_Game/Good_Game/Good_Game.srcs/constrs_1/imports/Downloads/Basys3_Constraints.xdc]


synth_design -top top -part xc7a35tcpg236-1


write_checkpoint -force -noxdef top.dcp

catch { report_utilization -file top_utilization_synth.rpt -pb top_utilization_synth.pb }