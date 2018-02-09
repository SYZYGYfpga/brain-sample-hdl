//------------------------------------------------------------------------
// syzygy-dac-top.v
//
// This is the top level module for the SYZYGY DAC Pod sample. This module
// contains the DAC DDS, PHY, and controller. It is currently set up to
// output a user provided waveform on the 'I' channel (provided through
// the PS interface) and a fixed ramp waveform on the 'Q' channel.
// 
//------------------------------------------------------------------------
// Copyright (c) 2017 Opal Kelly Incorporated
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//------------------------------------------------------------------------

`default_nettype none

module syzygy_dac_top (
	input  wire        reset_async,
	
	output wire [31:0] dds_addr,
	input  wire [31:0] dds_data,
	input  wire [15:0] dds_rate,
	
	input  wire [15:0] dac_fsadj,

    output wire [11:0] dac_data, // DAC I/Q data
    output wire        dac_clk,
    output wire        dac_reset_pinmd,
    output wire        dac_sclk, // DAC SPI clk
    inout  wire        dac_sdio, // DAC SPI data I/o
    output wire        dac_cs_n, // DAC SPI Chip Select

	input  wire        clk
	);

// Datapath
wire [11:0] dac_data_i, dac_data_q;
	
// SPI portion
wire [5:0] spi_reg;
wire [7:0] spi_data_in, spi_data_out;
wire       spi_send, spi_done, spi_rw;

wire       dac_ready;
wire       reset_sync, reset;

assign reset = reset_sync | ~dac_ready;


sync_reset dac_reset_sync (
	.clk         (clk),
	.async_reset (reset_async),
	.sync_reset  (reset_sync)
);

syzygy_dds_mem #(
	.MEM_SIZE_BITS (12)
) dds_i (
	.clk   (clk),
	.reset (reset),
	
	.rate     (dds_rate),
	.mem_addr (dds_addr),
	.mem_data (dds_data),
	
	.data  (dac_data_i)
);

syzygy_dds dds_q (
	.clk   (clk),
	.reset (reset),
	.data  (dac_data_q)
);

syzygy_dac_phy dac_phy_impl (
	.clk      (clk),
	.reset    (reset_async),

	.data_i   (dac_data_i),
	.data_q   (dac_data_q),
	
	.dac_data (dac_data),
	.dac_clk  (dac_clk)
);

syzygy_dac_spi dac_spi (
	.clk          (clk),
	.reset        (reset_sync),

	.dac_sclk     (dac_sclk),
	.dac_sdio     (dac_sdio),
	.dac_cs_n     (dac_cs_n),
	.dac_reset    (dac_reset_pinmd),

	.spi_reg      (spi_reg),      // DAC SPI register address
	.spi_data_in  (spi_data_in),  // data to DAC
	.spi_data_out (spi_data_out), // data from DAC (unused here)
	.spi_send     (spi_send),     // send command
	.spi_done     (spi_done),     // command is complete, data_out valid
	.spi_rw       (spi_rw)        // read or write
);

syzygy_dac_controller dac_control (
	.clk         (clk),
	.reset       (reset_sync),
	
	.dac_fsadj   (dac_fsadj),

	.spi_reg     (spi_reg),
	.spi_data_in (spi_data_in),
	.spi_send    (spi_send),
	.spi_done    (spi_done),
	.spi_rw      (spi_rw),

	.dac_ready   (dac_ready)
);

endmodule
`default_nettype wire
