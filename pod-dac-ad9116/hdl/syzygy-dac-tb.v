//------------------------------------------------------------------------
// syzygy-dac-tb.v
//
// Basic testbench for simulating the SYZYGY DAC design. This simulation
// simply applies a clock and toggles the reset line to the design, all
// verification must be done manually through inspecting the resulting
// waveforms.
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

module syzygy_dac_tb ();

reg clk, reset;

wire [11:0] dac_data;
wire        dac_clk, dac_reset_pinmd, dac_sclk, dac_sdio, dac_cs_n;


`define T_Clk 8 // 8ns clock period (125 MHz)

// clock generation
initial begin
	clk = 0;
	forever begin
		#(`T_Clk) clk = 1'b1;
		#(`T_Clk) clk = 1'b0;
	end
end

// Reset
initial begin
	reset = 1;

	@(posedge clk);
	@(posedge clk);
	@(posedge clk) reset = 0;
end

syzygy_dac_top dut (
	.dds_addr        (),
	.dds_data        (32'h0),
	.dds_rate        (16'h1),
	
	.dac_fsadj       (16'h0),
	
	.dac_data        (dac_data),
	.dac_clk         (dac_clk),
	.dac_reset_pinmd (dac_reset_pinmd),
	.dac_sclk        (dac_sclk),
	.dac_sdio        (dac_sdio),
	.dac_cs_n        (dac_cs_n),
	.reset_async     (reset),
	.clk             (clk)
);

endmodule
`default_nettype wire
