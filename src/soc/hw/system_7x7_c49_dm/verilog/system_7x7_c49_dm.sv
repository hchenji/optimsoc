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
 * A 3x3 distributed memory system with 49 compute tiles (C49)
 *
 * Author(s):
 *   Stefan Wallentowitz <stefan.wallentowitz@tum.de>
 * 		Harsha Chenji (chenji@ohio.edu)
 *       Marcelo Morales (mm5487516@ohio.edu)
 */

module system_7x7_c49_dm(
   input clk, rst,

   glip_channel c_glip_in,
   glip_channel c_glip_out,

   output [49*32-1:0] wb_ext_adr_i,
   output [49*1-1:0]  wb_ext_cyc_i,
   output [49*32-1:0] wb_ext_dat_i,
   output [49*4-1:0]  wb_ext_sel_i,
   output [49*1-1:0]  wb_ext_stb_i,
   output [49*1-1:0]  wb_ext_we_i,
   output [49*1-1:0]  wb_ext_cab_i,
   output [49*3-1:0]  wb_ext_cti_i,
   output [49*2-1:0]  wb_ext_bte_i,
   input  [49*1-1:0]   wb_ext_ack_o,
   input  [49*1-1:0]   wb_ext_rty_o,
   input  [49*1-1:0]   wb_ext_err_o,
   input  [49*32-1:0]  wb_ext_dat_o
   );

   import dii_package::dii_flit;
   import optimsoc_config::*;

   parameter config_t CONFIG = 'x;

   dii_flit [1:0] debug_ring_in [0:48];
   dii_flit [1:0] debug_ring_out [0:48];
   logic [1:0] debug_ring_in_ready [0:48];
   logic [1:0] debug_ring_out_ready [0:48];

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
         .ring_in        (debug_ring_out[48]),
         .ring_in_ready  (debug_ring_out_ready[48])
      );

	// TODO: extend this to 49 cores, meander across rows/cols
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
	assign debug_ring_in[16] = debug_ring_out[15];
	assign debug_ring_in[17] = debug_ring_out[16];
	assign debug_ring_in[18] = debug_ring_out[17];
	assign debug_ring_in[19] = debug_ring_out[18];
	assign debug_ring_in[20] = debug_ring_out[19];
	assign debug_ring_in[21] = debug_ring_out[20];
	assign debug_ring_in[22] = debug_ring_out[21];
	assign debug_ring_in[23] = debug_ring_out[22];
	assign debug_ring_in[24] = debug_ring_out[23];
	assign debug_ring_in[25] = debug_ring_out[24];
	assign debug_ring_in[26] = debug_ring_out[25];
	assign debug_ring_in[27] = debug_ring_out[26];
	assign debug_ring_in[28] = debug_ring_out[27];
	assign debug_ring_in[29] = debug_ring_out[28];
	assign debug_ring_in[30] = debug_ring_out[29];
	assign debug_ring_in[31] = debug_ring_out[30];
	assign debug_ring_in[32] = debug_ring_out[31];
	assign debug_ring_in[33] = debug_ring_out[32];
	assign debug_ring_in[34] = debug_ring_out[33];
	assign debug_ring_in[35] = debug_ring_out[34];
	assign debug_ring_in[36] = debug_ring_out[35];
	assign debug_ring_in[37] = debug_ring_out[36];
	assign debug_ring_in[38] = debug_ring_out[37];
	assign debug_ring_in[39] = debug_ring_out[38];
	assign debug_ring_in[40] = debug_ring_out[39];
	assign debug_ring_in[41] = debug_ring_out[40];
	assign debug_ring_in[42] = debug_ring_out[41];
	assign debug_ring_in[43] = debug_ring_out[42];
	assign debug_ring_in[44] = debug_ring_out[43];
	assign debug_ring_in[45] = debug_ring_out[44];
	assign debug_ring_in[46] = debug_ring_out[45];
	assign debug_ring_in[47] = debug_ring_out[46];
	assign debug_ring_in[48] = debug_ring_out[47];
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
	debug_ring_out_ready[15] = debug_ring_in_ready[16];
	debug_ring_out_ready[16] = debug_ring_in_ready[17];
	debug_ring_out_ready[17] = debug_ring_in_ready[18];
	debug_ring_out_ready[18] = debug_ring_in_ready[19];
	debug_ring_out_ready[19] = debug_ring_in_ready[20];
	debug_ring_out_ready[20] = debug_ring_in_ready[21];
	debug_ring_out_ready[21] = debug_ring_in_ready[22];
	debug_ring_out_ready[22] = debug_ring_in_ready[23];
	debug_ring_out_ready[23] = debug_ring_in_ready[24];
	debug_ring_out_ready[24] = debug_ring_in_ready[25];
	debug_ring_out_ready[25] = debug_ring_in_ready[26];
	debug_ring_out_ready[26] = debug_ring_in_ready[27];
	debug_ring_out_ready[27] = debug_ring_in_ready[28];
	debug_ring_out_ready[28] = debug_ring_in_ready[29];
	debug_ring_out_ready[29] = debug_ring_in_ready[30];
	debug_ring_out_ready[30] = debug_ring_in_ready[31];
	debug_ring_out_ready[31] = debug_ring_in_ready[32];
	debug_ring_out_ready[32] = debug_ring_in_ready[33];
	debug_ring_out_ready[33] = debug_ring_in_ready[34];
	debug_ring_out_ready[34] = debug_ring_in_ready[35];
	debug_ring_out_ready[35] = debug_ring_in_ready[36];
	debug_ring_out_ready[36] = debug_ring_in_ready[37];
	debug_ring_out_ready[37] = debug_ring_in_ready[38];
	debug_ring_out_ready[38] = debug_ring_in_ready[39];
	debug_ring_out_ready[39] = debug_ring_in_ready[40];
	debug_ring_out_ready[40] = debug_ring_in_ready[41];
	debug_ring_out_ready[41] = debug_ring_in_ready[42];
	debug_ring_out_ready[42] = debug_ring_in_ready[43];
	debug_ring_out_ready[43] = debug_ring_in_ready[44];
	debug_ring_out_ready[44] = debug_ring_in_ready[45];
	debug_ring_out_ready[45] = debug_ring_in_ready[46];
	debug_ring_out_ready[46] = debug_ring_in_ready[47];
	debug_ring_out_ready[47] = debug_ring_in_ready[48];
   ---INSERT DEBUG RING CODE

   //	riassign debug_ring_in[1] = debug_ring_out[0];
  print("assign debug_ring_in[" + str(i)  + " = debug_ring_out[" + str() + "1]");
  assign debug_ring_in[3] = debug_ring_out[2];
  assign debug_ring_in[4] = debug_ring_out[3];
  assign debug_ring_in[5] = debug_ring_out[4];
  assign debug_ring_in[6] = debug_ring_out[5];
  assign debug_ring_in[7] = debug_ring_out[6];
  assign debug_ring_in[48] = debug_ring_out[7];
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
   assign debug_ring_out_ready[7] = debug_ring_in_ready[48];ng_out is output, ring_in is input. connect rout[i] to rin[i+1]
  
           
   // the last unit's rout_rdy, an input, needs to connect to debug interface rin_ready
   // debug interface's rin_rdy, an output needs to be input to first unit's rout_rdy
   // these are already done aboe in the module decl.  
   
   
   localparam FLIT_WIDTH = CONFIG.NOC_FLIT_WIDTH;
   localparam CHANNELS = CONFIG.NOC_CHANNELS;

   // Flits from NoC->tiles
   wire [48:0][CHANNELS-1:0][FLIT_WIDTH-1:0] link_in_flit;
   wire [48:0][CHANNELS-1:0]                 link_in_last;
   wire [48:0][CHANNELS-1:0]                 link_in_valid;
   wire [48:0][CHANNELS-1:0]                 link_in_ready;

   // Flits from tiles->NoC
   wire [48:0][CHANNELS-1:0][FLIT_WIDTH-1:0] link_out_flit;
   wire [48:0][CHANNELS-1:0]                 link_out_last;
   wire [48:0][CHANNELS-1:0]                 link_out_valid;
   wire [48:0][CHANNELS-1:0]                 link_out_ready;

   noc_mesh
     #(.FLIT_WIDTH (FLIT_WIDTH), .X (7), .Y (7),
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
      for (i=0; i<49; i=i+1) begin : gen_ct
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
