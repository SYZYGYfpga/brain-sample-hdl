//------------------------------------------------------------------------
// syzygy-dds.v
//
// This is just a quick and dirty example synthesizer that generates a
// basic triangle wave, covering all values of the 12-bit data bus.
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

module syzygy_dds (
	input  wire        clk,
	input  wire        reset,

	output wire [11:0] data
	);

reg [11:0] counter;
reg        count_up;
	
assign data = counter;

always @(posedge clk) begin
	if (reset == 1'b1) begin
		count_up <= 1'b1;
		counter <= 12'h0;
	end else begin
		if (count_up == 1'b1) begin
			counter <= counter + 12'd100;
		end else begin
			counter <= counter - 12'd100;
		end

		if (counter <= 12'd500) begin
			count_up <= 1'b1;
		end else if (counter >= 12'd3500) begin
			count_up <= 1'b0;
		end
	end
end

endmodule
`default_nettype wire
