# SYZYGY Brain-1 Camera Sample

## Overview

This project is a simple demo for the POD-CAMERA peripheral and the SYZYGY
Brain 1 carrier.

This demo implements a physical interface to the camera that is used to 
constantly retrieve pixel and frame information from the camera.

The raw data from the PHY passes through an AXI 4 Stream interface into
the block design. In the block design, the AXI data passes through an AXI
FIFO IP and into an AXI DMA to be written to the DRAM attached to the Zynq PS.

Software on the Zynq PS controls a trigger to grab a frame of data and write
it to DRAM. Once in DRAM, software on the PS can be used to manipulate
and save the image data to a file.
