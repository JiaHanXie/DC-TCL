#ndm_gen.tcl
if {[file isdirectory *.ndm ]} {
	sh rm -r *.ndm
}
#CLIB
set dc_path /cad/CBDK/CBDK_TN40G_Arm/CBDK_TSMC40_core_Arm_v2.0/CIC/SynopsysDC/db
set icc_path /cad/CBDK/CBDK_TN40G_Arm/CBDK_TSMC40_core_Arm_v2.0/CIC/ICC
set pro_path /cad/CBDK/CBDK_TN40G_Arm/CBDK_TSMC40_core_Arm_v2.0/CIC
set db "$dc_path/sc9_base_hvt/sc9_cln40g_base_hvt_ss_typical_max_0p81v_125c.db
			$dc_path/sc9_base_hvt/sc9_cln40g_base_hvt_ss_typical_max_0p81v_m40c.db
			$dc_path/sc9_base_rvt/sc9_cln40g_base_rvt_ss_typical_max_0p81v_125c.db
			$dc_path/sc9_base_rvt/sc9_cln40g_base_rvt_ss_typical_max_0p81v_m40c.db
			$dc_path/sc9_base_lvt/sc9_cln40g_base_lvt_ss_typical_max_0p81v_125c.db
			$dc_path/sc9_base_lvt/sc9_cln40g_base_lvt_ss_typical_max_0p81v_m40c.db"
set lef "$pro_path/INNOVUS_stylus/lef/sc9_cln40g_base_hvt_oa.lef
			$pro_path/INNOVUS_stylus/lef/sc9_cln40g_base_lvt_oa.lef
			$pro_path/INNOVUS_stylus/lef/sc9_cln40g_base_rvt_oa.lef
			$pro_path/INNOVUS_stylus/lef/sc9_tech_oa.lef"
#
create_workspace TN40G -flow exploration -technology $icc_path/sc9_tech.tf
set_pvt_configuration -temperature {-40 125}
read_db $db
read_lef $lef
group_libs
write_workspace -file ./CLIB_scripts/lib_template.tcl
process_workspaces
remove_workspace
#TECH
create_workspace TECH_LIB -technology $icc_path/sc9_tech.tf
read_parasitic_tech -tlup $icc_path/tluplus/rcworst.tluplus \
					-layermap $icc_path/tluplus/tluplus.map \
					-name rcworst
read_parasitic_tech -tlup $icc_path/tluplus/rcbest.tluplus \
					-layermap $icc_path/tluplus/tluplus.map \
					-name rcbest
set_attribute [get_site_defs unit] symmetry Y
set_attribute [get_site_defs unit] is_default true
set_attribute [get_layers {M1}] track_offset 0.07
set_attribute [get_layers {M2}] track_offset 0.07
set_attribute [get_layers {M1 M3 M5 M7 M9}] routing_direction horizontal
set_attribute [get_layers {M2 M4 M6 M8 AP}] routing_direction vertical
commit_workspace