"""GS byte string translation using an exhaustive map and regex reverse lookup.

Requires Python >= 3.9.
"""
import re
from typing import Optional

TABLE: dict[int, bytes] = {
    0: b"|@",
    **{byte: f"|{chr(byte+64)}".encode() for byte in range(1, 27)},
    27: b"|[",
    28: b"|\\",
    29: b"|]",
    30: b"|^",
    31: b"|_",
    **{byte: chr(byte).encode() for byte in range(32, 127)},
    34: b'|"',
    60: b"|<",
    124: b"||",
    127: b"|?",
}

# 128 - 255
TABLE.update({byte: b"|!" + TABLE[byte - 128] for byte in range(128, 256)})

REVERSE_LOOKUP: dict[bytes, int] = {
    **{v: k for k, v in TABLE.items()},
    b"|{": 27,
    b"|}": 29,
    b"|~": 30,
    b"|`": 31, # aka backtick
    **{f"|{chr(byte+96)}".encode(): byte for byte in range(1, 27)},
}

RE = re.compile(b"|".join(re.escape(s) for s in REVERSE_LOOKUP) + b"|.")


def gs_trans_encode(s: bytes) -> bytes:
    return b"".join(TABLE[byte] for byte in s)


def gs_trans_decode(s: bytes, default: Optional[int] = None) -> bytes:
    if default is None:
        return bytes(REVERSE_LOOKUP[seq] for seq in RE.findall(s))
    return bytes(REVERSE_LOOKUP.get(seq, default) for seq in RE.findall(s))


examples: list[bytes] = [
    b"\x0CHello\x07\n\r",
    b"\r\n\0\x05\xF4\r\xFF",
]

if __name__ == "__main__":
    for example in examples:
        encoded = gs_trans_encode(example)
        print(f"{example!r} -> {encoded!r}")
        assert gs_trans_decode(encoded) == example
