# Syzygy Brain-1 DAC Sample

## Overview

This sample project is designed to demonstrate usage of the POD-DAC-AD911X
SYZYGY module from Opal Kelly. This sample is designed to interface with the
pod connected to PORT A on the Brain-1.

Data for each DAC analog output is generated on the FPGA. This data is then
fed through a simple PHY interface to meet the I/O requirements of the DAC.

A SPI interface and controller are also included to set configuration registers
on the DAC.

The Q output of the DAC will output a continuous triangle wave. The I output
of the DAC can be configured to output an arbitrary waveform by programming
its waveform memory from the PS of the Zynq.

Software to interact with the DAC memory can be found in the
[brain-fs](https://github.com/SYZYGYfpga/brain-fs) repository.
