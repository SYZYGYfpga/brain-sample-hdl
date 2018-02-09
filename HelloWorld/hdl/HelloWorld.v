//------------------------------------------------------------------------
// HelloWorld.v
//
// Simple Hello world sample for the SYZYGY Brain-1 board.
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

module HelloWorld (
	// Zynq required connections
	inout wire [14:0]          DDR_addr,
	inout wire  [2:0]          DDR_ba,
	inout wire                 DDR_cas_n,
    inout wire                 DDR_ck_n,
    inout wire                 DDR_ck_p,
    inout wire                 DDR_cke,
    inout wire                 DDR_cs_n,
    inout wire  [3:0]          DDR_dm,
    inout wire [31:0]          DDR_dq,
    inout wire  [3:0]          DDR_dqs_n,
    inout wire  [3:0]          DDR_dqs_p,
    inout wire                 DDR_odt,
    inout wire                 DDR_ras_n,
    inout wire                 DDR_reset_n,
    inout wire                 DDR_we_n,
    inout wire                 FIXED_IO_ddr_vrn,
    inout wire                 FIXED_IO_ddr_vrp,
    inout wire [53:0]          FIXED_IO_mio,
    inout wire                 FIXED_IO_ps_clk,
    inout wire                 FIXED_IO_ps_porb,
    inout wire                 FIXED_IO_ps_srstb,
	
	// Sample connections
	output wire [7:0]          led,
	input  wire [1:0]          button
	);

wire        clk;
reg  [31:0] count;

assign led = {^button,count[31:25]};

always @(posedge clk) begin
	count <= count + 1'b1;
end

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
        .clk_out (clk));

endmodule
`default_nettype wire
