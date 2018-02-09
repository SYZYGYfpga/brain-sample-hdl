//------------------------------------------------------------------------
// syzygy-adc-tb.v
//
// Basic testbench for simulating the SYZYGY ADC design. This simulation
// simply applies a basic sawtooth waveform to the LVDS ADC inputs while
// toggling the clock and reset lines of the design, all verification
// must be done manually through inspecting the resulting waveforms.
// 
//------------------------------------------------------------------------
// Copyright (c) 2018 Opal Kelly Incorporated
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
`timescale 1ns/1ps

module syzygy_adc_tb ();

reg clk, reset;
reg idelay_ref;

wire [15:0] adc_data_1, adc_data_2;
wire [1:0]  adc_out_1p, adc_out_1n, adc_out_2p, adc_out_2n;
wire        adc_dco_p, adc_dco_n, adc_fr_p, adc_fr_n;
wire        adc_encode_p, adc_encode_n;
wire        adc_sdo, adc_sdi, adc_cs_n, adc_sck;
wire        data_valid;

`define T_Clk 12.5 // 25ns clock period (40 MHz)
`define T_IDELAY_REF 2.5

// clock generation
initial begin
	clk = 0;
	forever begin
		#(`T_Clk) clk = 1'b1;
		#(`T_Clk) clk = 1'b0;
	end
end

// IDELAY Reference clock generation (200MHz)
initial begin
	idelay_ref = 0;
	forever begin
		#(`T_IDELAY_REF) idelay_ref = 1'b1;
		#(`T_IDELAY_REF) idelay_ref = 1'b0;
	end
end

// Reset
initial begin
	reset = 1;

	@(posedge clk);
	@(posedge clk);
	@(posedge clk) reset = 0;
end

syzygy_adc_top dut (
	.clk          (clk),
	.idelay_ref   (idelay_ref),
	.reset_async  (reset),

	.adc_out_1p   (adc_out_1p),
	.adc_out_1n   (adc_out_1n),
	.adc_out_2p   (adc_out_2p),
	.adc_out_2n   (adc_out_2n),
	.adc_dco_p    (adc_dco_p),
	.adc_dco_n    (adc_dco_n),
	.adc_fr_p     (adc_fr_p),
	.adc_fr_n     (adc_fr_n),
	.adc_encode_p (adc_encode_p),
	.adc_encode_n (adc_encode_n),

	.adc_sdo      (adc_sdo),
	.adc_sdi      (adc_sdi),
	.adc_cs_n     (adc_cs_n),
	.adc_sck      (adc_sck),

	.adc_data_1   (adc_data_1),
	.adc_data_2   (adc_data_2),
	.data_valid   (data_valid)
);

adc_data_gen #(
	.T_Clk (`T_Clk)
) data_gen (
	.encode (adc_encode_p),

	.adc_out_1p (adc_out_1p),
	.adc_out_1n (adc_out_1n),
	.adc_out_2p (adc_out_2p),
	.adc_out_2n (adc_out_2n),
	.adc_dco_p  (adc_dco_p),
	.adc_dco_n  (adc_dco_n),
	.adc_fr_p   (adc_fr_p),
	.adc_fr_n   (adc_fr_n)
);

endmodule
`default_nettype wire

