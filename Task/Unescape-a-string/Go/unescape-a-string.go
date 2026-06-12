package main

import (
	//"errors"
	"fmt"
	//"strconv"
	"strings"
)

type UnescapeError struct {
	message string
}

func (e *UnescapeError) Error() string {
	return e.message
}

func parseHexDigits(digits string) (int32, error) {
	codePoint := int32(0)

	for _, digit := range digits {
		codePoint <<= 4
		switch {
		case '0' <= digit && digit <= '9':
			codePoint |= int32(digit - '0')
		case 'a' <= digit && digit <= 'f':
			codePoint |= int32(digit - 'a' + 10)
		case 'A' <= digit && digit <= 'F':
			codePoint |= int32(digit - 'A' + 10)
		default:
			return 0, &UnescapeError{"invalid \\uXXXX escape"}
		}
	}
	return codePoint, nil
}

func isHighSurrogate(codePoint int32) bool {
	return codePoint >= 0xD800 && codePoint <= 0xDBFF
}

func isLowSurrogate(codePoint int32) bool {
	return codePoint >= 0xDC00 && codePoint <= 0xDFFF
}

func encodeUTF8(codePoint int32) (string, error) {
	if codePoint <= 0x7F {
		// Single-byte UTF-8
		return string(codePoint & 0x7F), nil
	} else if codePoint <= 0x7FF {
		// Two-byte UTF-8
		return string([]byte{
			byte(0xC0 | ((codePoint >> 6) & 0x1F)),
			byte(0x80 | (codePoint & 0x3F)),
		}), nil
	} else if codePoint <= 0xFFFF {
		// Three-byte UTF-8
		return string([]byte{
			byte(0xE0 | ((codePoint >> 12) & 0x0F)),
			byte(0x80 | ((codePoint >> 6) & 0x3F)),
			byte(0x80 | (codePoint & 0x3F)),
		}), nil
	} else if codePoint <= 0x10FFFF {
		// Four-byte UTF-8
		return string([]byte{
			byte(0xF0 | ((codePoint >> 18) & 0x07)),
			byte(0x80 | ((codePoint >> 12) & 0x3F)),
			byte(0x80 | ((codePoint >> 6) & 0x3F)),
			byte(0x80 | (codePoint & 0x3F)),
		}), nil
	} else {
		return "", &UnescapeError{"invalid code point"}
	}
}

func unescapeJSONString(s string) (string, error) {
	var result strings.Builder
	var b byte
	var codePoint int32
	index := 0
	length := len(s)

	for index < length {
		b = s[index]
		index++

		if b == '\\' {
			if index < length {
				b = s[index]
				index++
			} else {
				return "", &UnescapeError{"invalid escape"}
			}

			switch b {
			case '"':
				result.WriteByte('"')
			case '\\':
				result.WriteByte('\\')
			case '/':
				result.WriteByte('/')
			case 'b':
				result.WriteByte('\b')
			case 'f':
				result.WriteByte('\f')
			case 'n':
				result.WriteByte('\n')
			case 'r':
				result.WriteByte('\r')
			case 't':
				result.WriteByte('\t')
			case 'u':
				// Decode 4 hex digits.
				if index+4 > length {
					return "", &UnescapeError{"invalid \\uXXXX escape"}
				}

				var err error
				codePoint, err = parseHexDigits(s[index : index+4])
				if err != nil {
					return "", err
				}
				index += 4

				if isLowSurrogate(codePoint) {
					return "", &UnescapeError{"unexpected low surrogate code point"}
				}

				if isHighSurrogate(codePoint) {
					if !(index+6 <= length && s[index] == '\\' && s[index+1] == 'u') {
						return "", &UnescapeError{"incomplete escape sequence"}
					}

					lowSurrogate, err := parseHexDigits(s[index+2 : index+6])
					if err != nil {
						return "", err
					}
					index += 6

					if !isLowSurrogate(lowSurrogate) {
						return "", &UnescapeError{"unexpected code point"}
					}

					// Combine high and low surrogates into a Unicode code point.
					codePoint = 0x10000 + (((codePoint & 0x03FF) << 10) | (lowSurrogate & 0x03FF))
				}

				utf8Str, err := encodeUTF8(codePoint)
				if err != nil {
					return "", err
				}
				result.WriteString(utf8Str)
			default:
				return "", &UnescapeError{"invalid escape"}
			}
		} else {
			// Check for invalid characters
			if (b & 0x80) == 0 {
				// Single-byte code point
				if b <= 0x1F {
					return "", &UnescapeError{"invalid character"}
				}
				result.WriteByte(b)
			} else if (b & 0xE0) == 0xC0 {
				// Two-byte code point
				if index+1 > length {
					return "", &UnescapeError{"invalid code point"}
				}
				result.WriteByte(b)
				result.WriteByte(s[index])
				index++
			} else if (b & 0xF0) == 0xE0 {
				// Three-byte code point
				if index+2 > length {
					return "", &UnescapeError{"invalid code point"}
				}
				result.WriteByte(b)
				result.WriteByte(s[index])
				result.WriteByte(s[index+1])
				index += 2
			} else if (b & 0xF8) == 0xF0 {
				// Four-byte code point
				if index+3 > length {
					return "", &UnescapeError{"invalid code point"}
				}
				result.WriteByte(b)
				result.WriteByte(s[index])
				result.WriteByte(s[index+1])
				result.WriteByte(s[index+2])
				index += 3
			} else {
				return "", &UnescapeError{"invalid character"}
			}
		}
	}

	return result.String(), nil
}

func main() {
	testCases := []string{
		"abc",
		"a\xE2\x98\xBAc",
		"a\\\"c",
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
	}

	for _, str := range testCases {
		unescaped, err := unescapeJSONString(str)
		if err != nil {
			fmt.Printf("%s -> %s\n", str, err.Error())
		} else {
			fmt.Printf("%s -> %s\n", str, unescaped)
		}
	}
}
