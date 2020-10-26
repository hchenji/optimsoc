#!/bin/bash

# actually, run this in any folder and fusesoc will create a "build" directory
# cd /Lhome/harsha/codebox/optimsoc/objdir/examples/sim/system_3x3_c9

export OPTIMSOC="/Lhome/harsha/codebox/optimsoc/objdir/dist"
export OPTIMSOC_RTL="/Lhome/harsha/codebox/optimsoc/objdir/dist/soc/hw"
export LISNOC="/Lhome/harsha/codebox/optimsoc/objdir/dist/external/lisnoc"
export LISNOC_RTL="/Lhome/harsha/codebox/optimsoc/objdir/dist/external/lisnoc/rtl"
export FUSESOC_CORES="/Lhome/harsha/codebox/optimsoc/objdir/dist/soc/hw:/Lhome/harsha/codebox/optimsoc/objdir/dist/external/lisnoc:/Lhome/harsha/codebox/optimsoc/objdir/dist/external/opensocdebug/hardware:/Lhome/harsha/codebox/optimsoc/objdir/dist/external/mor1kx:/Lhome/harsha/codebox/optimsoc/objdir/dist/external/glip"

fusesoc --verbose --monochrome --cores-root /Lhome/harsha/codebox/optimsoc/examples/sim/system_3x3_c9 sim --build-only optimsoc:examples:system_3x3_c9_sim --NUM_CORES 1