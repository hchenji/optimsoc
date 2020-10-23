#include "Vtb_system_7x7_c49__Syms.h"
#include "Vtb_system_7x7_c49__Dpi.h"

#include <VerilatedToplevel.h>
#include <VerilatedControl.h>

#include <ctime>
#include <cstdlib>

using namespace simutilVerilator;

VERILATED_TOPLEVEL(tb_system_7x7_c49, clk, rst)

int main(int argc, char *argv[])
{
    tb_system_7x7_c49 ct("TOP");

    VerilatedControl &simctrl = VerilatedControl::instance();
    simctrl.init(ct, argc, argv);

    // char str[49][256];

 //    for (int var = 0; var < 49; ++var) {
 //    	sprintf(str[var], "TOP.tb_system_7x7_c49.u_system.gen_ct[%d].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl", var);
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[0].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[1].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[2].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[3].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[4].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[5].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[6].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[7].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[8].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[9].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[10].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[11].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[12].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[13].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[14].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[15].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[16].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[17].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[18].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[19].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[20].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[21].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[22].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[23].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[24].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[25].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[26].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[27].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[28].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[29].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[30].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[31].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[32].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[33].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[34].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[35].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[36].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[37].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[38].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[39].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[40].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[41].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[42].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[43].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[44].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[45].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[46].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[47].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.addMemory("TOP.tb_system_7x7_c49.u_system.gen_ct[48].u_ct.gen_sram.u_ram.sp_ram.gen_sram_sp_impl.u_impl");
	simctrl.setMemoryFuncs(do_readmemh, do_readmemh_file);
	simctrl.run();

	return 0;
}