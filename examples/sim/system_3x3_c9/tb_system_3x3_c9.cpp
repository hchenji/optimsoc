#include "Vtb_system_3x3_c9__Syms.h"
#include "Vtb_system_3x3_c9__Dpi.h"

#include <VerilatedToplevel.h>
#include <VerilatedControl.h>

#include <ctime>
#include <cstdlib>

using namespace simutilVerilator;

VERILATED_TOPLEVEL(tb_system_3x3_c9, clk, rst)

int main(int argc, char *argv[])
{
    tb_system_3x3_c9 ct("TOP");

    VerilatedControl &simctrl = VerilatedControl::instance();
    simctrl.init(ct, argc, argv);

    for (int var = 0; var < 9; ++var) {
    	char str[256];
    	sprintf(str, "TOP.tb_system_3x3_c9.u_system.gen_ct[%d].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl", var);
    	simctrl.addMemory(str);
	}
    simctrl.setMemoryFuncs(do_readmemh, do_readmemh_file);
    simctrl.run();

    return 0;
}
