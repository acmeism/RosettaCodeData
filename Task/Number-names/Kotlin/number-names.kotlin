// version 1.1.2

val oneNames = listOf(
        "", "one", "two", "three", "four",
        "five", "six", "seven", "eight", "nine",
        "ten", "eleven", "twelve", "thirteen", "fourteen",
        "fifteen", "sixteen", "seventeen", "eighteen", "nineteen")
val tenNames = listOf(
        "", "", "twenty", "thirty", "forty",
        "fifty", "sixty", "seventy", "eighty", "ninety")
val thousandNames = listOf(
        "", "thousand", "million", "billion", "trillion", "quadrillion",
        "quintillion")

fun numToText(n: Long, uk: Boolean = false): String {
    if (n == 0L) return "zero"
    val neg = n < 0L
    val maxNeg = n == Long.MIN_VALUE
    var nn = if (maxNeg) -(n + 1) else if (neg) -n else n
    val digits3 = IntArray(7)
    for (i in 0..6) {  // split number into groups of 3 digits from the right
        digits3[i] = (nn % 1000).toInt()
        nn /= 1000
    }
    if (maxNeg) digits3[0]++

    fun threeDigitsToText(number: Int): String {
        val sb = StringBuilder()
        if (number == 0) return ""
        val hundreds = number / 100
        val remainder = number % 100
        if (hundreds > 0) {
            sb.append(oneNames[hundreds], " hundred")
            if (remainder > 0) sb.append(if (uk) " and " else " ")
        }
        if (remainder > 0) {
            val tens = remainder / 10
            val units = remainder % 10
            if (tens > 1) {
                sb.append(tenNames[tens])
                if (units > 0) sb.append("-", oneNames[units])
            } else sb.append(oneNames[remainder])
        }
        return sb.toString()
    }

    val triplets = Array(7) { threeDigitsToText(digits3[it]) }
    var text = triplets[0]
    var andNeeded = uk && digits3[0] in 1..99
    for (i in 1..6) {
        if (digits3[i] > 0) {
            var text2 = triplets[i] + " " + thousandNames[i]
            if (text != "") {
                text2 += if (andNeeded) " and " else ", "
                andNeeded = false
            } else andNeeded = uk && digits3[i] in 1..99
            text = text2 + text
        }
    }
    return (if (neg) "minus " else "") + text
}

fun main() {
    val exampleNumbers = longArrayOf(
            0, 1, 7, 10, 18, 22, 67, 99, 100, 105, 999, -1056, 1000005000,
            2074000000, 1234000000745003L, Long.MIN_VALUE
    )
    println("Using US representation:")
    for (i in exampleNumbers) println("${"%20d".format(i)} = ${numToText(i)}")
    println()
    println("Using UK representation:")
    for (i in exampleNumbers) println("${"%20d".format(i)} = ${numToText(i, true)}")
}
