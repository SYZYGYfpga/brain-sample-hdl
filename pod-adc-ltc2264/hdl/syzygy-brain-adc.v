//------------------------------------------------------------------------
// syzygy-brain-adc.v
//
// This sample desmonstrates usage of the POD-ADC-LTC226x SYZYGY module
// from Opal Kelly. This sample is setup to interface with an ADC Pod
// connected on PORT D.
//
// Communication with the ADC itself is handled by the syzygy-adc-top
// module which returns parallel data from each of the ADC channels. This
// data is then fed into a FIFO and DMA through to the Zynq DRAM as part
// of the block design 'design_1'.
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

module syzygy_brain_adc (
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

	// ADC Pod Pins
	input  wire [1:0]          adc_out_1p, // Channel 1 data
	input  wire [1:0]          adc_out_1n,
	input  wire [1:0]          adc_out_2p, // Channel 2 data
	input  wire [1:0]          adc_out_2n,
	input  wire                adc_dco_p,      // ADC Data clock
	input  wire                adc_dco_n,
	input  wire                adc_fr_p,       // Frame input
	input  wire                adc_fr_n,
	output wire                adc_encode_p,   // ADC Encode Clock
	output wire                adc_encode_n,
	input  wire                adc_sdo,
	output wire                adc_sdi,
	output wire                adc_cs_n,
	output wire                adc_sck,
	
	output wire [7:0]          led,
	input  wire [1:0]          button
	);
	
parameter DMA_LENGTH_WORDS = (1024 * 1024) / 4; // 1 MiB with 4-byte words

wire        adc_clk, idelay_ref;
wire [1:0]  overflow1, overflow2;
reg  [31:0] count;

wire [15:0] adc_data_out1, adc_data_out2;
wire        reset_bus_sync;
wire        adc_data_clk, adc_data_valid, idelay_rdy;

reg  [31:0] dma_counter;
reg         adc_transmit;
reg         adc_tlast;
wire        start_transfer, reset_sw;
reg   [1:0] start_transfer_reg;

assign led = {idelay_rdy, adc_data_valid, ~button, overflow1, overflow2};

assign overflow1 = adc_data_out1[3:2];
assign overflow2 = adc_data_out2[3:2];

syzygy_adc_top adc_impl(
	.clk          (adc_clk),
	.idelay_ref   (idelay_ref),
	.reset_async  ((~button[0]) || reset_sw),
	
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
	
	.adc_data_clk (adc_data_clk),
	.adc_data_1   (adc_data_out1),
	.adc_data_2   (adc_data_out2),
	.data_valid   (adc_data_valid),
	.idelay_rdy   (idelay_rdy)
);

always @ (posedge adc_data_clk)
begin
	if ((button[0] == 1'b0) || (reset_sw == 1'b1)) begin
		dma_counter  <= 32'h0;
		adc_tlast    <= 1'b0;
		adc_transmit <= 1'b0;
	end else begin
		adc_tlast    <= 1'b0;
		start_transfer_reg[0] <= start_transfer;
		start_transfer_reg[1] <= start_transfer_reg[0];
		
		if(start_transfer_reg == 2'b10) begin
			dma_counter  <= 32'h0;
			adc_transmit <= 1'b1;
		end
		
		if (adc_transmit == 1'b1) begin
			dma_counter  <= dma_counter + 1'b1;
		
			if (dma_counter == DMA_LENGTH_WORDS - 32'h1) begin
				dma_counter <= dma_counter;
				adc_transmit <= 1'b0;
			end else if (dma_counter == DMA_LENGTH_WORDS - 32'h2) begin
				adc_tlast <= 1'b1;
			end
		end
	end
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
        .S_AXIS_0_tdata ({adc_data_out2, adc_data_out1}),
        .S_AXIS_0_tlast (adc_tlast),
        .S_AXIS_0_tvalid (adc_data_valid & adc_transmit),
        .ADC_data_clk (adc_data_clk),
        .ADC_axis_reset ((~button[0]) || reset_sw),
        .gpio_rtl_0_tri_o ({reset_sw, start_transfer}),
        .clk_out_40  (adc_clk),
        .clk_out_200 (idelay_ref));

endmodule
`default_nettype wire
