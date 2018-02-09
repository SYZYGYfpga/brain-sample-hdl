# Syzygy Brain-1 ADC Sample

## Overview

This sample project is designed to demonstrate usage of the POD-ADC-LTC2264-12
SYZYGY module from Opal Kelly. This sample is designed to interface with the
peripheral connected to PORT D on the Brain-1.

Both analog inputs on the ADC peripheral are deserialized by a PHY in the PL
portion of the Zynq. The raw data from the PHY is passed into an AXI4 Stream
bus that enters the block design. The AXI Stream bus passes through an AXI
FIFO buffer before finally feeding into PS memory through a DMA transfer.
An AXI4 DMA core from Xilinx is used to control the DMA transfer. Registers
in the DMA core must be set by the PS to enable and start the transfer.

This project is based heavily on Xilinx Application Note 524 (XAPP524) and
implements a simplified version of the design described by Xilinx.
