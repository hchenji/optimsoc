
set -x OPTIMSOC $PWD


set OPTIMSOC_RTL $OPTIMSOC/soc/hw
set OPTIMSOC_VERSION 2018.1-gitec518aaba6f1+
set LISNOC $OPTIMSOC/external/lisnoc
set LISNOC_RTL $LISNOC/rtl

set FUSESOC_CORES $OPTIMSOC/soc/hw $OPTIMSOC/external/lisnoc $OPTIMSOC/external/opensocdebug/hardware $OPTIMSOC/external/mor1kx $OPTIMSOC/external/glip $FUSESOC_CORES

set PKG_CONFIG_PATH $OPTIMSOC/host/share/pkgconfig $OPTIMSOC/host/lib/pkgconfig $OPTIMSOC/host/lib64/pkgconfig $OPTIMSOC/soc/sw/share/pkgconfig $PKG_CONFIG_PATH
set PATH $OPTIMSOC/host/bin $PATH
set LD_LIBRARY_PATH $OPTIMSOC/host/lib $OPTIMSOC/host/lib64 $LD_LIBRARY_PATH
