#!/usr/bin/env python3
import struct
from pathlib import Path

OP_CLEAR = 0x01
OP_PLOT = 0x02
OP_LINE = 0x03
OP_RECT = 0x04
OP_END = 0xFF


def w32(v: int) -> bytes:
    return struct.pack("<I", v & 0xFFFFFFFF)


def cmd(opcode: int, *args: int) -> bytes:
    blob = w32((opcode & 0xFF) << 24)
    for a in args:
        blob += w32(a)
    return blob


def main() -> None:
    out = bytearray()

    # CLEAR: dark blue background
    out += cmd(OP_CLEAR, 0x0010)

    # RECT: white border (x=8,y=8,w=304,h=272,outline)
    out += cmd(OP_RECT, 8, 8, 304, 272, 0xFFFF, 0)

    # LINE diagonals in green
    out += cmd(OP_LINE, 0, 0, 319, 287, 0x07E0)
    out += cmd(OP_LINE, 319, 0, 0, 287, 0x07E0)

    # PLOT center in red
    out += cmd(OP_PLOT, 160, 144, 0xF800)

    # END
    out += cmd(OP_END)

    out_path = Path(__file__).resolve().parent / "slot1_ppu_commands.bin"
    out_path.write_bytes(out)
    print(f"Wrote {len(out)} bytes to {out_path}")


if __name__ == "__main__":
    main()
