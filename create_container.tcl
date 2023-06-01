#create_container.tcl
if {$icc_icc2 == 0} {
	#===================create Milkway library===================
	if {$SPG ==1} {
		set Container_Name CHIP_MW_SPG
	} else {
		set Container_Name CHIP_MW
	}
	create_mw_lib $Container_Name \
		-technology $icc_path/sc9_tech.tf -open \
		-mw_reference_library "
			$icc_path/sc9_cln40g_base_lvt
			$icc_path/sc9_cln40g_base_rvt
			$icc_path/sc9_cln40g_base_hvt"
} elseif {$icc_icc2 == 1} {
	#===================create NDM library===================
	if {$SPG ==1} {
		set Container_Name CHIP_NDM_SPG
	} else {
		set Container_Name CHIP_NDM
	}
	create_lib $Container_Name \
		-use_technology_lib TECH_LIB.ndm \
		-ref_libs "
			TECH_LIB.ndm
			TN40G_physical_only.ndm
			sc9_cln40g_base_hvt_ss_typical_max_0p81v_c.ndm
			sc9_cln40g_base_rvt_ss_typical_max_0p81v_c.ndm
			sc9_cln40g_base_lvt_ss_typical_max_0p81v_c.ndm"
} else {
	echo "Error! Container not set!"
}