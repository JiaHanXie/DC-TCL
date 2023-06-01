#set_metal_direction.tcl
#===================set Metal(TN40G)===================
set_preferred_routing_direction \
   -layers {M1 M3 M5 M7 M9} -direction V
set_preferred_routing_direction \
   -layers {M2 M4 M6 M8 AP} -direction H