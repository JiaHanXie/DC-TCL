if {$SPG == 1} {
	set Tag_Report "syn_spg.rpt"
} else {
	set Tag_Report "syn.rpt"
}
report_qor -significant_digits 4 > [format "./Report/qor_%s" $Tag_Report]
report_clock_gating -gating_elements > [format "./Report/clk_gating_%s" $Tag_Report]
report_area -h > [format "./Report/area_%s" $Tag_Report]
report_timing > [format "./Report/timing_%s" $Tag_Report]
report_power > [format "./Report/power_%s" $Tag_Report]
report_design > [format "./Report/design_%s" $Tag_Report]
report_scan_path -view existing_dft \
-chain all > [format "./Report/dft_chain_%s" $Tag_Report]
report_scan_path -view existing_dft \
-cell all > [format "./Report/dft_cell_%s" $Tag_Report]
#report for multi-Vt
report_threshold_voltage_group > [format "./Report/MultiVt_%s" $Tag_Report]
report_congestion > [format "./Report/Congestion_%s" $Tag_Report]