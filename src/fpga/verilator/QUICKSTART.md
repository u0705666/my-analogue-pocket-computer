# Verilator Quick Start Guide

## Installation

### macOS
```bash
brew install verilator
```

### Linux (Ubuntu/Debian)
```bash
sudo apt-get install verilator
```

### Verify Installation
```bash
verilator --version
```

## Running Your First Test

### 1. Test a Simple Module (ALU)

```bash
cd src/fpga/verilator
make MODULE=Alu run
```

This will:
- Compile the Alu module and its dependencies
- Run the testbench
- Generate `Alu_tb.vcd` waveform file
- Print test results

### 2. Test the Display Module

```bash
make MODULE=display run
```

### 3. View Waveforms

Install GTKWave:
```bash
# macOS
brew install gtkwave

# Linux
sudo apt-get install gtkwave
```

Then view waveforms:
```bash
gtkwave Alu_tb.vcd
```

## Basic Workflow

1. **Create a C++ testbench** (`<module>_tb.cpp`)
   - See `Alu_tb.cpp` for a simple example
   - See `display_tb.cpp` for a clocked module example

2. **Update Makefile** (if needed)
   - Add module sources to the appropriate `*_SRCS` variable
   - Add module name to the conditional section

3. **Build and run**:
   ```bash
   make MODULE=<your_module> run
   ```

## Common Commands

```bash
# Build only (don't run)
make MODULE=Alu

# Clean build artifacts
make clean

# Run specific module
make MODULE=display run

# Get help
make help
```

## Troubleshooting

### "Module not found"
- Check that the module name matches the filename
- Ensure all dependencies are listed in Makefile

### "Undefined reference"
- Add missing source files to Makefile
- Check include paths (`-I` flags)

### "Compilation errors"
- Some vendor-specific code (like PLLs) may need stubs
- Use `--no-timing` flag for timing-unsupported constructs

## Next Steps

- Read `README.md` for detailed documentation
- Check existing testbenches for examples
- Create your own testbench following the patterns shown
