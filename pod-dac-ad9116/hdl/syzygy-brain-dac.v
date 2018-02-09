//------------------------------------------------------------------------
// syzygy-brain-dac.v
//
// This sample demonstrates usage of the POD-DAC-AD911X SYZYGY module from
// Opal Kelly. This sample is setup to interface with a DAC Pod connected
// on PORT A.
//
// Communication with the DAC itself is handled by the 'syzygy-dac-top'
// module. Data for the Q-channel of the DAC is fixed to a sawtooth
// waveform. The I-channel of the DAC reads data from a block RAM in the
// 'design_1' block design. This RAM can be populated by software running
// on the Zynq PS.
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

module syzygy_brain_dac (
	inout  wire [14:0] DDR_addr,
	inout  wire  [2:0] DDR_ba,
	inout  wire        DDR_cas_n,
    inout  wire        DDR_ck_n,
    inout  wire        DDR_ck_p,
    inout  wire        DDR_cke,
    inout  wire        DDR_cs_n,
    inout  wire  [3:0] DDR_dm,
    inout  wire [31:0] DDR_dq,
    inout  wire  [3:0] DDR_dqs_n,
    inout  wire  [3:0] DDR_dqs_p,
    inout  wire        DDR_odt,
    inout  wire        DDR_ras_n,
    inout  wire        DDR_reset_n,
    inout  wire        DDR_we_n,
    inout  wire        FIXED_IO_ddr_vrn,
    inout  wire        FIXED_IO_ddr_vrp,
    inout  wire [53:0] FIXED_IO_mio,
    inout  wire        FIXED_IO_ps_clk,
    inout  wire        FIXED_IO_ps_porb,
    inout  wire        FIXED_IO_ps_srstb,
    
    // AD9116 DAC signals
    output wire [11:0] dac_data, // DAC I/Q data
    output wire        dac_clk,
    output wire        dac_reset_pinmd,
    output wire        dac_sclk, // DAC SPI clk
    inout  wire        dac_sdio, // DAC SPI data I/o
    output wire        dac_cs_n, // DAC SPI Chip Select
    
    output wire        dac_opamp_en,
	
	output wire [7:0]  led,
	input  wire [1:0]  button
	);

wire        clk;
wire        sw_reset;
wire [31:0] gpio_2;

reg  [31:0] count;

wire [31:0] dds_addr;
wire [31:0] dds_data;
wire [15:0] dds_rate;
wire [15:0] dac_fsadj;

assign led = count[31:24];

assign sw_reset = gpio_2[0];

assign dac_opamp_en = 1'b1;

always @(posedge clk) begin
	count <= count + 1'b1;
end

syzygy_dac_top dac_top(
	.clk         (clk),
	.reset_async ((~button[0]) || sw_reset),
	
	// Configuration signals
	.dds_addr (dds_addr),
	.dds_data (dds_data),
	.dds_rate (dds_rate),
	.dac_fsadj (dac_fsadj),
	
	// PHY signals
	.dac_data (dac_data),
	.dac_clk (dac_clk),
	.dac_reset_pinmd (dac_reset_pinmd),
	.dac_sclk (dac_sclk),
	.dac_sdio (dac_sdio),
	.dac_cs_n (dac_cs_n)
	);

design_1_wrapper design_1_i
       (.DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .BRAM_PORTB_0_addr (dds_addr),
        .BRAM_PORTB_0_clk  (clk),
        .BRAM_PORTB_0_din  (),
        .BRAM_PORTB_0_dout (dds_data),
        .BRAM_PORTB_0_en   (1'b1),
        .BRAM_PORTB_0_rst  (1'b0),
        .BRAM_PORTB_0_we   (1'b0),
        .gpio_rtl_0_tri_o(dds_rate),
        .gpio_rtl_1_tri_o(dac_fsadj),
        .gpio_rtl_2_tri_o(gpio_2),
        .clk_out (clk));

endmodule
`default_nettype wire
