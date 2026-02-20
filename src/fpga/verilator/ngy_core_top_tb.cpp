// Verilator C++ testbench for ngy_core_top module

#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vngy_core_top.h"
#include <iostream>
#include <cstdlib>

vluint64_t main_time = 0;

double sc_time_stamp() {
    return main_time;
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);
    
    Vngy_core_top* top = new Vngy_core_top;
    
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("ngy_core_top_tb.vcd");
    
    // Initialize inputs
    top->clk_74a = 0;
    top->reset_n = 0;
    top->cont1_key = 0;
    top->video_channel_enable_s = 7;
    top->video_anim_enable_s = 1;
    top->video_resetframe_s = 0;
    top->video_incrframe_s = 0;
    top->clk_core_12288 = 0;
    top->clk_core_12288_90deg = 0;
    
    // Initialize SRAM data bus (high-Z simulation)
    top->sram_dq = 0;
    
    const vluint64_t CLK_74_PERIOD = 2;
    const vluint64_t CLK_12288_PERIOD = 1;
    const vluint64_t SIM_TIME = 50000;
    const vluint64_t RESET_TIME = 100;
    
    std::cout << "Starting ngy_core_top simulation..." << std::endl;
    
    while (main_time < SIM_TIME && !Verilated::gotFinish()) {
        // Clock generation
        if (main_time % CLK_74_PERIOD == 0) {
            top->clk_74a = !top->clk_74a;
        }
        
        if (main_time % CLK_12288_PERIOD == 0) {
            top->clk_core_12288 = !top->clk_core_12288;
            top->clk_core_12288_90deg = (main_time % (CLK_12288_PERIOD * 4)) < (CLK_12288_PERIOD * 2);
        }
        
        // Reset sequence
        if (main_time == RESET_TIME) {
            top->reset_n = 1;
            std::cout << "Reset released at time " << main_time << std::endl;
        }
        
        // Test controller input
        if (main_time == 2000) {
            top->cont1_key = 0x1;  // dpad_up
            std::cout << "Controller input: dpad_up at time " << main_time << std::endl;
        } else if (main_time == 5000) {
            top->cont1_key = 0x2;  // dpad_down
        } else if (main_time == 8000) {
            top->cont1_key = 0x4;  // dpad_left
        } else if (main_time == 11000) {
            top->cont1_key = 0x8;  // dpad_right
        } else if (main_time == 14000) {
            top->cont1_key = 0x0;  // Release all keys
        }
        
        // Test video control signals
        if (main_time == 10000) {
            top->video_resetframe_s = 1;
        } else if (main_time == 10002) {
            top->video_resetframe_s = 0;
        }
        
        // Evaluate
        top->eval();
        
        // Dump trace
        tfp->dump(main_time);
        
        main_time++;
    }
    
    top->final();
    tfp->close();
    
    delete top;
    delete tfp;
    
    std::cout << "Simulation completed. Trace saved to ngy_core_top_tb.vcd" << std::endl;
    
    return 0;
}
