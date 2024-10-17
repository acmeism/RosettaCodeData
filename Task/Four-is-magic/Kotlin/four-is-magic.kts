// version 1.1.4-3

val names = mapOf(
    1 to "one",
    2 to "two",
    3 to "three",
    4 to "four",
    5 to "five",
    6 to "six",
    7 to "seven",
    8 to "eight",
    9 to "nine",
    10 to "ten",
    11 to "eleven",
    12 to "twelve",
    13 to "thirteen",
    14 to "fourteen",
    15 to "fifteen",
    16 to "sixteen",
    17 to "seventeen",
    18 to "eighteen",
    19 to "nineteen",
    20 to "twenty",
    30 to "thirty",
    40 to "forty",
    50 to "fifty",
    60 to "sixty",
    70 to "seventy",
    80 to "eighty",
    90 to "ninety"
)
val bigNames = mapOf(
    1_000L to "thousand",
    1_000_000L to "million",
    1_000_000_000L to "billion",
    1_000_000_000_000L to "trillion",
    1_000_000_000_000_000L to "quadrillion",
    1_000_000_000_000_000_000L to "quintillion"
)

fun numToText(n: Long): String {
    if (n == 0L) return "zero"
    val neg = n < 0L
    val maxNeg = n == Long.MIN_VALUE
    var nn = if (maxNeg) -(n + 1) else if (neg) -n else n
    val digits3 = IntArray(7)
    for (i in 0..6) {  // split number into groups of 3 digits from the right
        digits3[i] = (nn % 1000).toInt()
        nn /= 1000
    }

    fun threeDigitsToText(number: Int) : String {
        val sb = StringBuilder()
        if (number == 0) return ""
        val hundreds = number / 100
        val remainder = number % 100
        if (hundreds > 0) {
            sb.append(names[hundreds], " hundred")
            if (remainder > 0) sb.append(" ")
        }
        if (remainder > 0) {
            val tens = remainder / 10
            val units = remainder % 10
            if (tens > 1) {
                sb.append(names[tens * 10])
                if (units > 0) sb.append("-", names[units])
            }
            else sb.append(names[remainder])
        }
        return sb.toString()
    }

    val strings = Array<String>(7) { threeDigitsToText(digits3[it]) }
    var text = strings[0]
    var big = 1000L
    for (i in 1..6) {
        if (digits3[i] > 0) {
            var text2 = strings[i] + " " + bigNames[big]
            if (text.length > 0) text2 += " "
            text = text2 + text
        }
        big *= 1000
    }
    if (maxNeg) text = text.dropLast(5) + "eight"
    if (neg) text = "negative " + text
    return text
}

fun fourIsMagic(n: Long): String {
    if (n == 4L) return "Four is magic."
    var text = numToText(n).capitalize()
    val sb = StringBuilder()
    while (true) {
        val len = text.length.toLong()
        if (len == 4L) return sb.append("$text is four, four is magic.").toString()
        val text2 = numToText(len)
        sb.append("$text is $text2, ")
        text = text2
    }
}

fun main(args: Array<String>) {
    val la = longArrayOf(0, 4, 6, 11, 13, 75, 100, 337, -164, 9_223_372_036_854_775_807L)
    for (i in la) {
        println(fourIsMagic(i))
        println()
    }
}
