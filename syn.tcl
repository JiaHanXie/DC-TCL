#syn.tcl
#if {[file isdirectory CHIP_MW ]} {
#	sh rm -r CHIP_MW
#}
#if {[file isdirectory CHIP_NDM ]} {
#	sh rm -r CHIP_NDM
#}
#===================set variable===================
source -echo ./Scripts/setting.tcl
if {$icc_icc2 ==0} {
	if {$SPG ==1} {
		if {[file isdirectory CHIP_MW_SPG ]} {
			sh rm -r CHIP_MW_SPG
		}
	} else {
		if {[file isdirectory CHIP_MW ]} {
			sh rm -r CHIP_MW
		}
	}
} elseif {$icc_icc2 ==1} {
	if {$SPG ==1} {
		if {[file isdirectory CHIP_NDM_SPG ]} {
			sh rm -r CHIP_NDM_SPG
		}
	} else {
		if {[file isdirectory CHIP_NDM ]} {
			sh rm -r CHIP_NDM
		}
	} 
} else {
	echo "Error! icc_icc2 not set!"
}
#
#===================setup===================
#source -echo ./Scripts/setup.tcl
if {$MultiVt == 0} {
	source -echo ./Scripts/setup.tcl
} elseif {$MultiVt == 1} {
	source -echo ./Scripts/setup_MVt.tcl
} elseif {$MultiVt == 2} {
	source -echo ./Scripts/setup_LVt.tcl
} elseif {$MultiVt == 3} {
	source -echo ./Scripts/setup_HRVt.tcl
} elseif {$MultiVt == 4} {
	source -echo ./Scripts/setup_RVt.tcl
} else {
	echo "Error! MVt not set!"
}
#
#===================set_tlu_plus_files===================
source -echo ./Scripts/set_tlufile.tcl
#
#===================create container===================
#notice: ICC -> Milkyway, ICC2 -> NDM
source -echo ./Scripts/create_container.tcl
#return
#
#===================read===================
#analyze -recursive -autoread -format verilog ./RTL -top $Top_name
#analyze -format verilog -top $Top_name {file_list}
#
#if {$GC == 1} {
	#set file_list_file "filelist_cg.f"
	#set file_list_file "filelist_cg_RegOpt.f"
#} else {
	#set file_list_file "filelist.f"
#}
#set file_list_file "filelist_cg.f"
set fp [open $file_list_file r]
set file_list [read $fp]
close $fp
set file_list_string "{ $file_list }"
#
analyze -autoread -format verilog -top $Top_name $file_list_string
elaborate $Top_name -architecture verilog -library WORK
current_design $Top_name
link
#===================set Metal(TN40G)===================
source -echo ./Scripts/set_metal_direction.tcl
#===================SPG===================
#This variable controls NXT total power optimization feature 
#which includes both sizing and placement related total power optimizations.
#SPG compile only
#
if {$SPG == 1} {
	set compile_high_effort_area true
	set_app_var compile_enhanced_tns_optimization true
	set_app_var compile_prefer_mux true
	set spg_congestion_placement_in_incremental_compile true
	set compile_enable_total_power_optimization true
	extract_physical_constraints ./Output/init.def
	analyze_rtl_congestion
}
#return
check_design
#
#===================constraints===================
source -echo ./Scripts/constraints_syn.tcl
set high_fanout_net_threshold 256
check_timing
#===================dft===================
source -echo ./Scripts/dft_setting.tcl
create_test_protocol -infer_asynch -infer_clock
#set_clock_gating_objects \
	-exclude { CU SSPE PMU PMM PSU PAM }
#
#===================clock gating===================
if {$GC == 1} {
	set_clock_gating_style \
		-sequential_cell latch \
		-positive_edge_logic {integrated} \
		-setup 0.3 \
		-max_fanout 128 \
		-num_stages 1 \
		-control_point before \
		-control_signal scan_enable
	#
	set_clock_gating_check -setup 0.3
	replace_clock_gates
	#
	report_clock_gating -gating_elements
	#set_ideal_network [get_pins -hierarchical ENCLK]
	foreach_in_collection var [all_clock_gates -output_pins ] {
		set gated_net [index_collection [get_nets -of [get_object_name $var] -segments] 1]
		set gating_pin [get_pins -of_objects $gated_net]
		set_ideal_network [index_collection $gating_pin 1]
	}
	#for latch free clock gating cell
	#set power_cg_derive_related_clock true
	#set power_cg_ignore_setup_condition true
	#
	#set power_cg_reconfig_stages true
	#set power_cg_balance_stages true
	#set compile_clock_gating_through_hierarchy true
	set power_cg_auto_identify true
	#spg ICC2
	#set power_cg_physically_aware_cg true
}
#return
#===================setting before compile===================notice!
#It predicts the power consumption of missing elements in the design such as clock trees.
set power_prediction true
#This command enables or disables dynamic-power optimization on the current design.
set_dynamic_optimization true
#This command is no longer needed for the compile_ultra command 
#because leakage-power optimization is enabled by default and 
#cannot be disabled within the compile_ultra command.
#set_leakage_optimization true
#
propagate_constraints -all
uniquify
#===================setting after uniquify===================
#change_names -hierarchy -rule verilog
#change_names -hierarchy -rules name_rule
#remove_unconnected_ports -blast_buses [get_cells * -hier]
set_fix_multiple_port_nets -all -buffer_constants [get_designs *]
#===================optimize===================
#compile_ultra -gate_clock -no_autoungroup
#compile_ultra -scan -gate_clock
if {$SPG == 1} {
	#compile_ultra -scan -gate_clock
	#compile_ultra -scan -spg
	#compile_ultra -scan -spg -no_autoungroup
	if {$Ungroup == 0} {
		compile_ultra -scan -spg
	} elseif {$Ungroup == 1} {
		compile_ultra -scan -spg -no_autoungroup
	} else {
		echo "Error! Ungroup not set!"
	}
} else {
	#compile_ultra -scan
	#compile_ultra -scan -no_autoungroup
	if {$Ungroup == 0} {
		compile_ultra -scan
	} elseif {$Ungroup == 1} {
		compile_ultra -scan -no_autoungroup
	} else {
		echo "Error! Ungroup not set!"
	}
}
#
#ddc
write_file -format ddc -hierarchy -output [format "./Output/%s_syn_predft.ddc" $Top_name]
#===================pre dft===================
source -echo ./Scripts/dft_setting.tcl
if {$GC == 1} {
	set_dft_clock_gating_pin -pin_name TE [get_cells -hierarchical *clk_gate*]
}
create_test_protocol -infer_asynch -infer_clock
dft_drc
preview_dft
insert_dft
#
#
#===================report before incremental compile===================
if {$GC == 1} {
	report_clock_gating -gating_elements
}
report_power
#report for multi-Vt
source -echo ./Scripts/report_MultiVt.tcl
report_threshold_voltage_group
set_critical_range 0.5 [current_design]
#===================incremental compile===================
#notice Handing off CCD information to IC Compiler II
#derive_clock_balance_points during CTS
#set compile_enable_ccd true
#compile_ultra -incremental -scan -gate_clock
if {$SPG == 1} {
	#compile_ultra -incremental -scan -gate_clock
	#compile_ultra -incremental -scan -spg
	#compile_ultra -incremental -scan -spg -no_autoungroup
	if {$Ungroup == 0} {
		compile_ultra -incremental -scan -spg
	} elseif {$Ungroup == 1} {
		compile_ultra -incremental -scan -spg -no_autoungroup
	} else {
		echo "Error! Ungroup not set!"
	}
} else {
	#compile_ultra -incremental -scan
	#compile_ultra -incremental -scan -no_autoungroup
	if {$Ungroup == 0} {
		compile_ultra -incremental -scan
	} elseif {$Ungroup == 1} {
		compile_ultra -incremental -scan -no_autoungroup
	} else {
		echo "Error! Ungroup not set!"
	}
}
#===================post dft===================
set_app_var test_disable_enhanced_dft_drc_reporting false
dft_drc
#===================setting before write out===================
remove_unconnected_ports -blast_buses [get_cells -hier *]
change_names -hierarchy -rule verilog
change_names -hierarchy -rules name_rule
#set_fix_multiple_port_nets -all -buffer_constants [get_designs *]
#===================report===================
source -echo ./Scripts/report.tcl
#
#===================output===================
source -echo ./Scripts/write_file.tcl