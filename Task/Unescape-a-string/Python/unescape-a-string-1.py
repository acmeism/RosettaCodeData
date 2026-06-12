#!/usr/bin/python3

class UnescapeError(Exception):
    def __init__(self, message: str, index: int):
        super().__init__(f"{message}, at index {index}")
        self.message = message
        self.index = index
        self.name = "UnescapeError"

def unescape_string(value: str) -> str:
    rv = []
    length = len(value)
    index = 0
    start_index = 0

    while index < length:
        ch = value[index]
        if ch == "\\":
            index += 1  # Move past '\'

            if index >= length:
                raise UnescapeError("incomplete escape sequence", index - 1)

            if value[index] == '"':
                rv.append('"')
            elif value[index] == "\\":
                rv.append("\\")
            elif value[index] == "/":
                rv.append("/")
            elif value[index] == "b":
                rv.append("\x08")
            elif value[index] == "f":
                rv.append("\x0C")
            elif value[index] == "n":
                rv.append("\n")
            elif value[index] == "r":
                rv.append("\r")
            elif value[index] == "t":
                rv.append("\t")
            elif value[index] == "u":
                start_index = index - 1
                codepoint, index = decode_hex_char(value, index)
                rv.append(string_from_code_point(codepoint, start_index))
            else:
                raise UnescapeError("unknown escape sequence", index - 1)
        else:
            rv.append(ch)

        index += 1

    return "".join(rv)

def decode_hex_char(value: str, index: int) -> (int, int):
    length = len(value)

    if index + 4 >= length:
        raise UnescapeError("incomplete escape sequence", index - 1)

    index += 1  # Move past 'u'
    codepoint = parse_hex_digits(value[index:index + 4], index - 2)

    if is_low_surrogate(codepoint):
        raise UnescapeError("unexpected low surrogate code point", index - 2)

    if is_high_surrogate(codepoint):
        if not (index + 9 < length and value[index + 4] == "\\" and value[index + 5] == "u"):
            raise UnescapeError("incomplete escape sequence", index - 2)

        low_surrogate = parse_hex_digits(value[index + 6:index + 10], index + 4)

        if not is_low_surrogate(low_surrogate):
            raise UnescapeError("unexpected code point", index + 4)

        codepoint = 0x10000 + (((codepoint & 0x03ff) << 10) | (low_surrogate & 0x03ff))

        return codepoint, index + 9

    return codepoint, index + 3

def parse_hex_digits(digits: str, index: int) -> int:
    codepoint = 0
    for digit in digits:
        codepoint <<= 4
        if '0' <= digit <= '9':
            codepoint |= ord(digit) - ord('0')
        elif 'A' <= digit <= 'F':
            codepoint |= ord(digit) - ord('A') + 10
        elif 'a' <= digit <= 'f':
            codepoint |= ord(digit) - ord('a') + 10
        else:
            raise UnescapeError("invalid \\uXXXX escape sequence", index)
    return codepoint

def string_from_code_point(codepoint: int, index: int) -> str:
    if codepoint is None or codepoint <= 0x1f:
        raise UnescapeError("invalid character", index)

    try:
        return chr(codepoint)
    except ValueError:
        raise UnescapeError("invalid escape sequence", index)

def is_high_surrogate(codepoint: int) -> bool:
    return 0xd800 <= codepoint <= 0xdbff

def is_low_surrogate(codepoint: int) -> bool:
    return 0xdc00 <= codepoint <= 0xdfff

# Test cases
test_cases = [
    "abc",
    "a☺c",
    'a\\"c',
    "\\u0061\\u0062\\u0063",
    "a\\\\c",
    "a\\u263Ac",
    "a\\\\u263Ac",
    "a\\uD834\\uDD1Ec",
    "a\\ud834\\udd1ec",
    "a\\u263",
    "a\\u263Xc",
    "a\\uDD1Ec",
    "a\\uD834c",
    "a\\uD834\\u263Ac",
]

for s in test_cases:
    try:
        print(f"{s} -> {unescape_string(s)}")
    except UnescapeError as err:
        print(f"{s} -> {err}")
