# simple_ppu core files

This folder is the APF core package for `core_simple_ppu`.

## Required runtime file

- Data slot `id=1`: `*.bin` command stream loaded at bridge/SDRAM address `0x00000000`.

## Command format

All values are little-endian 32-bit words.

- Command header word: `opcode` in the top byte (`[31:24]`)
- Follow-up argument words depend on opcode

Opcodes:

- `0x01` CLEAR: `color565`
- `0x02` PLOT: `x`, `y`, `color565`
- `0x03` LINE: `x0`, `y0`, `x1`, `y1`, `color565`
- `0x04` RECT: `x`, `y`, `w`, `h`, `color565`, `fillFlag`
- `0xFF` END: no args

## Generate a sample bin

Run:

`python3 gen_sample_ppu_bin.py`

This creates:

- `slot1_ppu_commands.bin`

The sample program clears the screen, draws a frame rectangle, two diagonals, and a center pixel.
