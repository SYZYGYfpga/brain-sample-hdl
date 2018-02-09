//------------------------------------------------------------------------
// syzygy-dds-mem.v
//
// This module will read in data from a BRAM generator module and output
// a data signal for a DAC channel. The BRAM has a 32-bit data interface
// which is split into two 16-bit interfaces each truncated to 12-bits.
// This means that the usable depth of the BRAM is essentially double the
// depth setting on the BRAM.
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

module syzygy_dds_mem (
	input  wire        clk,
	input  wire        reset,

	// BRAM interface
	input  wire [15:0] rate,
	output wire [31:0] mem_addr,
	input  wire [31:0] mem_data,

	// DAC data stream
	output wire [11:0] data
	);

parameter MEM_SIZE_BITS = 12;

reg [MEM_SIZE_BITS:0] addr_counter;

assign mem_addr[31:14] = 0;
assign mem_addr[13:2] = addr_counter[MEM_SIZE_BITS:1];
assign mem_addr[1:0] = 0;
assign data = addr_counter[0] ? mem_data[27:16] : mem_data[11:0];

always @(posedge clk) begin
	if (reset == 1'b1) begin
		addr_counter <= 12'h0;
	end else begin
		addr_counter <= addr_counter + rate;
		
		if (addr_counter[MEM_SIZE_BITS:1] == 2**MEM_SIZE_BITS - 2) begin
			addr_counter <= 12'h0;
		end
	end
end

endmodule
`default_nettype wire
