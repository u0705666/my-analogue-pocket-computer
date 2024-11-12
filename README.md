This repo represents my personal attemp to create a riscv computer

It based on analogue pocket example on their github website
https://github.com/open-fpga/core-example-interact

I may have other things to disctract so I don't know when I will be distracted and when I can get back to this work again. so I will document everything I've for this repo here.


Module list:

core_top: the top module for analogue pocket core
ngycore/ngy_computer_top: the top module for my riscv computer. enclosed by core_top
riscv: folder contains the actual design of riscv cpu

How to verify the design with icarus verilog
 - file_list.txt contains a list of verilog files to be compiled
 - run compile.sh to compile the verilog files
 - run run.sh to run the simulation

How to compile the design with intel quartus lite
- in core/riscv/instruction_memory.v
uncomment the readmem line that contains the path pointing to the environment where quartus is running
- compile and run the source code in quartus.

How to deploy the core to analogue pocket
- after compile the code in quartus, in the output_files folder, run reverse_rbf_mac to revert the ap_core.rbf to byte reversed bitstream.rbf_r
- copy the bitstream.rbf_r to core/ngycore folder on analogue pocket and overwrite the exsiting bitstream_rbf_r