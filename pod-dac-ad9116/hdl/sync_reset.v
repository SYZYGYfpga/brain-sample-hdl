`timescale 1ns/1ps

module sync_reset(
 input  wire   clk,
 input  wire   async_reset,
 output wire   sync_reset
 );


reg   async_d;
reg   async_dd;
always @(posedge clk) begin
 async_d  <= async_reset;
 async_dd <= async_d;
end

assign sync_reset = async_dd | async_reset;

endmodule