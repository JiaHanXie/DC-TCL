if {$SPG == 1} {
	set Tag_Output "syn_spg"
} else {
	set Tag_Output "syn"
}
#ddc
write_file -format ddc -hierarchy -output [format "./Output/%s_%s.ddc" $Top_name $Tag_Output]
#verilog
write_file -format verilog -hierarchy -output [format "./Output/%s_%s.v" $Top_name $Tag_Output]
#def
write_scan_def -output [format "./Output/%s_%s.SCANDEF" $Top_name $Tag_Output]
write_def -version 5.8 -output [format "./Output/%s_fp_%s.def" $Top_name $Tag_Output]
#sdf
write_sdf -version 3.0 -context verilog -load_delay net [format "./Output/%s_%s.sdf" $Top_name $Tag_Output]
#spf
write_test_protocol -output [format "./Output/%s_%s.spf" $Top_name $Tag_Output]
#sdc
write_sdc -version 2.1 [format "./Output/%s_%s.sdc" $Top_name $Tag_Output]