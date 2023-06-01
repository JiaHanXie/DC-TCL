#set dc_path /cad/CBDK/CBDK_TN40G_Arm/CBDK_TSMC40_core_Arm_v2.0/CIC/SynopsysDC/db
#===================report for multi Vt===================
set RVt_lib "sc9_cln40g_base_rvt_ss_typical_max_0p81v_125c
				sc9_cln40g_base_rvt_ss_typical_max_0p81v_m40c"
set HVt_lib "sc9_cln40g_base_hvt_ss_typical_max_0p81v_125c
				sc9_cln40g_base_hvt_ss_typical_max_0p81v_m40c"
set LVt_lib "sc9_cln40g_base_lvt_ss_typical_max_0p81v_125c
				sc9_cln40g_base_lvt_ss_typical_max_0p81v_m40c"
set_attribute [get_libs $RVt_lib] default_threshold_voltage_group RVt -type string
set_attribute [get_libs $HVt_lib] default_threshold_voltage_group HVt -type string
set_attribute [get_libs $LVt_lib] default_threshold_voltage_group LVt -type string