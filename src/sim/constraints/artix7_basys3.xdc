## Clock signal (100 MHz)
set_property -dict { PACKAGE_PIN W5   IOSTANDARD LVCMOS33 } [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## Push Buttons
set_property -dict { PACKAGE_PIN U18  IOSTANDARD LVCMOS33 } [get_ports rst]      ;# BTNC (Center)
set_property -dict { PACKAGE_PIN W19  IOSTANDARD LVCMOS33 } [get_ports coin_5]   ;# BTNL (Left)
set_property -dict { PACKAGE_PIN T17  IOSTANDARD LVCMOS33 } [get_ports coin_10]  ;# BTNR (Right)

## LEDs
set_property -dict { PACKAGE_PIN U16  IOSTANDARD LVCMOS33 } [get_ports {state_led[0]}] ;# LD0
set_property -dict { PACKAGE_PIN E19  IOSTANDARD LVCMOS33 } [get_ports {state_led[1]}] ;# LD1
set_property -dict { PACKAGE_PIN U19  IOSTANDARD LVCMOS33 } [get_ports dispense]     ;# LD2
set_property -dict { PACKAGE_PIN V19  IOSTANDARD LVCMOS33 } [get_ports change_5]     ;# LD3
