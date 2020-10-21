#include "Vtb_system_10x10_c100__Syms.h"
#include "Vtb_system_10x10_c100__Dpi.h"

#include <VerilatedToplevel.h>
#include <VerilatedControl.h>

#include <ctime>
#include <cstdlib>

using namespace simutilVerilator;

VERILATED_TOPLEVEL(tb_system_10x10_c100, clk, rst)

int main(int argc, char *argv[])
{
    tb_system_10x10_c100 ct("TOP");

    VerilatedControl &simctrl = VerilatedControl::instance();
    simctrl.init(ct, argc, argv);

    char str[100][256];

    for (int var = 0; var < 100; ++var) {
    	sprintf(str[var], "TOP.tb_system_10x10_c100.u_system.gen_ct[%d].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl", var);
    	simctrl.addMemory(str[var]);
	}

    simctrl.setMemoryFuncs(do_readmemh, do_readmemh_file);
    simctrl.run();

    return 0;
}
