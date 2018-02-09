//------------------------------------------------------------------------
// syzygy-camera-top.v
//
// This module glues the camera PHY module to an AXI stream port.
//
// When a request is made by toggling the 'start_capture' signal, data is
// fed through the AXIS port starting with the next valid frame.
//
// A 'capture_done' register is used to signal when the capture has
// completed.
//
// To more easily interface with a 32-bit AXIS FIFO, the 10-bit image 
// sensor data is truncated to 8-bits, losing some resolution.
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

module syzygy_camera_top (
	output wire        clk, // derived from hispi clock
	input  wire        reset_async,

	input  wire        start_capture,
	output reg         capture_done,

	input  wire [3:0]  slvs_p,
	input  wire [3:0]  slvs_n,
	input  wire        slvsc_p,
	input  wire        slvsc_n,
	output wire        reset_b,

	output wire [31:0] axis_data,
	output wire        axis_valid,

	output reg  [7:0]  num_frames,

	output reg  [7:0]  sync_error_count
);

wire        reset_sync;

wire frame_start, line_start, line_end, frame_end;
wire sync_error, line_valid;

wire [39:0] pix_data;

reg         start_capture_sticky, frame_capture;
reg  [1:0]  start_capture_sync;

// clip data to 8 bits per pixel for now, for easier interfacing with FIFOs
assign axis_data = {pix_data[39:32], pix_data[29:22], pix_data[19:12], pix_data[9:2]};

assign axis_valid = line_valid & frame_capture;


reg [31:0] capture_state;
localparam s_wait_frame   = 0,
           s_frame_active = 1;
always @(posedge clk) begin
	if (reset_sync == 1'b1) begin
		capture_done <= 1'b0;
		frame_capture <= 1'b0;
		start_capture_sync <= 2'b00;
		num_frames <= 8'h00;
		sync_error_count <= 32'h00;
		capture_state <= s_wait_frame;
	end else begin
		if (sync_error == 1'b1) begin
			sync_error_count <= sync_error_count + 1'b1;
		end

		if (frame_start == 1'b1) begin
			num_frames <= num_frames + 1'b1;
		end

		start_capture_sync = {start_capture_sync[0], start_capture};

		if (start_capture_sync == 2'b10 && start_capture_sticky == 1'b0) begin
			start_capture_sticky <= 1'b1;
			capture_done <= 1'b0;
		end

		case (capture_state)
			s_wait_frame: begin
				if (frame_start == 1'b1 && start_capture_sticky == 1'b1) begin
					start_capture_sticky <= 1'b0;
					capture_state <= s_frame_active;
					frame_capture <= 1'b1;
				end
			end

			s_frame_active: begin
				if (frame_end) begin
					capture_state <= s_wait_frame;
					frame_capture <= 1'b0;
					capture_done <= 1'b1;
				end
			end
		endcase
	end
end


syzygy_camera_phy phy_inst (
	.clk (clk),
	.reset_async (reset_async),
	.reset_sync (reset_sync),

	.slvs_p (slvs_p),
	.slvs_n (slvs_n),
	.slvsc_p (slvsc_p),
	.slvsc_n (slvsc_n),
	.reset_b (reset_b),

	.pix_data (pix_data),
	.sync_sof (frame_start),
	.sync_sol (line_start),
	.sync_eol (line_end),
	.sync_eof (frame_end),
	.sync_error (sync_error),
	.line_valid (line_valid)
);

endmodule
`default_nettype wire
