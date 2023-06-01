#setting.tcl
set dc_path /cad/CBDK/CBDK_TN40G_Arm/CBDK_TSMC40_core_Arm_v2.0/CIC/SynopsysDC/db
set icc_path /cad/CBDK/CBDK_TN40G_Arm/CBDK_TSMC40_core_Arm_v2.0/CIC/ICC
set pro_path /cad/CBDK/CBDK_TN40G_Arm/CBDK_TSMC40_core_Arm_v2.0/CIC
set period 2.0
set Top_name Top
#0 icc1; 1 icc2
set icc_icc2 0
#0 no gated clock; 1 gated clock
#only used for syn_normal
set GC 1
#0 H-Vt; 1 Multi-Vt; 2 L-Vt; 3 HR-Vt; 4 R-Vt
set MultiVt 1
#SPG
set SPG 0
#Ungroup
set Ungroup 0
#filelist
#set file_list_file "filelist.f"
#set file_list_file "filelist_cg_RegOpt.f"
#set file_list_file "filelist_cg.f"
set file_list_file "filelist_v19.f"