#constraints_syn.tcl
#===================clock constraints===================
create_clock -name clk -period $period  [get_ports clk]
set_fix_hold [get_clocks clk]
set_dont_touch_network [get_clocks clk]
set_clock_uncertainty 0.3 [get_clocks clk]
set_clock_latency -source 0 [get_clocks clk]
set_clock_latency 2 [get_clocks clk]
set_input_transition 0.5 [get_ports clk]
set_clock_transition 0.1 [get_clocks clk]
set_ideal_network [get_ports clk]
set_ideal_network [get_ports rst]
#===================design environment===================
#set_operating_conditions -min_library sc9_cln40g_base_lvt_ss_typical_max_0p81v_m40c -min ss_typical_max_0p81v_m40c \
						-max_library sc9_cln40g_base_hvt_ss_typical_max_0p81v_125c -max ss_typical_max_0p81v_125c
#set_operating_conditions -max_library sc9_cln40g_base_hvt_ss_typical_max_0p81v_125c -max ss_typical_max_0p81v_125c
if {$MultiVt == 0} {
	set_operating_conditions -min_library sc9_cln40g_base_hvt_ss_typical_max_0p81v_m40c -min ss_typical_max_0p81v_m40c \
		-max_library sc9_cln40g_base_hvt_ss_typical_max_0p81v_125c -max ss_typical_max_0p81v_125c
} elseif {$MultiVt == 1} {
	set_operating_conditions -min_library sc9_cln40g_base_lvt_ss_typical_max_0p81v_m40c -min ss_typical_max_0p81v_m40c \
		-max_library sc9_cln40g_base_hvt_ss_typical_max_0p81v_125c -max ss_typical_max_0p81v_125c
} elseif {$MultiVt == 2} {
	set_operating_conditions -min_library sc9_cln40g_base_lvt_ss_typical_max_0p81v_m40c -min ss_typical_max_0p81v_m40c \
		-max_library sc9_cln40g_base_lvt_ss_typical_max_0p81v_125c -max ss_typical_max_0p81v_125c
} elseif {$MultiVt == 3} {
	set_operating_conditions -min_library sc9_cln40g_base_rvt_ss_typical_max_0p81v_m40c -min ss_typical_max_0p81v_m40c \
		-max_library sc9_cln40g_base_hvt_ss_typical_max_0p81v_125c -max ss_typical_max_0p81v_125c
} elseif {$MultiVt == 4} {
	set_operating_conditions -min_library sc9_cln40g_base_rvt_ss_typical_max_0p81v_m40c -min ss_typical_max_0p81v_m40c \
		-max_library sc9_cln40g_base_rvt_ss_typical_max_0p81v_125c -max ss_typical_max_0p81v_125c
} else {
	echo "Error! MVt not set!"
}
#Need Input pad information
set_drive 0.005 [all_inputs]
set_drive 0.0 {clk rst}
set_max_fanout 32 [all_inputs]
#40 for TSRI, 10 for PCB, 0.03 for IO pad, 0.005 for submodule, 0 for research
set_load 0.03 [all_outputs]
#Don't touch the basic env setting as below#
set_input_delay 0.0 -clock clk [all_inputs]
set_output_delay 0.0 -clock clk [all_outputs]