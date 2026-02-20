# Verilator Makefile for Verilog Verification
# Usage: make MODULE=<module_name> [OPTIONS]

# Default Verilator options
VERILATOR = verilator
VERILATOR_FLAGS = -Wall -Wno-UNOPTFLAT -Wno-UNUSED -Wno-PINMISSING \
                  -Wno-EOFNEWLINE -Wno-DECLFILENAME -Wno-CASEINCOMPLETE -Wno-LATCH \
                  --cc --exe --build --trace \
                  -CFLAGS "-std=c++14 -O2" \
                  -I../core/riscv -I../apf -I../core

# Output directory
OBJ_DIR = obj_dir

# Default module (can be overridden)
MODULE ?= display

# Source files directory
SRC_DIR = ..
CORE_DIR = $(SRC_DIR)/core
APF_DIR = $(SRC_DIR)/apf

# Common source files (adjust based on your module dependencies)
COMMON_SRCS = $(APF_DIR)/common.v

# Module-specific source files
# Add your module sources here
DISPLAY_SRCS = $(CORE_DIR)/display.v $(CORE_DIR)/synch_3.v
NGY_CORE_SRCS = $(CORE_DIR)/ngycore/ngy_core_top.v \
                $(CORE_DIR)/ngycore/ngy_snake_top.v \
                $(CORE_DIR)/ngycore/vga_controller.v \
                $(CORE_DIR)/ngycore/pixel_driver.v \
                $(CORE_DIR)/ngycore/sram.v \
                $(CORE_DIR)/ngycore/clock_divider.v \
                $(CORE_DIR)/riscv/riscv_configs.v

# Testbench C++ files
TB_CPP = $(MODULE)_tb.cpp

# Determine which sources to use
ifeq ($(MODULE),display)
    VERILOG_SRCS = $(DISPLAY_SRCS) $(COMMON_SRCS)
else ifeq ($(MODULE),ngy_core_top)
    VERILOG_SRCS = $(NGY_CORE_SRCS) $(COMMON_SRCS)
else
    # Default: try to find module file
    VERILOG_SRCS = $(shell find $(SRC_DIR) -name "$(MODULE).v") $(COMMON_SRCS)
endif

# Verilator output
VTOP = V$(MODULE)

.PHONY: all clean run

all: $(OBJ_DIR)/$(VTOP)

# Run Verilator to generate C++ model
$(OBJ_DIR)/$(VTOP): $(VERILOG_SRCS) $(TB_CPP)
	@echo "Verilating $(MODULE)..."
	@echo "Sources: $(VERILOG_SRCS)"
	$(VERILATOR) $(VERILATOR_FLAGS) \
		--top-module $(MODULE) \
		$(VERILOG_SRCS) \
		$(TB_CPP) \
		-o $(MODULE)_sim

# Run simulation
run: $(OBJ_DIR)/$(VTOP)
	@echo "Running simulation..."
	./$(OBJ_DIR)/$(MODULE)_sim

# Clean build artifacts
clean:
	rm -rf $(OBJ_DIR)
	rm -f *.vcd *.fst

# Help target
help:
	@echo "Verilator Makefile Usage:"
	@echo "  make MODULE=<module_name>     - Build testbench for specified module"
	@echo "  make MODULE=display run        - Build and run display module testbench"
	@echo "  make clean                    - Clean build artifacts"
	@echo ""
	@echo "Available modules:"
	@echo "  - Alu (simple combinational example)"
	@echo "  - display"
	@echo "  - ngy_core_top"
	@echo ""
	@echo "Example:"
	@echo "  make MODULE=display run"
