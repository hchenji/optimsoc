module genconfig;

function automatic integer clog2;
      input integer value;
      begin
         value = value - 1;
         for (clog2 = 0; value > 0; clog2 = clog2 + 1) begin
            value = value >> 1;
         end
      end
   endfunction


   /**
    * Math function: enhanced clog2 function
    *
    *                        0        for value == 0
    * clog2_width =          1        for value == 1
    *               ceil(log2(value)) for value > 1
    *
    *
    * This function is a variant of the clog2() function, which returns 1 if the
    * input value is 1. In all other cases it behaves exactly like clog2().
    * This is useful to define registers which are wide enough to contain
    * "value" values.
    *
    * Example 1:
    *   parameter ITEMS = 1;
    *   localparam ITEMS_WIDTH = clog2_width(ITEMS); // 1
    *   reg [ITEMS_WIDTH-1:0] item_register; // items_register is now [0:0]
    *
    * Example 2:
    *   parameter ITEMS = 64;
    *   localparam ITEMS_WIDTH = clog2_width(ITEMS); // 6
    *   reg [ITEMS_WIDTH-1:0] item_register; // items_register is now [5:0]
    *
    * Note: I if you want to store the number "value" inside a
    * register, you need a register with size clog2(value + 1), since
    * you also need to store the number 0.
    *
    * Example 3:
    *   reg [clog2_width(64) - 1 : 0]     store_64_items;  // width is [5:0]
    *   reg [clog2_width(64 + 1) - 1 : 0] store_number_64; // width is [6:0]
    */
   function automatic integer clog2_width;
      input integer value;
      begin
         if (value == 1) begin
            clog2_width = 1;
         end else begin
            clog2_width = clog2(value);
         end
      end
   endfunction

   /**
    * Get a string representing an integer
    *
    * This function works only for up to three-digit numbers, e.g. 0 - 999.
    */
   function automatic [23:0] index2string;
      input integer index;
      integer       hundreds;
      integer       tens;
      integer       ones;
      begin
         hundreds = index / 100;
         tens = (index - (hundreds * 100)) / 10;
         ones = (index - (hundreds * 100) - (tens * 10));
         index2string[23:16] = 8'(hundreds) + 8'd48;
         index2string[15:8] = 8'(tens) + 8'd48;
         index2string[7:0] = 8'(ones) + 8'd48;
      end
   endfunction

   typedef enum { EXTERNAL, PLAIN } lmem_style_t;

   typedef struct packed {
      // System configuration
      integer     NUMTILES;
      integer     NUMCTS;
      logic [127:0][15:0] CTLIST;
      integer            CORES_PER_TILE;
      integer            GMEM_SIZE;
      integer            GMEM_TILE;

      // NoC-related configuration
      logic              NOC_ENABLE_VCHANNELS;

      // Tile configuration
      integer            LMEM_SIZE;
      lmem_style_t       LMEM_STYLE;
      logic              ENABLE_BOOTROM;
      integer            BOOTROM_SIZE;
      logic              ENABLE_DM;
      integer            DM_BASE;
      integer            DM_SIZE;
      logic              ENABLE_PGAS;
      integer            PGAS_BASE;
      integer            PGAS_SIZE;

      // CPU core configuration
      logic              CORE_ENABLE_FPU;
      logic              CORE_ENABLE_PERFCOUNTERS;

      // Network adapter configuration
      logic              NA_ENABLE_MPSIMPLE;
      logic              NA_ENABLE_DMA;
      logic              NA_DMA_GENIRQ;
      integer            NA_DMA_ENTRIES;

      // Debug configuration
      logic              USE_DEBUG;
      logic              DEBUG_STM;
      logic              DEBUG_CTM;
      logic              DEBUG_DEM_UART;
      integer            DEBUG_SUBNET_BITS;
      integer            DEBUG_LOCAL_SUBNET;
      integer            DEBUG_ROUTER_BUFFER_SIZE;
      integer            DEBUG_MAX_PKT_LEN;
   } base_config_t;

   typedef struct        packed {
      // System configuration
      integer            NUMTILES;
      integer            NUMCTS;
      logic [127:0][15:0] CTLIST;
      integer            CORES_PER_TILE;
      integer            GMEM_SIZE;
      integer            GMEM_TILE;
      //  -> derived
      integer            TOTAL_NUM_CORES;

      // NoC-related configuration
      logic              NOC_ENABLE_VCHANNELS;
      //  -> derived
      integer            NOC_FLIT_WIDTH;
      integer            NOC_CHANNELS;

      // Tile configuration
      integer            LMEM_SIZE;
      lmem_style_t       LMEM_STYLE;
      logic              ENABLE_BOOTROM;
      integer            BOOTROM_SIZE;
      logic              ENABLE_DM;
      integer            DM_BASE;
      integer            DM_SIZE;
      logic              ENABLE_PGAS;
      integer            DM_RANGE_WIDTH;
      integer            DM_RANGE_MATCH;
      integer            PGAS_BASE;
      integer            PGAS_SIZE;
      integer            PGAS_RANGE_WIDTH;
      integer            PGAS_RANGE_MATCH;

      // CPU core configuration
      logic              CORE_ENABLE_FPU;
      logic              CORE_ENABLE_PERFCOUNTERS;

      // Network adapter configuration
      logic              NA_ENABLE_MPSIMPLE;
      logic              NA_ENABLE_DMA;
      logic              NA_DMA_GENIRQ;
      integer            NA_DMA_ENTRIES;

      // Debug configuration
      logic              USE_DEBUG;
      logic              DEBUG_STM;
      logic              DEBUG_CTM;
      logic              DEBUG_DEM_UART;
      integer            DEBUG_SUBNET_BITS;
      integer            DEBUG_LOCAL_SUBNET;
      integer            DEBUG_ROUTER_BUFFER_SIZE;
      integer            DEBUG_MAX_PKT_LEN;
      // -> derived
      integer            DEBUG_MODS_PER_CORE;
      integer            DEBUG_MODS_PER_TILE;
      integer            DEBUG_NUM_MODS;
   } config_t;

   function automatic config_t derive_config(base_config_t conf);
      // Copy the basic parameters
      derive_config.NUMTILES = conf.NUMTILES;
      derive_config.NUMCTS = conf.NUMCTS;
      derive_config.CTLIST = conf.CTLIST;
      derive_config.CORES_PER_TILE = conf.CORES_PER_TILE;
      derive_config.GMEM_SIZE = conf.GMEM_SIZE;
      derive_config.GMEM_TILE = conf.GMEM_TILE;
      derive_config.NOC_ENABLE_VCHANNELS = conf.NOC_ENABLE_VCHANNELS;
      derive_config.LMEM_SIZE = conf.LMEM_SIZE;
      derive_config.LMEM_STYLE = conf.LMEM_STYLE;
      derive_config.ENABLE_BOOTROM = conf.ENABLE_BOOTROM;
      derive_config.BOOTROM_SIZE = conf.BOOTROM_SIZE;
      derive_config.ENABLE_DM = conf.ENABLE_DM;
      derive_config.DM_BASE = conf.DM_BASE;
      derive_config.DM_SIZE = conf.DM_SIZE;
      derive_config.ENABLE_PGAS = conf.ENABLE_PGAS;
      derive_config.PGAS_BASE = conf.PGAS_BASE;
      derive_config.PGAS_SIZE = conf.PGAS_SIZE;
      derive_config.CORE_ENABLE_FPU = conf.CORE_ENABLE_FPU;
      derive_config.CORE_ENABLE_PERFCOUNTERS = conf.CORE_ENABLE_PERFCOUNTERS;
      derive_config.NA_ENABLE_MPSIMPLE = conf.NA_ENABLE_MPSIMPLE;
      derive_config.NA_ENABLE_DMA = conf.NA_ENABLE_DMA;
      derive_config.NA_DMA_GENIRQ = conf.NA_DMA_GENIRQ;
      derive_config.NA_DMA_ENTRIES = conf.NA_DMA_ENTRIES;
      derive_config.USE_DEBUG = conf.USE_DEBUG;
      derive_config.DEBUG_STM = conf.DEBUG_STM;
      derive_config.DEBUG_CTM = conf.DEBUG_CTM;
      derive_config.DEBUG_DEM_UART = conf.DEBUG_DEM_UART;
      derive_config.DEBUG_SUBNET_BITS = conf.DEBUG_SUBNET_BITS;
      derive_config.DEBUG_LOCAL_SUBNET = conf.DEBUG_LOCAL_SUBNET;
      derive_config.DEBUG_ROUTER_BUFFER_SIZE = conf.DEBUG_ROUTER_BUFFER_SIZE;
      derive_config.DEBUG_MAX_PKT_LEN = conf.DEBUG_MAX_PKT_LEN;

      // Derive the other parameters
      derive_config.TOTAL_NUM_CORES = conf.NUMCTS * conf.CORES_PER_TILE;

      derive_config.DM_RANGE_WIDTH = conf.ENABLE_DM ? 32-clog2_width(conf.DM_SIZE) : 1;
      derive_config.DM_RANGE_MATCH = conf.DM_BASE >> (32-derive_config.DM_RANGE_WIDTH);
      derive_config.PGAS_RANGE_WIDTH = conf.ENABLE_PGAS ? 32-clog2_width(conf.PGAS_SIZE) : 1;
      derive_config.PGAS_RANGE_MATCH = conf.PGAS_BASE >> (32-derive_config.PGAS_RANGE_WIDTH);

      derive_config.DEBUG_MODS_PER_CORE = (int'(conf.DEBUG_STM) + int'(conf.DEBUG_CTM)) * int'(conf.USE_DEBUG);
      derive_config.DEBUG_MODS_PER_TILE = conf.USE_DEBUG *
                                          (1 /* MAM */
                                           + int'(conf.DEBUG_DEM_UART)
                                           + derive_config.DEBUG_MODS_PER_CORE * conf.CORES_PER_TILE);
      derive_config.DEBUG_NUM_MODS = conf.USE_DEBUG *
                                     (1 /* SCM */
                                      + conf.NUMCTS * derive_config.DEBUG_MODS_PER_TILE);

      // Those are supposed to be variables, but are constant at least for now
      derive_config.NOC_CHANNELS = 2;
      derive_config.NOC_FLIT_WIDTH = 32;
   endfunction // DERIVE_CONFIG

// Simulation parameters
   parameter USE_DEBUG = 0;
   parameter ENABLE_VCHANNELS = 1*1;
   parameter integer NUM_CORES = 1*1; // bug in verilator would give a warning
   parameter integer LMEM_SIZE = 1024*1024;

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

   initial begin
      $displayb("%p",CONFIG); 
   end

endmodule // optimsoc
