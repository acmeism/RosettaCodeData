"""Consistent overhead byte stuffing. Requires Python >= 3.10."""

from itertools import islice


def cob_encode(data: bytes | bytearray) -> bytearray:
    buffer = bytearray([0])
    code_index = 0
    code = 1
    final_code = True

    for byte in data:
        final_code = True
        if byte:
            buffer.append(byte)
            code += 1

        if not byte or code == 0xFF:
            if code == 0xFF:
                final_code = False

            buffer[code_index] = code
            code = 1
            buffer.append(0)
            code_index = len(buffer) - 1

    if final_code:
        assert not buffer[code_index]
        buffer[code_index] = code

    if buffer[-1]:
        buffer.append(0)

    return buffer


def cob_decode(encoded: bytes | bytearray) -> bytearray:
    buffer = bytearray()
    code = 0xFF
    block = 0

    for byte in islice(encoded, len(encoded) - 1):
        if block:
            buffer.append(byte)
        else:
            if code != 0xFF:
                buffer.append(0)

            block = code = byte

            if not code:
                break

        block -= 1

    return buffer


EXAMPLES = [
    (bytearray.fromhex("00"), bytearray.fromhex("01 01 00")),
    (bytearray.fromhex("00 00"), bytearray.fromhex("01 01 01 00")),
    (bytearray.fromhex("00 11 00"), bytearray.fromhex("01 02 11 01 00")),
    (bytearray.fromhex("11 22 00 33"), bytearray.fromhex("03 11 22 02 33 00")),
    (bytearray.fromhex("11 22 33 44"), bytearray.fromhex("05 11 22 33 44 00")),
    (bytearray.fromhex("11 00 00 00"), bytearray.fromhex("02 11 01 01 01 00")),
    (
        bytearray(range(0x01, 0xFE + 1)),
        bytearray([0xFF, *range(1, 0xFE + 1), 0x00]),
    ),
    (
        bytearray(range(0x00, 0xFE + 1)),
        bytearray([0x01, 0xFF, *range(1, 0xFE + 1), 0x00]),
    ),
    (
        bytearray(range(1, 0xFF + 1)),
        bytearray([0xFF, *range(1, 0xFE + 1), 0x02, 0xFF, 0x00]),
    ),
    (
        bytearray([*range(0x02, 0xFF + 1), 0x00]),
        bytearray([0xFF, *range(2, 0xFF + 1), 0x01, 0x01, 0x00]),
    ),
    (
        bytearray([*range(0x03, 0xFF + 1), 0x00, 0x01]),
        bytearray([0xFE, *range(0x03, 0xFF + 1), 0x02, 0x01, 0x00]),
    ),
]


def pretty_hex(bytes: bytearray, m: int, n: int) -> str:
    if len(bytes) < m:
        return bytes.hex(" ").upper()
    return f"{bytes[:n].hex(' ').upper()} ... {bytes[-n:].hex(' ').upper()}"


def main():
    for data, expect in EXAMPLES:
        encoded = cob_encode(data)
        assert encoded == expect
        assert cob_decode(encoded) == data
        print(f"{pretty_hex(data, 5, 3):<23} -> {pretty_hex(encoded, 7, 4):<33}")


if __name__ == "__main__":
    main()
