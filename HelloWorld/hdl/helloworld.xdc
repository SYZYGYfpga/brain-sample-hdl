############################################################################
# SYZYGY Brain-1 - Xilinx constraints file
#
# Pin mappings for the SYZYGY Brain-1.  Use this as a template and comment out 
# the pins that are not used in your design.  (By default, map will fail
# if this file contains constraints for signals not in your design).
#
############################################################################
# Copyright (c) 2017 Opal Kelly Incorporated
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# 
############################################################################

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS True [current_design]

set_property PACKAGE_PIN W12  [get_ports {led[0]}]
set_property PACKAGE_PIN Y12  [get_ports {led[1]}]
set_property PACKAGE_PIN AA11 [get_ports {led[2]}]
set_property PACKAGE_PIN AB11 [get_ports {led[3]}]
set_property PACKAGE_PIN W13  [get_ports {led[4]}]
set_property PACKAGE_PIN Y13  [get_ports {led[5]}]
set_property PACKAGE_PIN AA12 [get_ports {led[6]}]
set_property PACKAGE_PIN AB12 [get_ports {led[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]

set_property PACKAGE_PIN R17 [get_ports {button[0]}]
set_property PACKAGE_PIN T17 [get_ports {button[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {button[*]}]
