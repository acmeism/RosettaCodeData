// version 1.0.6

fun min(x: Int, y: Int) = if (x < y) x else y

fun convertToBase(n: Int, b: Int): String {
    if (n < 2 || b < 2 || b == 10 || b > 36) return n.toString() // leave as decimal
    val sb = StringBuilder()
    var digit: Int
    var nn = n
    while (nn > 0) {
        digit = nn % b
        if (digit < 10) sb.append(digit)
        else            sb.append((digit + 87).toChar())
        nn /= b
    }
    return sb.reverse().toString()
}

fun convertToDecimal(s: String, b: Int): Int {
    if (b !in 2..36) throw IllegalArgumentException("Base must be between 2 and 36")
    if (b == 10) return s.toInt()
    val t = s.toLowerCase()
    var result = 0
    var digit: Int
    var multiplier = 1
    for (i in t.length - 1 downTo 0) {
        digit = -1
        if (t[i] >= '0' && t[i] <= min(57, 47 + b).toChar())
            digit = t[i].toInt() - 48
        else if (b > 10 && t[i] >= 'a' && t[i] <= min(122, 87 + b).toChar())
            digit = t[i].toInt() - 87
        if (digit == -1) throw IllegalArgumentException("Invalid digit present")
        if (digit > 0) result += multiplier * digit
        multiplier *= b
    }
    return result
}

fun main(args: Array<String>) {
    for (b in 2..36) {
        val s = convertToBase(36, b)
        val f = "%2d".format(b)
        println("36 base $f = ${s.padEnd(6)} -> base $f = ${convertToDecimal(s, b)}")
    }
}
