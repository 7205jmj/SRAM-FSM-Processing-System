# Read Lib,RTL and SDC files
read_lib /home/install/FOUNDRY/digital/90nm/dig/lib/slow.lib    
read_hdl sram_4x4.v
elaborate 
read_sdc constraints_sdc.sdc
# Setting effort medium
set_db syn_generic_effort medium
syn_generic
set_db syn_map_effort medium
syn_map
set_db syn_opt_effort medium
syn_opt
# genus outputs 
write_hdl > netlist.v
write_sdc > block.sdc
# Power,performance and area (PPA) reports
report_area > area.rep
report_gates > gate.rep
report_power > power.rep
report_timing > timing.rep
gui_show



