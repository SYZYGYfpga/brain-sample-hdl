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
set_property IOSTANDARD LVDS_25 [get_ports {slvs_p[0]}]

# PORTA-6
set_property PACKAGE_PIN AA14 [get_ports flash]
set_property IOSTANDARD LVCMOS25 [get_ports flash]

# PORTA-7
set_property PACKAGE_PIN AB14 [get_ports {slvs_n[0]}]
set_property PACKAGE_PIN AB13 [get_ports {slvs_p[0]}]
set_property IOSTANDARD LVDS_25 [get_ports {slvs_n[0]}]

# PORTA-8
set_property PACKAGE_PIN AA15 [get_ports reset_b]
set_property IOSTANDARD LVCMOS25 [get_ports reset_b]

# PORTA-9
set_property IOSTANDARD LVDS_25 [get_ports {slvs_p[1]}]

# PORTA-10
set_property PACKAGE_PIN AB18 [get_ports trigger]
set_property IOSTANDARD LVCMOS25 [get_ports trigger]

# PORTA-11
set_property PACKAGE_PIN AB17 [get_ports {slvs_n[1]}]
set_property PACKAGE_PIN AB16 [get_ports {slvs_p[1]}]
set_property IOSTANDARD LVDS_25 [get_ports {slvs_n[1]}]

# PORTA-12
set_property PACKAGE_PIN AB19 [get_ports shutter]
set_property IOSTANDARD LVCMOS25 [get_ports shutter]

# PORTA-13
set_property IOSTANDARD LVDS_25 [get_ports {slvs_p[2]}]

# PORTA-14
set_property PACKAGE_PIN AA16 [get_ports focus_sda]
set_property IOSTANDARD LVCMOS25 [get_ports focus_sda]

# PORTA-15
set_property PACKAGE_PIN Y15 [get_ports {slvs_n[2]}]
set_property PACKAGE_PIN Y14 [get_ports {slvs_p[2]}]
set_property IOSTANDARD LVDS_25 [get_ports {slvs_n[2]}]

# PORTA-16
set_property PACKAGE_PIN AA17 [get_ports focus_scl]
set_property IOSTANDARD LVCMOS25 [get_ports focus_scl]

# PORTA-17
set_property IOSTANDARD LVDS_25 [get_ports {slvs_p[3]}]

# PORTA-18
set_property PACKAGE_PIN AB21 [get_ports focus_sdi]
set_property IOSTANDARD LVCMOS25 [get_ports focus_sdi]

# PORTA-19
set_property PACKAGE_PIN AA20 [get_ports {slvs_n[3]}]
set_property PACKAGE_PIN AA19 [get_ports {slvs_p[3]}]
set_property IOSTANDARD LVDS_25 [get_ports {slvs_n[3]}]

# PORTA-20
set_property PACKAGE_PIN AB22 [get_ports focus_sdo]
set_property IOSTANDARD LVCMOS25 [get_ports focus_sdo]

# PORTA-21
set_property PACKAGE_PIN W17 [get_ports sdata]
set_property IOSTANDARD LVCMOS25 [get_ports sdata]

# PORTA-22
set_property PACKAGE_PIN U13 [get_ports focus_sck]
set_property IOSTANDARD LVCMOS25 [get_ports focus_sck]

# PORTA-23
set_property PACKAGE_PIN V18 [get_ports sclk]
set_property IOSTANDARD LVCMOS25 [get_ports sclk]

# PORTA-24
set_property PACKAGE_PIN Y17 [get_ports focus_ss_b]
set_property IOSTANDARD LVCMOS25 [get_ports focus_ss_b]

# PORTA-25
set_property PACKAGE_PIN V13 [get_ports saddr]
set_property IOSTANDARD LVCMOS25 [get_ports saddr]

# PORTA-26
set_property PACKAGE_PIN W18 [get_ports focus_rst_b]
set_property IOSTANDARD LVCMOS25 [get_ports focus_rst_b]

# PORTA-27
set_property PACKAGE_PIN W15 [get_ports pgood]
set_property IOSTANDARD LVCMOS25 [get_ports pgood]

# PORTA-33
set_property IOSTANDARD LVDS_25 [get_ports slvsc_p]

# PORTA-34
set_property PACKAGE_PIN V16 [get_ports extclk]
set_property IOSTANDARD LVCMOS25 [get_ports extclk]

# PORTA-35
set_property PACKAGE_PIN Y19 [get_ports slvsc_n]
set_property PACKAGE_PIN Y18 [get_ports slvsc_p]
set_property IOSTANDARD LVDS_25 [get_ports slvsc_n]

# LEDs #####################################################################
set_property PACKAGE_PIN W12 [get_ports {led[0]}]
set_property PACKAGE_PIN Y12 [get_ports {led[1]}]
set_property PACKAGE_PIN AA11 [get_ports {led[2]}]
set_property PACKAGE_PIN AB11 [get_ports {led[3]}]
set_property PACKAGE_PIN W13 [get_ports {led[4]}]
set_property PACKAGE_PIN Y13 [get_ports {led[5]}]
set_property PACKAGE_PIN AA12 [get_ports {led[6]}]
set_property PACKAGE_PIN AB12 [get_ports {led[7]}]
set_property IOSTANDARD LVCMOS25 [get_ports {led[*]}]

# Buttons ##################################################################
set_property PACKAGE_PIN R17 [get_ports {button[0]}]
set_property PACKAGE_PIN T17 [get_ports {button[1]}]
set_property IOSTANDARD LVCMOS25 [get_ports {button[*]}]

set_false_path -from [get_ports {button[*]}]
set_false_path -to [get_ports {led[*]}]


create_clock -period 6.80 -name slvsc_p -waveform {0.000 3.401} [get_ports slvsc_p]
set_input_delay -clock [get_clocks slvsc_p] -clock_fall -min -add_delay 1.020 [get_ports {slvs_n[*]}]
set_input_delay -clock [get_clocks slvsc_p] -clock_fall -max -add_delay 2.381 [get_ports {slvs_n[*]}]
set_input_delay -clock [get_clocks slvsc_p] -min -add_delay 1.020 [get_ports {slvs_n[*]}]
set_input_delay -clock [get_clocks slvsc_p] -max -add_delay 2.381 [get_ports {slvs_n[*]}]
set_input_delay -clock [get_clocks slvsc_p] -clock_fall -min -add_delay 1.020 [get_ports {slvs_p[*]}]
set_input_delay -clock [get_clocks slvsc_p] -clock_fall -max -add_delay 2.381 [get_ports {slvs_p[*]}]
set_input_delay -clock [get_clocks slvsc_p] -min -add_delay 1.020 [get_ports {slvs_p[*]}]
set_input_delay -clock [get_clocks slvsc_p] -max -add_delay 2.381 [get_ports {slvs_p[*]}]

set_clock_groups -name async_cam_axi -asynchronous -group {clk_fpga_0} -group {phy_inst_n_1 camera_axis_clk}
