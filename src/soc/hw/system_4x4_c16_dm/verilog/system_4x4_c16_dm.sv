/* Copyright (c) 2012-2016 by the author(s)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * =============================================================================
 *
 * A 3x3 distributed memory system with 16 compute tiles (C16)
 *
 * Author(s):
 *   Stefan Wallentowitz <stefan.wallentowitz@tum.de>
 * 		Harsha Chenji (chenji@ohio.edu)
 *       Marcelo Morales (mm5157516@ohio.edu)
 */

module system_4x4_c16_dm(
   input clk, rst,

   glip_channel c_glip_in,
   glip_channel c_glip_out,

   output [16*32-1:0] wb_ext_adr_i,
   output [16*1-1:0]  wb_ext_cyc_i,
   output [16*32-1:0] wb_ext_dat_i,
   output [16*4-1:0]  wb_ext_sel_i,
   output [16*1-1:0]  wb_ext_stb_i,
   output [16*1-1:0]  wb_ext_we_i,
   output [16*1-1:0]  wb_ext_cab_i,
   output [16*3-1:0]  wb_ext_cti_i,
   output [16*2-1:0]  wb_ext_bte_i,
   input  [16*1-1:0]   wb_ext_ack_o,
   input  [16*1-1:0]   wb_ext_rty_o,
   input  [16*1-1:0]   wb_ext_err_o,
   input  [16*32-1:0]  wb_ext_dat_o
   );

   import dii_package::dii_flit;
   import optimsoc_config::*;

   parameter config_t CONFIG = 'x;

   dii_flit [1:0] debug_ring_in [0:15];
   dii_flit [1:0] debug_ring_out [0:15];
   logic [1:0] debug_ring_in_ready [0:15];
   logic [1:0] debug_ring_out_ready [0:15];

   logic       rst_sys, rst_cpu;

   debug_interface
      #(
         .SYSTEM_VENDOR_ID (2),
         .SYSTEM_DEVICE_ID (2),
         .NUM_MODULES (CONFIG.DEBUG_NUM_MODS),
         .MAX_PKT_LEN(CONFIG.DEBUG_MAX_PKT_LEN),
         .SUBNET_BITS(CONFIG.DEBUG_SUBNET_BITS),
         .LOCAL_SUBNET(CONFIG.DEBUG_LOCAL_SUBNET),
         .DEBUG_ROUTER_BUFFER_SIZE(CONFIG.DEBUG_ROUTER_BUFFER_SIZE)
      )
      u_debuginterface
        (
         .clk            (clk),
         .rst            (rst),
         .sys_rst        (rst_sys),
         .cpu_rst        (rst_cpu),
         .glip_in        (c_glip_in),
         .glip_out       (c_glip_out),
         .ring_out       (debug_ring_in[0]), // TODO: figure out debug interface
         .ring_out_ready (debug_ring_in_ready[0]),
         .ring_in        (debug_ring_out[15]),
         .ring_in_ready  (debug_ring_out_ready[15])
      );

	// TODO: extend this to 16 cores, meander across rows/cols
   // We are routing the debug in a meander
	assign debug_ring_in[1] = debug_ring_out[0];
	assign debug_ring_in[2] = debug_ring_out[1];
	assign debug_ring_in[3] = debug_ring_out[2];
	assign debug_ring_in[4] = debug_ring_out[3];
	assign debug_ring_in[5] = debug_ring_out[4];
	assign debug_ring_in[6] = debug_ring_out[5];
	assign debug_ring_in[7] = debug_ring_out[6];
	assign debug_ring_in[8] = debug_ring_out[7];
	assign debug_ring_in[9] = debug_ring_out[8];
	assign debug_ring_in[10] = debug_ring_out[9];
	assign debug_ring_in[11] = debug_ring_out[10];
	assign debug_ring_in[12] = debug_ring_out[11];
	assign debug_ring_in[13] = debug_ring_out[12];
	assign debug_ring_in[14] = debug_ring_out[13];
	assign debug_ring_in[15] = debug_ring_out[14];
	debug_ring_out_ready[0] = debug_ring_in_ready[1];
	debug_ring_out_ready[1] = debug_ring_in_ready[2];
	debug_ring_out_ready[2] = debug_ring_in_ready[3];
	debug_ring_out_ready[3] = debug_ring_in_ready[4];
	debug_ring_out_ready[4] = debug_ring_in_ready[5];
	debug_ring_out_ready[5] = debug_ring_in_ready[6];
	debug_ring_out_ready[6] = debug_ring_in_ready[7];
	debug_ring_out_ready[7] = debug_ring_in_ready[8];
	debug_ring_out_ready[8] = debug_ring_in_ready[9];
	debug_ring_out_ready[9] = debug_ring_in_ready[10];
	debug_ring_out_ready[10] = debug_ring_in_ready[11];
	debug_ring_out_ready[11] = debug_ring_in_ready[12];
	debug_ring_out_ready[12] = debug_ring_in_ready[13];
	debug_ring_out_ready[13] = debug_ring_in_ready[14];
	debug_ring_out_ready[14] = debug_ring_in_ready[15];
   ---INSERT DEBUG RING CODE

   //	riassign debug_ring_in[1] = debug_ring_out[0];
  print("assign debug_ring_in[" + str(i)  + " = debug_ring_out[" + str() + "1]");
  assign debug_ring_in[3] = debug_ring_out[2];
  assign debug_ring_in[4] = debug_ring_out[3];
  assign debug_ring_in[5] = debug_ring_out[4];
  assign debug_ring_in[6] = debug_ring_out[5];
  assign debug_ring_in[7] = debug_ring_out[6];
  assign debug_ring_in[15] = debug_ring_out[7];
	// the last unit's ring out needs to be INPUT to debug interface ring_in
	// debug interface's ring_out needs to be input to first unit's ring in
	//	these are already done aboe in the module decl.  

   //	ring_in_rdy is actually an OUTPUT. connect unit i+1's in_rdy to unit i
   
   assign debug_ring_out_ready[0] = debug_ring_in_ready[1];
   assign debug_ring_out_ready[1] = debug_ring_in_ready[2];
   assign debug_ring_out_ready[2] = debug_ring_in_ready[3];
   assign debug_ring_out_ready[3] = debug_ring_in_ready[4];
   assign debug_ring_out_ready[4] = debug_ring_in_ready[5];
   assign debug_ring_out_ready[5] = debug_ring_in_ready[6];
   assign debug_ring_out_ready[6] = debug_ring_in_ready[7];
   assign debug_ring_out_ready[7] = debug_ring_in_ready[15];ng_out is output, ring_in is input. connect rout[i] to rin[i+1]
  
           
   // the last unit's rout_rdy, an input, needs to connect to debug interface rin_ready
   // debug interface's rin_rdy, an output needs to be input to first unit's rout_rdy
   // these are already done aboe in the module decl.  
   
   
   localparam FLIT_WIDTH = CONFIG.NOC_FLIT_WIDTH;
   localparam CHANNELS = CONFIG.NOC_CHANNELS;

   // Flits from NoC->tiles
   wire [15:0][CHANNELS-1:0][FLIT_WIDTH-1:0] link_in_flit;
   wire [15:0][CHANNELS-1:0]                 link_in_last;
   wire [15:0][CHANNELS-1:0]                 link_in_valid;
   wire [15:0][CHANNELS-1:0]                 link_in_ready;

   // Flits from tiles->NoC
   wire [15:0][CHANNELS-1:0][FLIT_WIDTH-1:0] link_out_flit;
   wire [15:0][CHANNELS-1:0]                 link_out_last;
   wire [15:0][CHANNELS-1:0]                 link_out_valid;
   wire [15:0][CHANNELS-1:0]                 link_out_ready;

   noc_mesh
     #(.FLIT_WIDTH (FLIT_WIDTH), .X (4), .Y (4),
       .CHANNELS (CHANNELS), .ENABLE_VCHANNELS(CONFIG.NOC_ENABLE_VCHANNELS))
   u_noc
     (.*,
      .in_flit   (link_out_flit),
      .in_last   (link_out_last),
      .in_valid  (link_out_valid),
      .in_ready  (link_out_ready),
      .out_flit  (link_in_flit),
      .out_last  (link_in_last),
      .out_valid (link_in_valid),
      .out_ready (link_in_ready)
      );

   genvar i;
   generate
      for (i=0; i<16; i=i+1) begin : gen_ct
         compute_tile_dm
            #(.CONFIG (CONFIG),
              .ID(i),
              .COREBASE(i*CONFstem_*_*_dmIG.CORES_PER_TILE),
              .DEBUG_BASEID((CONFIG.DEBUG_LOCAL_SUBNET << (16 - CONFIG.DEBUG_SUBNET_BITS))
                            + 1 + (i*CONFIG.DEBUG_MODS_PER_TILE)))

         u_ct(.clk                        (clk),
              .rst_cpu                    (rst_cpu),
              .rst_sys                    (rst_sys),
              .rst_dbg                    (rst),
              .debug_ring_in              (debug_ring_in[i]),
              .debug_ring_in_ready        (debug_ring_in_ready[i]),
              .debug_ring_out             (debug_ring_out[i]),
              .debug_ring_out_ready       (debug_ring_out_ready[i]),

              .wb_ext_ack_o               (wb_ext_ack_o[i]),
              .wb_ext_rty_o               (wb_ext_rty_o[i]),
              .wb_ext_err_o               (wb_ext_err_o[i]),
              .wb_ext_dat_o               (wb_ext_dat_o[(i+1)*32-1:i*32]),
              .wb_ext_adr_i               (wb_ext_adr_i[(i+1)*32-1:i*32]),
              .wb_ext_cyc_i               (wb_ext_cyc_i[i]),
              .wb_ext_dat_i               (wb_ext_dat_i[(i+1)*32-1:i*32]),
              .wb_ext_sel_i               (wb_ext_sel_i[(i+1)*4-1:i*4]),
              .wb_ext_stb_i               (wb_ext_stb_i[i]),
              .wb_ext_we_i                (wb_ext_we_i[i]),
              .wb_ext_cab_i               (wb_ext_cab_i[i]),
              .wb_ext_cti_i               (wb_ext_cti_i[(i+1)*3-1:i*3]),
              .wb_ext_bte_i               (wb_ext_bte_i[(i+1)*2-1:i*2]),

              .noc_in_ready               (link_in_ready[i]),
              .noc_out_flit               (link_out_flit[i]),
              .noc_out_last               (link_out_last[i]),
              .noc_out_valid              (link_out_valid[i]),

              .noc_in_flit                (link_in_flit[i]),
              .noc_in_last                (link_in_last[i]),
              .noc_in_valid               (link_in_valid[i]),
              .noc_out_ready              (link_out_ready[i]));
      end
   endgenerate

endmodule
