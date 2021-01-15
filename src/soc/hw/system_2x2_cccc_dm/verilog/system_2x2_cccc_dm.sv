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
 * A 2x2 distributed memory system with four compute tiles (CCCC)
 *
 * Author(s):
 *   Stefan Wallentowitz <stefan.wallentowitz@tum.de>
 */

module system_2x2_cccc_dm(
   input clk, rst,

`ifndef SYNTHESIS
   glip_channel c_glip_in,
   glip_channel c_glip_out,
`endif

   output [4*32-1:0] wb_ext_adr_i,
   output [4*1-1:0]  wb_ext_cyc_i,
   output [4*32-1:0] wb_ext_dat_i,
   output [4*4-1:0]  wb_ext_sel_i,
   output [4*1-1:0]  wb_ext_stb_i,
   output [4*1-1:0]  wb_ext_we_i,
   output [4*1-1:0]  wb_ext_cab_i,
   output [4*3-1:0]  wb_ext_cti_i,
   output [4*2-1:0]  wb_ext_bte_i,
   input [4*1-1:0]   wb_ext_ack_o,
   input [4*1-1:0]   wb_ext_rty_o,
   input [4*1-1:0]   wb_ext_err_o,
   input [4*32-1:0]  wb_ext_dat_o
   );

   import dii_package::dii_flit;
   import optimsoc_config::*;

   parameter config_t CONFIG = '{NUMTILES:4,
                                 NUMCTS:4,
                                 CTLIST: {{124{16'hx}}, 16'h0, 16'h1, 16'h2, 16'h3},
                                 CORES_PER_TILE:1,
                                 GMEM_SIZE:0,
                                 GMEM_TILE:'x,
                                 TOTAL_NUM_CORES:4,
                                 NOC_ENABLE_VCHANNELS:'h1,
                                 NOC_FLIT_WIDTH:32,
                                 NOC_CHANNELS:2,
                                 LMEM_SIZE:1048576,
                                 LMEM_STYLE:PLAIN,
                                 ENABLE_BOOTROM:'h0,
                                 BOOTROM_SIZE:0,
                                 ENABLE_DM:'h0,
                                 DM_BASE:0,
                                 DM_SIZE:1048576,
                                 ENABLE_PGAS:'h0,
                                 DM_RANGE_WIDTH:12,
                                 DM_RANGE_MATCH:0,
                                 PGAS_BASE:0,
                                 PGAS_SIZE:0,
                                 PGAS_RANGE_WIDTH:1,
                                 PGAS_RANGE_MATCH:0,
                                 CORE_ENABLE_FPU:'h0,
                                 CORE_ENABLE_PERFCOUNTERS:'h0,
                                 NA_ENABLE_MPSIMPLE:'h1,
                                 NA_ENABLE_DMA:'h1,
                                 NA_DMA_GENIRQ:'h1,
                                 NA_DMA_ENTRIES:4,
                                 USE_DEBUG:'h0,
                                 DEBUG_STM:'h1,
                                 DEBUG_CTM:'h1,
                                 DEBUG_DEM_UART:'h0,
                                 DEBUG_SUBNET_BITS:6,
                                 DEBUG_LOCAL_SUBNET:0,
                                 DEBUG_ROUTER_BUFFER_SIZE:4,
                                 DEBUG_MAX_PKT_LEN:12,
                                 DEBUG_MODS_PER_CORE:0,
                                 DEBUG_MODS_PER_TILE:0,
                                 DEBUG_NUM_MODS:0
                                 };

   dii_flit [1:0] debug_ring_in [0:3];
   dii_flit [1:0] debug_ring_out [0:3];
   logic [1:0] debug_ring_in_ready [0:3];
   logic [1:0] debug_ring_out_ready [0:3];

   logic       rst_sys, rst_cpu;

`ifndef SYNTHESIS
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
         .ring_out       (debug_ring_in[0]),
         .ring_out_ready (debug_ring_in_ready[0]),
         .ring_in        (debug_ring_out[2]),
         .ring_in_ready  (debug_ring_out_ready[2])
      );

   // We are routing the debug in a meander
   assign debug_ring_in[1] = debug_ring_out[0];
   assign debug_ring_out_ready[0] = debug_ring_in_ready[1];
   assign debug_ring_in[3] = debug_ring_out[1];
   assign debug_ring_out_ready[1] = debug_ring_in_ready[3];
   assign debug_ring_in[2] = debug_ring_out[3];
   assign debug_ring_out_ready[3] = debug_ring_in_ready[2];
`endif

   localparam FLIT_WIDTH = CONFIG.NOC_FLIT_WIDTH;
   localparam CHANNELS = CONFIG.NOC_CHANNELS;

   // Flits from NoC->tiles
   wire [3:0][CHANNELS-1:0][FLIT_WIDTH-1:0] link_in_flit;
   wire [3:0][CHANNELS-1:0]                 link_in_last;
   wire [3:0][CHANNELS-1:0]                 link_in_valid;
   wire [3:0][CHANNELS-1:0]                 link_in_ready;

   // Flits from tiles->NoC
   wire [3:0][CHANNELS-1:0][FLIT_WIDTH-1:0] link_out_flit;
   wire [3:0][CHANNELS-1:0]                 link_out_last;
   wire [3:0][CHANNELS-1:0]                 link_out_valid;
   wire [3:0][CHANNELS-1:0]                 link_out_ready;

   noc_mesh
     #(.FLIT_WIDTH (FLIT_WIDTH), .X (2), .Y (2),
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
      for (i=0; i<4; i=i+1) begin : gen_ct
         compute_tile_dm
            #(.CONFIG (CONFIG),
              .ID(i),
              .COREBASE(i*CONFIG.CORES_PER_TILE),
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
