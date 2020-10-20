#include "Vtb_system_4x4_c16__Syms.h"
#include "Vtb_system_4x4_c16__Dpi.h"

#include <VerilatedToplevel.h>
#include <VerilatedControl.h>

#include <ctime>
#include <cstdlib>

using namespace simutilVerilator;

VERILATED_TOPLEVEL(tb_system_4x4_c16, clk, rst)

int main(int argc, char *argv[])
{
    tb_system_4x4_c16 ct("TOP");

    VerilatedControl &simctrl = VerilatedControl::instance();
    simctrl.init(ct, argc, argv);

    // char str[16][256];

 //    for (int var = 0; var < 16; ++var) {
 //    	sprintf(str[var], "TOP.tb_system_4x4_c16.u_system.gen_ct[%d].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl", var);
	simctrl.addMemory("TOP.tb_system_4x4_c16.u_system.gen_ct[0].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_4x4_c16.u_system.gen_ct[1].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_4x4_c16.u_system.gen_ct[2].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_4x4_c16.u_system.gen_ct[3].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_4x4_c16.u_system.gen_ct[4].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_4x4_c16.u_system.gen_ct[5].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_4x4_c16.u_system.gen_ct[6].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_4x4_c16.u_system.gen_ct[7].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_4x4_c16.u_system.gen_ct[8].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_4x4_c16.u_system.gen_ct[9].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_4x4_c16.u_system.gen_ct[10].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_4x4_c16.u_system.gen_ct[11].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_4x4_c16.u_system.gen_ct[12].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_4x4_c16.u_system.gen_ct[13].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_4x4_c16.u_system.gen_ct[14].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_4x4_c16.u_system.gen_ct[15].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.setMemoryFuncs(do_readmemh, do_readmemh_file);
	simctrl.run();

	return 0;
}