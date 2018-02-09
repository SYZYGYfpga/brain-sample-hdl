//------------------------------------------------------------------------
// syzygy-brain-camera.v
//
// Top level module to interface the SYZYGY Brain-1 with the SYZYGY Camera
// Pod.
//
// Image data from the camera is captured by the camera_top module and
// converted into raw binary pixel data sent along a parallel bus. This
// data is then fed into a DMA in the 'design_1' block design used to
// write to the Zynq PS DRAM. This data can then be read out by software
// running on the PS.
//
// I2C communication with the camera is handled by passing through a Zynq
// PS I2C bus to the camera pins using the EMIO feature of the Zynq. All
// I2C communication is therefore handled by software on the PS.
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

module syzygy_brain_camera (
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

	input  wire [3:0]          slvs_p,
	input  wire [3:0]          slvs_n,
	input  wire                slvsc_p,
	input  wire                slvsc_n,
	output wire                extclk,
	input  wire                flash,
	output wire                reset_b,
	output wire                trigger,
	input  wire                shutter,
	inout  wire                sdata,
	inout  wire                sclk,
	output wire                saddr,
	input  wire                pgood,

	inout  wire                focus_sda,
	output wire                focus_scl,
	output wire                focus_sdi,
	input  wire                focus_sdo,
	output wire                focus_sck,
	output wire                focus_ss_b,
	output wire                focus_rst_b,
	
	output wire [7:0]          led,
	input  wire [1:0]          button
	);

wire        clk, idelay_clk;
wire        idelay_rdy;
reg         reset_idelay;
reg  [31:0] reset_idelay_cnt;
wire        reset_sw, reset_cam_sw;

wire [7:0]  num_frames, sync_error_count;
wire        sync_error;

wire        start_capture;
wire        capture_done;	
wire [31:0] camera_axis_data;
wire        camera_axis_valid, camera_axis_clk, camera_axis_tlast;

assign led = {sync_error, num_frames[6:0]};

//assign frame_error = (frame_error_count > 0) ? 1'b1 : 1'b0;
assign sync_error  = (sync_error_count > 0) ? 1'b1 : 1'b0;

assign focus_sda = 1'b1;
assign focus_scl = 1'b1;
assign focus_sdi = 1'b1;
assign focus_sdo = 1'b1;
assign focus_sck = 1'b1;
assign focus_ss_b = 1'b1;
assign focus_rst_b = 1'b1;
assign saddr = 1'b1;
assign trigger = 1'b0;
assign reset_b = button[1] | ~reset_cam_sw;

syzygy_camera_top camera_top (
	.slvs_p  (slvs_p),
	.slvs_n  (slvs_n),
	.slvsc_p (slvsc_p),
	.slvsc_n (slvsc_n),
	.reset_b (),

	.clk     (camera_axis_clk),
	.reset_async ((~button[0]) || reset_sw),

	.start_capture (start_capture),
	.capture_done  (capture_done),
	.axis_data     (camera_axis_data),
	.axis_valid    (camera_axis_valid),

	.num_frames        (num_frames),
	.sync_error_count  (sync_error_count)
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
		.S_AXIS_0_tdata(camera_axis_data),
		//.SAXIS_0_tready(camera_axis_ready),
		.S_AXIS_0_tvalid(camera_axis_valid),
		.S_AXIS_0_tlast(1'b0),
		//.axis_wr_data_count_0(wr_data_count),
		.clk_out_150(),
		.clk_out_200 (idelay_clk),
		.clk_out_24  (extclk),
		.IIC_0_0_scl_io (sclk),
		.IIC_0_0_sda_io (sdata),
		.GPIO_0_tri_i ({capture_done, num_frames, sync_error_count}),
		.GPIO2_0_tri_o ({reset_cam_sw, reset_sw, start_capture}),
		.s_axis_aclk_0(camera_axis_clk),
		.s_axis_aresetn_0((~button[0]) || reset_sw));
		
// IDELAYCTRL reset, must be asserted for T_IDELAYCTRL_RPW (60ns)
// Must be asserted after configuration
// With a 200MHz input this must be held for 12 cycles minimum
always @(posedge idelay_clk) begin
	if((button[0] == 1'b0) || (reset_sw == 1'b1)) begin
		reset_idelay <= 1'b1;
		reset_idelay_cnt <= 8'h10;
	end else begin
		if (reset_idelay_cnt > 8'h00) begin
			reset_idelay_cnt <= reset_idelay_cnt - 1'b1;
			reset_idelay <= 1'b1;
		end else begin
			reset_idelay <= 1'b0;
		end
	end
end

IDELAYCTRL idelay_adc (
			.RST    (reset_idelay),
			.REFCLK (idelay_clk),
			.RDY    (idelay_rdy)
		);

endmodule
`default_nettype wire
