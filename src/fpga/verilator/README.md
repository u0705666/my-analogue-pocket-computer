# Verilator Verification Guide

This directory contains Verilator-based verification setup for Verilog modules in this project.

## What is Verilator?

Verilator is a free and open-source Verilog HDL simulator that converts synthesizable Verilog code into C++ or SystemC code, which is then compiled into an executable simulation model. It's much faster than traditional event-driven simulators like Icarus Verilog for large designs.

## Prerequisites

1. **Install Verilator**:
   ```bash
   # macOS (using Homebrew)
   brew install verilator
   
   # Linux (Ubuntu/Debian)
   sudo apt-get install verilator
   
   # Or build from source: https://github.com/verilator/verilator
   ```

2. **C++ Compiler**: GCC or Clang with C++11 support

3. **Make**: Standard build tool

## Quick Start

### 1. Basic Usage

To build and run a testbench for a module:

```bash
cd src/fpga/verilator
make MODULE=display run
```

### 2. Available Modules

Currently configured modules:
- `display` - Display module testbench
- `ngy_core_top` - NGY core top-level testbench

### 3. Build Only (without running)

```bash
make MODULE=display
```

The executable will be in `obj_dir/display_sim`

### 4. View Waveforms

After running a simulation, VCD files are generated:
- `display_tb.vcd` - Waveform file for display module
- `ngy_core_top_tb.vcd` - Waveform file for ngy_core_top module

View with GTKWave:
```bash
gtkwave display_tb.vcd
```

## Creating a New Testbench

### Step 1: Create C++ Testbench File

Create a file named `<module>_tb.cpp` in the `verilator` directory:

```cpp
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "V<module_name>.h"  // Verilator generates this header
#include <iostream>

vluint64_t main_time = 0;

double sc_time_stamp() {
    return main_time;
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);
    
    V<module_name>* top = new V<module_name>;
    
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("<module>_tb.vcd");
    
    // Initialize inputs
    top->clk = 0;
    top->reset_n = 0;
    // ... initialize other inputs
    
    // Simulation loop
    while (main_time < SIM_TIME && !Verilated::gotFinish()) {
        // Clock generation
        if (main_time % CLK_PERIOD == 0) {
            top->clk = !top->clk;
        }
        
        // Test stimulus
        if (main_time == RESET_TIME) {
            top->reset_n = 1;
        }
        
        // Evaluate
        top->eval();
        tfp->dump(main_time);
        main_time++;
    }
    
    top->final();
    tfp->close();
    delete top;
    delete tfp;
    
    return 0;
}
```

### Step 2: Update Makefile

Add your module sources to the Makefile:

```makefile
YOUR_MODULE_SRCS = $(CORE_DIR)/your_module.v \
                   $(CORE_DIR)/dependency1.v \
                   $(CORE_DIR)/dependency2.v

# Add to the conditional section
ifeq ($(MODULE),your_module)
    VERILOG_SRCS = $(YOUR_MODULE_SRCS) $(COMMON_SRCS)
endif
```

### Step 3: Build and Run

```bash
make MODULE=your_module run
```

## Verilator vs Icarus Verilog

| Feature | Verilator | Icarus Verilog |
|---------|-----------|----------------|
| Speed | Very fast (compiled) | Slower (interpreted) |
| Language | C++ testbench | Verilog testbench |
| Best for | Large designs, regression testing | Quick debugging, small modules |
| Waveforms | VCD/FST | VCD |

## Common Issues and Solutions

### Issue: Module not found

**Solution**: Check that the module name matches the filename and that all dependencies are listed in the Makefile.

### Issue: Undefined module references

**Solution**: Add missing module source files to the `VERILOG_SRCS` variable in the Makefile.

### Issue: Compilation errors

**Solution**: 
- Check that all include paths are correct (`-I` flags)
- Ensure Verilog code is synthesizable (Verilator only supports synthesizable subset)
- Some vendor-specific primitives (like PLLs) may need stubs or `--no-timing` flag

### Issue: Simulation hangs

**Solution**: 
- Check that clocks are toggling correctly
- Ensure reset is released properly
- Add `$finish` calls in Verilog if needed
- Set appropriate `SIM_TIME` limit

## Advanced Options

### Verilator Flags

Modify `VERILATOR_FLAGS` in the Makefile:

- `--trace`: Enable waveform generation
- `--trace-structs`: Include struct information in traces
- `--no-timing`: Ignore timing constructs (useful for vendor-specific code)
- `-Wno-UNUSED`: Suppress unused signal warnings
- `-CFLAGS "-g"`: Add debug symbols to C++ code

### Performance Optimization

- Use `-O2` or `-O3` in CFLAGS for faster simulation
- Reduce trace depth (`--trace-depth`) if not needed
- Use FST format instead of VCD for smaller files: `--trace-fst`

## Example: Testing a Simple Module

For a simple module like an ALU:

```cpp
// alu_tb.cpp
#include <verilated.h>
#include "Valu.h"

int main() {
    Valu* top = new Valu;
    
    // Test cases
    top->a = 10;
    top->b = 5;
    top->op = 0;  // ADD
    top->eval();
    assert(top->result == 15);
    
    delete top;
    return 0;
}
```

## Integration with CI/CD

You can integrate Verilator tests into your CI pipeline:

```yaml
# Example GitHub Actions
- name: Run Verilator tests
  run: |
    cd src/fpga/verilator
    make MODULE=display run
    make MODULE=ngy_core_top run
```

## Resources

- [Verilator Documentation](https://verilator.org/verilator_doc.html)
- [Verilator GitHub](https://github.com/verilator/verilator)
- [Verilator User's Guide](https://verilator.org/guide/latest/)

## Notes

- Verilator only supports synthesizable Verilog (no `$display`, `$monitor`, etc. in synthesizable code)
- Vendor-specific primitives (like Intel/Altera PLLs) may need stubs or special handling
- For behavioral testbenches, you may still want to use Icarus Verilog
- Verilator is excellent for regression testing and performance-critical simulations
