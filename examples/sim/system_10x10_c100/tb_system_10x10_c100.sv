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
 * A testbench for a 3x3 C9 system with distributed memory
 *
 * Parameters:
 *   USE_DEBUG:
 *     Enable the OSD-based debug system.
 *
 *   NUM_CORES:
 *     Number of CPU cores inside each compute tile (default: 1)
 *
 *   LMEM_SIZE:
 *     Size of the local distributed memory in bytes (default: 32 MB)
 *
 * Author(s):
 *   Philipp Wagner <philipp.wagner@tum.de>
 *   Stefan Wallentowitz <stefan.wallentowitz@tum.de>
 */

module tb_system_10x10_c100(
`ifdef verilator
   input clk,
   input rst
`endif
   );

   import dii_package::dii_flit;
   import opensocdebug::mor1kx_trace_exec;
   import optimsoc_config::*;
   import optimsoc_functions::*;

   parameter USE_DEBUG = 0;
   parameter ENABLE_VCHANNELS = 1*1;
   parameter integer NUM_CORES = 1*1; // bug in verilator would give a warning
   parameter integer LMEM_SIZE = 256*1024*1024;

   localparam base_config_t
     BASE_CONFIG = '{ NUMTILES: 100,
                      NUMCTS: 100,	// TODO: what is CTS??
                      // CTLIST is a 128 long array of 16 bit entries, defined in util/config.
                      //   so for 100 cores, top 28 are undefined, lower 100 are the IDs.
                      CTLIST: {{28{16'hx}}, 16'd0,16'd1,16'd2,16'd3,16'd4,16'd5,16'd6,16'd7,16'd8,16'd9,16'd10,16'd11,16'd12,16'd13,16'd14,16'd15,16'd16,16'd17,16'd18,16'd19,16'd20,16'd21,16'd22,16'd23,16'd24,16'd25,16'd26,16'd27,16'd28,16'd29,16'd30,16'd31,16'd32,16'd33,16'd34,16'd35,16'd36,16'd37,16'd38,16'd39,16'd40,16'd41,16'd42,16'd43,16'd44,16'd45,16'd46,16'd47,16'd48,16'd49,16'd50,16'd51,16'd52,16'd53,16'd54,16'd55,16'd56,16'd57,16'd58,16'd59,16'd60,16'd61,16'd62,16'd63,16'd64,16'd65,16'd66,16'd67,16'd68,16'd69,16'd70,16'd71,16'd72,16'd73,16'd74,16'd75,16'd76,16'd77,16'd78,16'd79,16'd80,16'd81,16'd82,16'd83,16'd84,16'd85,16'd86,16'd87,16'd88,16'd89,16'd90,16'd91,16'd92,16'd93,16'd94,16'd95,16'd96,16'd97,16'd98,16'd99},
                      CORES_PER_TILE: NUM_CORES,
                      GMEM_SIZE: 0,
                      GMEM_TILE: 'x,
                      NOC_ENABLE_VCHANNELS: ENABLE_VCHANNELS,
                      LMEM_SIZE: LMEM_SIZE,
                      LMEM_STYLE: PLAIN,
                      ENABLE_BOOTROM: 0,
                      BOOTROM_SIZE: 0,
                      ENABLE_DM: 1,
                      DM_BASE: 32'h0,
                      DM_SIZE: LMEM_SIZE,
                      ENABLE_PGAS: 0,
                      PGAS_BASE: 0,
                      PGAS_SIZE: 0,
                      CORE_ENABLE_FPU: 0,
                      CORE_ENABLE_PERFCOUNTERS: 0,
                      NA_ENABLE_MPSIMPLE: 1,
                      NA_ENABLE_DMA: 1,
                      NA_DMA_GENIRQ: 1,
                      NA_DMA_ENTRIES: 4,
                      USE_DEBUG: 1'(USE_DEBUG),
                      DEBUG_STM: 1,
                      DEBUG_CTM: 1,
                      DEBUG_DEM_UART: 0,
                      DEBUG_SUBNET_BITS: 6,
                      DEBUG_LOCAL_SUBNET: 0,
                      DEBUG_ROUTER_BUFFER_SIZE: 4,
                      DEBUG_MAX_PKT_LEN: 12
                      };

   localparam config_t CONFIG = derive_config(BASE_CONFIG);

   logic rst_sys, rst_cpu;

   logic cpu_stall;
   assign cpu_stall = 0;

// In Verilator, we feed clk and rst from the C++ toplevel, in ModelSim & Co.
// these signals are generated inside this testbench.
`ifndef verilator
   reg clk;
   reg rst;
`endif

   // Reset signals
   // In simulations with debug system, these signals can be triggered through
   // the host software. In simulations without debug systems, we only rely on
   // the global reset signal.
   generate
      if (CONFIG.USE_DEBUG == 0) begin : gen_use_debug_rst
         assign rst_sys = rst;
         assign rst_cpu = rst;
      end
   endgenerate

   glip_channel c_glip_in(.*);
   glip_channel c_glip_out(.*);

   logic com_rst, logic_rst;

   if (CONFIG.USE_DEBUG == 1) begin : gen_use_debug_glip
      // TCP communication interface (simulation only)
      glip_tcp_toplevel
        u_glip
          (
           .*,
           .clk_io    (clk),
           .clk_logic (clk),
           .fifo_in   (c_glip_in),
           .fifo_out  (c_glip_out)
           );
   end // if (CONFIG.USE_DEBUG == 1)

   // Monitor system behavior in simulation
   genvar t;
   genvar i;

   wire [CONFIG.NUMCTS*CONFIG.CORES_PER_TILE-1:0] termination;

   generate
      for (t = 0; t < CONFIG.NUMCTS; t = t + 1) begin : gen_tracemon_ct

         logic [31:0] trace_r3 [0:CONFIG.CORES_PER_TILE-1];
         mor1kx_trace_exec [CONFIG.CORES_PER_TILE-1:0] trace;
         assign trace = u_system.gen_ct[t].u_ct.trace;

         for (i = 0; i < CONFIG.CORES_PER_TILE; i = i + 1) begin : gen_tracemon_core
            r3_checker
               u_r3_checker(
                  .clk(clk),
                  .valid(trace[i].valid),
                  .we (trace[i].wben),
                  .addr (trace[i].wbreg),
                  .data (trace[i].wbdata),
                  .r3 (trace_r3[i])
               );

            trace_monitor
               #(
                  .STDOUT_FILENAME({"stdout.",index2string((t*CONFIG.CORES_PER_TILE)+i)}),
                  .TRACEFILE_FILENAME({"trace.",index2string((t*CONFIG.CORES_PER_TILE)+i)}),
                  .ENABLE_TRACE(0),
                  .ID((t*CONFIG.CORES_PER_TILE)+i),
                  .TERM_CROSS_NUM(CONFIG.NUMCTS*CONFIG.CORES_PER_TILE)
               )
               u_mon0(
                  .termination            (termination[(t*CONFIG.CORES_PER_TILE)+i]),
                  .clk                    (clk),
                  .enable                 (trace[i].valid),
                  .wb_pc                  (trace[i].pc),
                  .wb_insn                (trace[i].insn),
                  .r3                     (trace_r3[i]),
                  .termination_all        (termination)
              );
         end

      end
   endgenerate

   system_10x10_c100_dm
     #(.CONFIG(CONFIG))
   u_system
     (.clk (clk),
      .rst (rst | logic_rst),
      .c_glip_in (c_glip_in),
      .c_glip_out (c_glip_out),

      .wb_ext_ack_o (4'hx),
      .wb_ext_err_o (4'hx),
      .wb_ext_rty_o (4'hx),
      .wb_ext_dat_o (128'hx),
      .wb_ext_adr_i (),
      .wb_ext_cyc_i (),
      .wb_ext_dat_i (),
      .wb_ext_sel_i (),
      .wb_ext_stb_i (),
      .wb_ext_we_i (),
      .wb_ext_cab_i (),
      .wb_ext_cti_i (),
      .wb_ext_bte_i ()
      );

// Generate testbench signals.
// In Verilator, these signals are generated in the C++ toplevel testbench
`ifndef verilator
   initial begin
      clk = 1'b1;
      rst = 1'b1;
      #15;
      rst = 1'b0;
   end

   always clk = #1.25 ~clk;
`endif

endmodule

// Local Variables:
// verilog-library-directories:("." "../../../../src/rtl/*/verilog")
// verilog-auto-inst-param-value: t
// End:
