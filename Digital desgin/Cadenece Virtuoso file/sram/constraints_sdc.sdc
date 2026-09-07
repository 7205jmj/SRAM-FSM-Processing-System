create_clock -name clk -period 2 -waveform {0 1} [get_ports "clk"]
set_clock_transition -rise 0.1 [get_clocks "clk"]
set_clock_transition -fall 0.1 [get_clocks "clk"]
set_clock_uncertainty 0.01 [get_ports "clk"]

set_input_delay -max 0.8 [get_ports "we"] -clock [get_clocks "clk"]
set_input_delay -max 0.8 [get_ports "addr"] -clock [get_clocks "clk"]
set_input_delay -max 0.8 [get_ports "din"] -clock [get_clocks "clk"]
set_output_delay -max 0.8 [get_ports "dout"] -clock [get_clocks "clk"]

set_load 0.15 [all_outputs]
set_max_fanout 30.00 [current_design]

