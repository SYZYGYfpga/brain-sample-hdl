############################################################################
# SYZYGY Brain-1 - Xilinx constraints file
#
# Pin mappings for the SYZYGY Brain-1.  Use this as a template and comment out
# the pins that are not used in your design.  (By default, map will fail
# if this file contains constraints for signals not in your design).
#
# Copyright (c) 2004-2017 Opal Kelly Incorporated
############################################################################

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS True [current_design]

# PORTA-5
set_property PACKAGE_PIN AB13 [get_ports {dac_data[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {dac_data[0]}]

# PORTA-6
set_property PACKAGE_PIN AA14 [get_ports {dac_data[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {dac_data[1]}]

# PORTA-7
set_property PACKAGE_PIN AB14 [get_ports {dac_data[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {dac_data[2]}]

# PORTA-8
set_property PACKAGE_PIN AA15 [get_ports {dac_data[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {dac_data[3]}]

# PORTA-9
set_property PACKAGE_PIN AB16 [get_ports {dac_data[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {dac_data[4]}]

# PORTA-10
set_property PACKAGE_PIN AB18 [get_ports {dac_data[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {dac_data[5]}]

# PORTA-11
set_property PACKAGE_PIN AB17 [get_ports {dac_data[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {dac_data[6]}]

# PORTA-12
set_property PACKAGE_PIN AB19 [get_ports {dac_data[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {dac_data[7]}]

# PORTA-13
set_property PACKAGE_PIN Y14 [get_ports {dac_data[8]}]
set_property IOSTANDARD LVCMOS18 [get_ports {dac_data[8]}]

# PORTA-14
set_property PACKAGE_PIN AA16 [get_ports {dac_data[9]}]
set_property IOSTANDARD LVCMOS18 [get_ports {dac_data[9]}]

# PORTA-15
set_property PACKAGE_PIN Y15 [get_ports {dac_data[10]}]
set_property IOSTANDARD LVCMOS18 [get_ports {dac_data[10]}]

# PORTA-16
set_property PACKAGE_PIN AA17 [get_ports {dac_data[11]}]
set_property IOSTANDARD LVCMOS18 [get_ports {dac_data[11]}]

# PORTA-17
set_property PACKAGE_PIN AA19 [get_ports dac_cs_n]
set_property IOSTANDARD LVCMOS18 [get_ports dac_cs_n]

# PORTA-18
set_property PACKAGE_PIN AB21 [get_ports dac_sclk]
set_property IOSTANDARD LVCMOS18 [get_ports dac_sclk]

# PORTA-19
set_property PACKAGE_PIN AA20 [get_ports dac_sdio]
set_property IOSTANDARD LVCMOS18 [get_ports dac_sdio]

# PORTA-20
set_property PACKAGE_PIN AB22 [get_ports dac_opamp_en]
set_property IOSTANDARD LVCMOS18 [get_ports dac_opamp_en]

# PORTA-21
set_property PACKAGE_PIN W17 [get_ports dac_reset_pinmd]
set_property IOSTANDARD LVCMOS18 [get_ports dac_reset_pinmd]

# PORTA-34
set_property PACKAGE_PIN V16 [get_ports dac_clk]
set_property IOSTANDARD LVCMOS18 [get_ports dac_clk]

# LEDs #####################################################################
set_property PACKAGE_PIN W12 [get_ports {led[0]}]
set_property PACKAGE_PIN Y12 [get_ports {led[1]}]
set_property PACKAGE_PIN AA11 [get_ports {led[2]}]
set_property PACKAGE_PIN AB11 [get_ports {led[3]}]
set_property PACKAGE_PIN W13 [get_ports {led[4]}]
set_property PACKAGE_PIN Y13 [get_ports {led[5]}]
set_property PACKAGE_PIN AA12 [get_ports {led[6]}]
set_property PACKAGE_PIN AB12 [get_ports {led[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[*]}]

# Buttons ##################################################################
set_property PACKAGE_PIN R17 [get_ports {button[0]}]
set_property PACKAGE_PIN T17 [get_ports {button[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {button[*]}]


# DAC Output port timing constraints
create_generated_clock -name dac_clk -source [get_pins dac_top/dac_phy_impl/ODDR_inst/C] -divide_by 1 [get_ports dac_clk]

set_output_delay -clock [get_clocks dac_clk] -clock_fall -min -add_delay -1.500 [get_ports {dac_data[*]}]
set_output_delay -clock [get_clocks dac_clk] -clock_fall -max -add_delay 0.250 [get_ports {dac_data[*]}]
set_output_delay -clock [get_clocks dac_clk] -min -add_delay -1.600 [get_ports {dac_data[*]}]
set_output_delay -clock [get_clocks dac_clk] -max -add_delay 0.130 [get_ports {dac_data[*]}]

set_false_path -from [get_ports {button[*]}]


