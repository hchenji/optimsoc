#!/bin/bash

# actually, run this in any folder and fusesoc will create a "build" directory
# cd /home/cjh/codebox/optimsoc/objdir/examples/sim/compute_tile

export OPTIMSOC="/home/cjh/codebox/optimsoc"
export OPTIMSOC_RTL="/home/cjh/codebox/optimsoc/src/soc/hw"
export LISNOC="/home/cjh/codebox/optimsoc/external/lisnoc"
export LISNOC_RTL="/home/cjh/codebox/optimsoc/external/lisnoc/rtl"
export FUSESOC_CORES="/home/cjh/codebox/optimsoc/src/soc/hw:/home/cjh/codebox/optimsoc/external/lisnoc:/home/cjh/codebox/optimsoc/external/opensocdebug/hardware:/home/cjh/codebox/optimsoc/external/mor1kx:/home/cjh/codebox/optimsoc/external/glip"

# fusesoc --verbose --monochrome --cores-root /home/cjh/codebox/optimsoc/examples/sim/compute_tile sim --no-export --sim vcs --build-only optimsoc:examples:compute_tile_sim --NUM_CORES 1

# mor1kx module
# fusesoc --verbose --monochrome --cores-root /home/cjh/codebox/optimsoc/src/soc/hw/mor1kx_module sim --no-export --sim vcs --build-only optimsoc:core:mor1kx_module

# compute_tile_dm
# fusesoc --verbose --monochrome --cores-root /home/cjh/codebox/optimsoc/src/soc/hw/compute_tile_dm sim --no-export --sim vcs --build-only optimsoc:tile:compute_tile_dm

#2x2
fusesoc --verbose --monochrome --cores-root /home/cjh/codebox/optimsoc/src/soc/hw/system_2x2_cccc_dm sim --no-export --sim vcs --build-only optimsoc:system:2x2_cccc_dm
