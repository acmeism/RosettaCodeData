class UnescapeException(message: String) : Exception(message)

data class DecodeResult(val codePoint: Int, val index: Int)

object CodeKt {

    @JvmStatic
    fun main(args: Array<String>) {
        val tests = listOf(
            "abc", "a☺c", "a\\\"c", "\\u0061\\u0062\\u0063", "a\\\\c",
            "a\\u263Ac", "a\\\\u263Ac", "a\\uD834\\uDD1Ec", "a\\ud834\\udd1ec",
            "a\\u263", "a\\u263Xc", "a\\uDD1Ec", "a\\uD834c", "a\\uD834\\u263Ac"
        )

        for (test in tests) {
            try {
                val result = unescapeJSONString(test)
                println("$test => $result")
            } catch (exception: UnescapeException) {
                println("$test => ${exception.message}")
            }
        }
    }

    private fun unescapeJSONString(text: String): String {
        val result = StringBuilder()
        var index = 0

        while (index < text.length) {
            var ch = text[index]

            if (ch == '\\') {
                if (index < text.length - 1) {
                    index++
                    ch = text[index]
                } else {
                    throw UnescapeException("Invalid escape sequence")
                }

                when (ch) {
                    '\"' -> result.append("\"")
                    '\\' -> result.append("\\")
                    '/' -> result.append("/")
                    'b' -> result.append("\b")
                    'f' -> result.append("\u000C") // \f
                    'n' -> result.append("\n")
                    'r' -> result.append("\r")
                    't' -> result.append("\t")
                    'u' -> {
                        val startIndex = index - 1
                        val decodeResult = decodeHexChar(text, index)
                        if (decodeResult.codePoint == -1) {
                            return result.toString()
                        }
                        result.append(stringFromCodePoint(decodeResult.codePoint, startIndex))
                        index = decodeResult.index
                    }
                    else -> throw UnescapeException("Unknown character")
                }
            } else {
                result.append(ch)
            }
            index++
        }
        return result.toString()
    }

    private fun decodeHexChar(text: String, index: Int): DecodeResult {
        if (index >= text.length - 4) {
            throw UnescapeException("Incomplete escape sequence")
        }

        val newIndex = index + 1
        var codepoint = parseHexDigits(text.substring(newIndex, newIndex + 4), index - 2)

        if (isLowSurrogate(codepoint)) {
            throw UnescapeException("Lone low surrogate")
        }

        if (isHighSurrogate(codepoint)) {
            if (!(newIndex < text.length - 9 &&
                text[newIndex + 4] == '\\' && text[newIndex + 5] == 'u')) {
                throw UnescapeException("Lone high surrogate")
            }

            val lowSurrogate = parseHexDigits(text.substring(newIndex + 6, newIndex + 10), newIndex + 4)
            if (!isLowSurrogate(lowSurrogate)) {
                throw UnescapeException("High surrogate followed by a non-surrogate")
            }

            codepoint = 0x10000 + ((codepoint and 0x03ff) shl 10) or (lowSurrogate and 0x03ff)
            return DecodeResult(codepoint, newIndex + 9)
        }

        return DecodeResult(codepoint, newIndex + 3)
    }

    private fun parseHexDigits(digits: String, index: Int): Int {
        var codepoint = 0
        for (digit in digits.toCharArray()) {
            codepoint = codepoint shl 4
            val digitValue = digit.toInt()
            when (digitValue) {
                in 48..57 -> codepoint = codepoint or (digitValue - 48) // 0-9
                in 65..70 -> codepoint = codepoint or (digitValue - 65 + 10) // A-F
                in 97..102 -> codepoint = codepoint or (digitValue - 97 + 10) // a-f
                else -> throw UnescapeException("Invalid hexadecimal digit")
            }
        }
        return codepoint
    }

    private fun isLowSurrogate(i: Int): Boolean = i in 0xdc00..0xdfff
    private fun isHighSurrogate(i: Int): Boolean = i in 0xd800..0xdbff

    private fun stringFromCodePoint(codepoint: Int, index: Int): String {
        if (codepoint > 0x10ffff || codepoint <= 0x1f) {
            throw UnescapeException("Invalid character")
        }
        return codepoint.toChar().toString()
    }
}
