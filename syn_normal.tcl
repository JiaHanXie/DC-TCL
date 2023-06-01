#syn_normal.tcl
#===================set variable===================
source ./Scripts/setting.tcl
#
#===================setup===================
source ./Scripts/setup.tcl
#
#===================read===================
#analyze -recursive -autoread -format verilog ./RTL -top $Top_name
if {$GC == 0} {
	set file_list_file "filelist.f"
} elseif {$GC == 1} {
	set file_list_file "filelist_cg.f"
} else {
	echo "Error! GC not set!"
}
#
set fp [open $file_list_file r]
set file_list [read $fp]
close $fp
set file_list_string "{ $file_list }"
#
analyze -autoread -format verilog -top $Top_name $file_list_string
elaborate $Top_name -architecture verilog -library WORK
current_design $Top_name
link
#
#===================setting after link===================
change_names -hierarchy -rule verilog
change_names -hierarchy -rules name_rule
#remove_unconnected_ports -blast_buses [get_cells * -hier]
set_fix_multiple_port_nets -all -buffer_constants [get_designs *]
#return
check_design
#
source ./Scripts/constraints_syn.tcl
check_timing
#===================setting before compile===================notice!
#set_clock_gating_style \
	-max_fanout 16 \
	-num_stages 4 \
	-control_point before \
	-control_signal scan_enable
#set_clock_gating_objects \
	-exclude { CU SSPE* PMU PMM PSU PAM PSB }
#===================optimize===================
#compile_ultra
#compile_ultra -gate_clock -no_autoungroup
#compile_ultra -gate_clock -scan
#compile_ultra -gate_clock
#replace_clock_gates -global
if {$GC == 1} {
	set_clock_gating_style \
		-max_fanout 16 \
		-num_stages 4
	replace_clock_gates -global
}
uniquify
compile_ultra
#
#===================setting before write out===================
change_names -hierarchy -rule verilog
change_names -hierarchy -rules name_rule
#
#===================report===================
report_area -h > ./Report/area_syn.rpt
report_timing > ./Report/timing_syn.rpt
report_power > ./Report/power_syn.rpt
report_design > ./Report/design_syn.rpt
#
#===================output===================
#ddc
write_file -format ddc -output [format "./Output/%s_syn.ddc" $Top_name]
#verilog
write_file -format verilog -hierarchy -output [format "./Output/%s_syn.v" $Top_name]
#def
#write_def -version 5.8 -output [format "./Output/%s_syn.def" $Top_name]
#sdf
write_sdf -version 3.0 -context verilog -load_delay net [format "./Output/%s_syn.sdf" $Top_name]
#spf
#write_test_protocol -output [format "./Output/%s_syn.spf" $Top_name]
#sdc
write_sdc [format "./Output/%s_syn.sdc" $Top_name]