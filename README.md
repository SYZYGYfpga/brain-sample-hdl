# SYZYGY Brain 1 HDL Samples

## Overview

These sample projects demonstrate usage of the SYZYGY Brain-1 with some of the
initial peripherals offered during the
[Crowd Supply](https://www.crowdsupply.com/opal-kelly/syzygy-brain-1) campaign.

The samples are not intended as full-fledged applications, but instead simple
demonstrations to get users up and running with SYZYGY peripherals and the
Brain-1 relatively quickly.

The physical interfaces provided can also be used in other projects including
the peripherals.

## Simulation

A simple simulation of each design can be performed using the (project)-tb.v
Verilog testbench file.

Note that these simulations are not intended as to be full simulation and
verification suites, the user must confirm that the data output from the
simulation matches the expected values. These simulations are provided as-is
and their accuracy is not guaranteed.

## Building

To build each sample design, start a new Vivado project with the
xc7z012s-1clg485 part selected and add the sources in the HDL folder to the
project. The "design\_1.bd" file can be added as an IP.

A wrapper for the block design must be generated before the project can be
built. This can be accomplished by right clicking on the block design in the
"Design Sources" view and selecting the "Generate HDL Wrapper" option.

With the project created and sources added, simply click the "Generate
Bitstream" button in the Vivado Flow Navigator to build a bitstream.
The result can be found in the Vivado project folder under:

`(project name).runs/impl_1/(project name).bit`

## Software

Accompanying software for each sample can be found in the
[brain-fs](https://github.com/SYZYGYfpga/brain-fs) repository on Github.

Linux software is available for the following samples, in the formats specified.

- DAC: Python-CGI web interface, C, Python
- ADC: Python-CGI web interface, C
- Camera: Python-CGI web interface, C
