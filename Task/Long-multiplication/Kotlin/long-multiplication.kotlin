fun String.toDigits() = mapIndexed { i, c ->
    if (!c.isDigit())
        throw IllegalArgumentException("Invalid digit $c found at position $i")
    c - '0'
}.reversed()

operator fun String.times(n: String): String {
    val left = toDigits()
    val right = n.toDigits()
    val result = IntArray(left.size + right.size)

    right.mapIndexed { rightPos, rightDigit ->
        var tmp = 0
        left.indices.forEach { leftPos ->
            tmp += result[leftPos + rightPos] + rightDigit * left[leftPos]
            result[leftPos + rightPos] = tmp % 10
            tmp /= 10
        }
        var destPos = rightPos + left.size
        while (tmp != 0) {
            tmp += (result[destPos].toLong() and 0xFFFFFFFFL).toInt()
            result[destPos] = tmp % 10
            tmp /= 10
            destPos++
        }
    }

    return result.foldRight(StringBuilder(result.size), { digit, sb ->
        if (digit != 0 || sb.length > 0) sb.append('0' + digit)
        sb
    }).toString()
}

fun main(args: Array<out String>) {
    println("18446744073709551616" * "18446744073709551616")
}
