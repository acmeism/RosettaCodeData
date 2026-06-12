from typing import Tuple
from typing import ByteString


class UnescapeError(Exception):
    pass


def is_high_surrogate(code_point: int) -> bool:
    return code_point >= 0xD800 and code_point <= 0xDBFF


def is_low_surrogate(code_point: int) -> bool:
    return code_point >= 0xDC00 and code_point <= 0xDFFF


def parse_hex_digits(digits: ByteString) -> int:
    code_point = 0
    for digit in digits:
        code_point <<= 4
        if digit >= 48 and digit <= 57:
            code_point |= digit - 48
        elif digit >= 65 and digit <= 70:
            code_point |= digit - 65 + 10
        elif digit >= 97 and digit <= 102:
            code_point |= digit - 97 + 10
        else:
            raise UnescapeError("invalid \\uXXXX escape sequence")
    return code_point


def utf8_encode(code_point: int) -> ByteString:
    _bytes = bytearray()

    if code_point <= 0x7F:
        _bytes.append(code_point & 0x7F)
    elif code_point <= 0x7FF:
        _bytes.append(0xC0 | ((code_point >> 6) & 0x1F))
        _bytes.append(0x80 | (code_point & 0x3F))
    elif code_point <= 0xFFFF:
        _bytes.append(0xE0 | ((code_point >> 12) & 0x0F))
        _bytes.append(0x80 | ((code_point >> 6) & 0x3F))
        _bytes.append(0x80 | (code_point & 0x3F))
    elif code_point <= 0x10FFFF:
        _bytes.append(0xF0 | ((code_point >> 18) & 0x07))
        _bytes.append(0x80 | ((code_point >> 12) & 0x3F))
        _bytes.append(0x80 | ((code_point >> 6) & 0x3F))
        _bytes.append(0x80 | (code_point & 0x3F))
    else:
        raise UnescapeError("invalid code point")

    return _bytes


def decode_escape_sequence(value: ByteString, index: int) -> Tuple[int, int]:
    byte = value[index]
    if byte == 0x22:
        return 0x22, index
    if byte == 0x5C:
        return 0x5C, index
    if byte == 0x2F:
        return 0x2F, index
    if byte == 0x62:
        return 0x08, index
    if byte == 0x66:
        return 0x0C, index
    if byte == 0x6E:
        return 0x0A, index
    if byte == 0x72:
        return 0x0D, index
    if byte == 0x74:
        return 0x09, index
    if byte == 0x75:
        code_point, index = decode_hex_char(value, index)
        return code_point, index

    raise UnescapeError("unknown escape sequence at")


def decode_hex_char(value: ByteString, index: int) -> Tuple[int, int]:
    length = len(value)

    if index + 4 >= length:
        raise UnescapeError("incomplete escape sequence")

    index += 1  # move past 'u'
    code_point = parse_hex_digits(value[index : index + 4])

    if is_low_surrogate(code_point):
        raise UnescapeError("unexpected low surrogate")

    if is_high_surrogate(code_point):
        # expect a surrogate pair
        if not (
            index + 9 < length and value[index + 4] == 0x5C and value[index + 5] == 0x75
        ):
            raise UnescapeError("incomplete escape sequence at index")

        low_surrogate = parse_hex_digits(value[index + 6 : index + 10])

        if not is_low_surrogate(low_surrogate):
            raise UnescapeError(
                "unexpected code point",
            )

        code_point = 0x10000 + (
            ((code_point & 0x03FF) << 10) | (low_surrogate & 0x03FF)
        )
        return (code_point, index + 9)

    return (code_point, index + 3)


def unescape(value: ByteString) -> ByteString:
    unescaped = bytearray()
    index = 0
    length = len(value)

    while index < length:
        byte = value[index]
        if byte == 0x5C:
            index += 1  # Move past '\'
            code_point, index = decode_escape_sequence(value, index)
            unescaped.extend(utf8_encode(code_point))
        else:
            # Find invalid characters.
            # Bytes that are less than 0x1f and not a continuation byte.
            if (byte & 0x80) == 0:
                # Single-byte code point
                if byte <= 0x1F:
                    raise UnescapeError("invalid character")
                unescaped.append(byte)
            elif (byte & 0xE0) == 0xC0:
                # Two-byte code point
                if index + 1 > length:
                    raise UnescapeError("invalid code point")
                unescaped.extend(value[index : index + 2])
                index += 1
            elif (byte & 0xF0) == 0xE0:
                # Three-byte code point
                if index + 2 > length:
                    raise UnescapeError("invalid code point")
                unescaped.extend(value[index : index + 3])
                index += 2
            elif (byte & 0xF8) == 0xF0:
                # Four-byte code point
                if index + 3 > length:
                    raise UnescapeError("invalid code point")
                unescaped.extend(value[index : index + 4])
                index += 3
            else:
                raise UnescapeError("invalid character")

        index += 1

    return unescaped


test_cases = [
    rb"abc",
    b"a\xe2\x98\xbac",
    rb'a\\"c',
    rb"\u0061\u0062\u0063",
    b"a\\\\c",
    rb"a\u263Ac",
    rb"a\\u263Ac",
    rb"a\uD834\uDD1Ec",
    rb"a\ud834\udd1ec",
    rb"a\u263",
    rb"a\u263Xc",
    rb"a\uDD1Ec",
    rb"a\uD834c",
    rb"a\uD834\u263Ac",
]

if __name__ == "__main__":
    for _bytes in test_cases:
        try:
            unescaped = unescape(_bytes)
            print(f"{_bytes.hex(' '):<54} -> {unescaped.hex(' ')}")
        except UnescapeError as err:
            print(f"{_bytes.hex(' '):<54} -> {err}")
