class UnescapeError {
    construct new (text, index) {
        _message = text + ", at index %(index)"
    }

    toString { _message }
}

var isHighSurrogate = Fn.new { |cp| cp >= 0xd800 && cp <= 0xdbff }

var isLowSurrogate  = Fn.new { |cp| cp >= 0xdc00 && cp <= 0xdfff }

/* Check the codepoint is valid and return its string representation. */
var stringFromCodePoint = Fn.new { |cp, index|
    if (cp > 0x10ffff || cp <= 0x1f) {
        return UnescapeError.new("invalid character", index)
    }
    return String.fromCodePoint(cp)
}

/* Parse a list of hexadecimal digits as an integer. */
var parseHexDigits = Fn.new { |digits, index|
    var cp = 0
    for (digit in digits.join("").bytes) {
        cp = cp << 4
        if (digit >= 48 && digit <= 57) {
            cp = cp | (digit - 48)      // '0'
        } else if (digit >= 65 && digit <= 70) {
            cp = cp | (digit - 65 + 10) // 'A'
        } else if (digit >= 97 && digit <= 102) {
            cp = cp | (digit - 97 + 10) // 'a'
        } else {
            return UnescapeError.new("invalid \\uXXXX escape sequence", index)
        }
    }
    return cp
}

/* Decode a `\uXXXX` or `\uXXXX\uXXXX` escape sequence from character at index. */
var decodeHexChar = Fn.new { |chars, index|
    var length = chars.count
    if (index + 4 >= length) {
        return UnescapeError.new("incomplete escape sequence", index - 1)
    }
    index = index + 1 // Move past 'u'
    //var chars = value.toList
    var cp = parseHexDigits.call(chars[index...index+4], index - 2)
    if (cp is UnescapeError) return cp
    if (isLowSurrogate.call(cp)) {
        return UnescapeError.new("unexpected low surrogate code point", index - 2)
    }
    if (isHighSurrogate.call(cp)) {
        // Expect a surrogate pair
        if (!(index + 9 < length && chars[index + 4] == "\\" && chars[index + 5] == "u")) {
            return UnescapeError.new("incomplete escape sequence", index - 2)
        }
        var lowSurrogate = parseHexDigits.call(chars[index+6...index+10], index + 4)
        if (lowSurrogate is UnescapeError) return lowSurrogate
        if (!isLowSurrogate.call(lowSurrogate)) {
            return UnescapeError.new("unexpected code point", index + 4)
        }
        cp = 0x10000 + (((cp & 0x03ff) << 10) | (lowSurrogate & 0x03ff))
        return [cp, index + 9]
    }
    return [cp, index + 3]
}

/* Unescape a JSON-like string value. */
var unescapeString = Fn.new { |value|
    var rv = []
    var index = 0
    var startIndex = 0
    var chars = value.toList
    var length = chars.count
    while (index < length) {
        var ch = chars[index]
        if (ch == "\\") {
            index = index + 1 // Move past '\'
            ch = chars[index]
            if (ch == "\"") {
                rv.add("\"")
            } else if (ch == "\\") {
                rv.add("\\")
            } else if (ch == "/") {
                rv.add("/")
            } else if (ch == "b") {
                rv.add("\b")
            } else if (ch == "f") {
                rv.add("\f")
            } else if (ch == "n") {
                rv.add("\n")
            } else if (ch == "r") {
                rv.add("\r")
            } else if (ch == "t") {
                rv.add("\t")
            } else if (ch == "u") {
                startIndex = index - 1
                var res = decodeHexChar.call(chars, index)
                if (res is UnescapeError) return res
                var cp = res[0]
                index = res[1]
                var s = stringFromCodePoint.call(cp, startIndex)
                if (s is UnescapeError) return s
                rv.add(s)
            } else {
                return UnescapeError.new("unknown escape sequence",  index)
            }
        } else {
            var s = stringFromCodePoint.call(ch.codePoints[0], index)
            if (s is UnescapeError) return s
            rv.add(ch)
        }
        index = index + 1
    }
    return rv.join("")
}

var testCases = [
  "abc",
  "a☺c",
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
]

for (s in testCases) {
    var us = unescapeString.call(s)
    System.print("%(s) -> %(us)")
}
