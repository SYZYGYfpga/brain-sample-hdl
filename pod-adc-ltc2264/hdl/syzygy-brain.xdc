############################################################################
# SYZYGY Brain-1 - Xilinx constraints file
#
# Pin mappings for the SYZYGY Brain-1.  Use this as a template and comment out
# the pins that are not used in your design.  (By default, map will fail
# if this file contains constraints for signals not in your design).
#
# Copyright (c) 2004-2018 Opal Kelly Incorporated
############################################################################

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS True [current_design]

##########################################################
# ADC Section
##########################################################

# PORTD-5
set_property IOSTANDARD LVDS_25 [get_ports {adc_out_1p[0]}]

# PORTD-6
set_property IOSTANDARD LVDS_25 [get_ports adc_fr_p]

# PORTD-7
set_property PACKAGE_PIN B7 [get_ports {adc_out_1p[0]}]
set_property PACKAGE_PIN B6 [get_ports {adc_out_1n[0]}]
set_property IOSTANDARD LVDS_25 [get_ports {adc_out_1n[0]}]

# PORTD-8
set_property PACKAGE_PIN C6 [get_ports adc_fr_p]
set_property PACKAGE_PIN C5 [get_ports adc_fr_n]
set_property IOSTANDARD LVDS_25 [get_ports adc_fr_n]

# PORTD-9
set_property IOSTANDARD LVDS_25 [get_ports {adc_out_1p[1]}]

# PORTD-10
set_property IOSTANDARD LVDS_25 [get_ports {adc_out_2p[0]}]

# PORTD-11
set_property PACKAGE_PIN A4 [get_ports {adc_out_1n[1]}]
set_property PACKAGE_PIN A5 [get_ports {adc_out_1p[1]}]
set_property IOSTANDARD LVDS_25 [get_ports {adc_out_1n[1]}]

# PORTD-12
set_property PACKAGE_PIN A7 [get_ports {adc_out_2p[0]}]
set_property PACKAGE_PIN A6 [get_ports {adc_out_2n[0]}]
set_property IOSTANDARD LVDS_25 [get_ports {adc_out_2n[0]}]

# PORTD-13
set_property PACKAGE_PIN D5 [get_ports adc_sdo]
set_property IOSTANDARD LVCMOS25 [get_ports adc_sdo]

# PORTD-14
set_property IOSTANDARD LVDS_25 [get_ports {adc_out_2p[1]}]

# PORTD-15
set_property PACKAGE_PIN C4 [get_ports adc_cs_n]
set_property IOSTANDARD LVCMOS25 [get_ports adc_cs_n]

# PORTD-16
set_property PACKAGE_PIN B8 [get_ports {adc_out_2n[1]}]
set_property PACKAGE_PIN C8 [get_ports {adc_out_2p[1]}]
set_property IOSTANDARD LVDS_25 [get_ports {adc_out_2n[1]}]

# PORTD-17
set_property PACKAGE_PIN E4 [get_ports adc_sck]
set_property IOSTANDARD LVCMOS25 [get_ports adc_sck]

# PORTD-19
set_property PACKAGE_PIN E3 [get_ports adc_sdi]
set_property IOSTANDARD LVCMOS25 [get_ports adc_sdi]

# PORTD-33
set_property IOSTANDARD LVDS_25 [get_ports adc_dco_p]

# PORTD-34
set_property IOSTANDARD LVDS_25 [get_ports adc_encode_p]

# PORTD-35
set_property PACKAGE_PIN B3 [get_ports adc_dco_n]
set_property PACKAGE_PIN B4 [get_ports adc_dco_p]
set_property IOSTANDARD LVDS_25 [get_ports adc_dco_n]

# PORTD-36
set_property PACKAGE_PIN B2 [get_ports adc_encode_p]
set_property PACKAGE_PIN B1 [get_ports adc_encode_n]
set_property IOSTANDARD LVDS_25 [get_ports adc_encode_n]

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

set_false_path -from [get_ports {button[*]}]

# ADC timing constraints
create_clock -period 6.250 -name adc_dco_p -waveform {0.000 3.125} [get_ports adc_dco_p]
create_generated_clock -name adc_encode_p -source [get_pins adc_impl/adc_enc_impl/adc_enc_oddr/C] -divide_by 1 [get_ports adc_encode_p]
set_input_delay -clock [get_clocks adc_dco_p] -clock_fall -min -add_delay 1.090 [get_ports {adc_out_1n[*]}]
set_input_delay -clock [get_clocks adc_dco_p] -clock_fall -max -add_delay 2.035 [get_ports {adc_out_1n[*]}]
set_input_delay -clock [get_clocks adc_dco_p] -min -add_delay 1.090 [get_ports {adc_out_1n[*]}]
set_input_delay -clock [get_clocks adc_dco_p] -max -add_delay 2.035 [get_ports {adc_out_1n[*]}]
set_input_delay -clock [get_clocks adc_dco_p] -clock_fall -min -add_delay 1.090 [get_ports {adc_out_1p[*]}]
set_input_delay -clock [get_clocks adc_dco_p] -clock_fall -max -add_delay 2.035 [get_ports {adc_out_1p[*]}]
set_input_delay -clock [get_clocks adc_dco_p] -min -add_delay 1.090 [get_ports {adc_out_1p[*]}]
set_input_delay -clock [get_clocks adc_dco_p] -max -add_delay 2.035 [get_ports {adc_out_1p[*]}]
set_input_delay -clock [get_clocks adc_dco_p] -clock_fall -min -add_delay 1.090 [get_ports adc_fr_n]
set_input_delay -clock [get_clocks adc_dco_p] -clock_fall -max -add_delay 2.035 [get_ports adc_fr_n]
set_input_delay -clock [get_clocks adc_dco_p] -min -add_delay 1.090 [get_ports adc_fr_n]
set_input_delay -clock [get_clocks adc_dco_p] -max -add_delay 2.035 [get_ports adc_fr_n]
set_input_delay -clock [get_clocks adc_dco_p] -clock_fall -min -add_delay 1.090 [get_ports adc_fr_p]
set_input_delay -clock [get_clocks adc_dco_p] -clock_fall -max -add_delay 2.035 [get_ports adc_fr_p]
set_input_delay -clock [get_clocks adc_dco_p] -min -add_delay 1.090 [get_ports adc_fr_p]
set_input_delay -clock [get_clocks adc_dco_p] -max -add_delay 2.035 [get_ports adc_fr_p]

# Note that the adc data clock is asynchronous to the ADC output clock derived
# from the 'clk_fpga_0' signal.
set_clock_groups -name async_cam_axi -asynchronous -group {clk_fpga_0} -group {adc_data_clk} -group {clk_fpga_3}
