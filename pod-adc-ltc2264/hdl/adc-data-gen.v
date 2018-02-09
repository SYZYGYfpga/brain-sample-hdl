//------------------------------------------------------------------------
// adc-data-gen.v
//
// Data generator for simulations of the SYZYGY ADC Pod.
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

module adc_data_gen (
	input  wire       encode,

	output reg  [1:0] adc_out_1p,
	output wire [1:0] adc_out_1n,
	output reg  [1:0] adc_out_2p,
	output wire [1:0] adc_out_2n,

	output reg        adc_dco_p,
	output wire       adc_dco_n,
	output reg        adc_fr_p,
	output wire       adc_fr_n
	);

parameter T_Clk = 25;
parameter T_SER = T_Clk / 4.0; // Serial bitrate is 8x sample rate
parameter T_PD = 1.1 + T_SER;

reg  [11:0] adc_signal = 12'h000;
reg  [11:0] adc_signal_output;
reg  [8:0] adc_count = 12'h000;

reg  adc_dco_int;

assign adc_out_1n = ~adc_out_1p;
assign adc_out_2n = ~adc_out_2p;
assign adc_dco_n = ~adc_dco_p;
assign adc_fr_n = ~adc_fr_p;

initial begin
	adc_dco_p = 0;
	adc_dco_int = 0;

	#(T_PD);
	forever begin
		#(T_SER) adc_dco_int = 1'b1;
		#(T_SER) adc_dco_int = 1'b0;
	end

end

initial begin
	forever begin
		#(T_SER/2) adc_dco_p = adc_dco_int;
	end
end

initial begin
	adc_fr_p = 0;

	#(T_PD);
	adc_fr_p = 1'b1;
	forever begin
		#(T_Clk) adc_fr_p = 1'b0;
		#(T_Clk) adc_fr_p = 1'b1;
	end
end

always @(posedge encode) begin
	adc_signal <= adc_signal + 1'b1;
end

always @(posedge adc_dco_int or negedge adc_dco_int) begin
	adc_count <= adc_count - 1'b1;

	if(adc_count == 8'h0) begin
		adc_count <= 8'h7;
	end
end

always @(*) begin
	if(adc_count > 8'h1) begin
		adc_out_1p[0] = adc_signal_output[(2*(adc_count - 1)) - 1];
		adc_out_1p[1] = adc_signal_output[(2*(adc_count - 1)) - 2];
		adc_out_2p[0] = ~adc_signal_output[(2*(adc_count - 1)) - 1];
		adc_out_2p[1] = ~adc_signal_output[(2*(adc_count - 1)) - 2];
	end else begin
		adc_out_1p = 2'b00;
		adc_out_2p = 2'b00;
	end
end

always @(posedge adc_fr_p) begin
	adc_signal_output <= adc_signal;
end

endmodule
`default_nettype wire

