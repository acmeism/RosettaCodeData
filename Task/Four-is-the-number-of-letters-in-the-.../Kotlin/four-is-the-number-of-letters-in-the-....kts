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

val irregOrdinals = mapOf(
    "one" to "first",
    "two" to "second",
    "three" to "third",
    "five" to "fifth",
    "eight" to "eighth",
    "nine" to "ninth",
    "twelve" to "twelfth"
)

fun String.toOrdinal(): String {
    if (this == "zero") return "zeroth"  // or alternatively 'zeroeth'
    val splits = this.split(' ', '-')
    val last = splits[splits.lastIndex]
    return if (irregOrdinals.containsKey(last)) this.dropLast(last.length) + irregOrdinals[last]!!
           else if (last.endsWith("y")) this.dropLast(1) + "ieth"
           else this + "th"
}

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

    fun threeDigitsToText(number: Int) : String {
        val sb = StringBuilder()
        if (number == 0) return ""
        val hundreds = number / 100
        val remainder = number % 100
        if (hundreds > 0) {
            sb.append(names[hundreds], " hundred")
            if (remainder > 0) sb.append(if (uk) " and " else " ")
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

    val strings = Array(7) { threeDigitsToText(digits3[it]) }
    var text = strings[0]
    var andNeeded = uk && digits3[0] in 1..99
    var big = 1000L
    for (i in 1..6) {
        if (digits3[i] > 0) {
            var text2 = strings[i] + " " + bigNames[big]
            if (text.isNotEmpty()) {
                text2 += if (andNeeded) " and " else " "  // no commas inserted in this version
                andNeeded = false
            }
            else andNeeded = uk && digits3[i] in 1..99
            text = text2 + text
        }
        big *= 1000
    }
    if (maxNeg) text = text.dropLast(5) + "eight"
    if (neg) text = "minus " + text
    return text
}

val opening = "Four is the number of letters in the first word of this sentence,".split(' ')

val String.adjustedLength get() = this.replace(",", "").replace("-", "").length  // no ',' or '-'

fun getWords(n: Int): List<String> {
    val words = mutableListOf<String>()
    words.addAll(opening)
    if (n > opening.size) {
        var k = 2
        while (true) {
            val len = words[k - 1].adjustedLength
            val text = numToText(len.toLong())
            val splits = text.split(' ')
            words.addAll(splits)
            words.add("in")
            words.add("the")
            val text2 = numToText(k.toLong()).toOrdinal() + ","  // add trailing comma
            val splits2 = text2.split(' ')
            words.addAll(splits2)
            if (words.size >= n) break
            k++
        }
    }
    return words
}

fun getLengths(n: Int): Pair<List<Int>, Int> {
    val words = getWords(n)
    val lengths = words.take(n).map { it.adjustedLength }
    val sentenceLength = words.sumBy { it.length } + words.size - 1  // includes hyphens, commas & spaces
    return Pair(lengths, sentenceLength)
}

fun getLastWord(n: Int): Triple<String, Int, Int> {
    val words = getWords(n)
    val nthWord = words[n - 1]
    val nthWordLength = nthWord.adjustedLength
    val sentenceLength = words.sumBy { it.length } + words.size - 1  // includes hyphens, commas & spaces
    return Triple(nthWord, nthWordLength, sentenceLength)
}

fun main(args: Array<String>) {
    var n = 201
    println("The lengths of the first $n words are:\n")
    val (list, sentenceLength) = getLengths(n)
    for (i in 0 until n) {
        if (i % 25 == 0) {
            if (i > 0) println()
            print("${"%3d".format(i + 1)}: ")
        }
        print("%3d".format(list[i]))
    }
    println("\n\nLength of sentence = $sentenceLength\n")
    n = 1_000
    do {
        var (word, wLen, sLen) = getLastWord(n)
        if (word.endsWith(",")) word = word.dropLast(1)  // strip off any trailing comma
        println("The length of word $n [$word] is $wLen")
        println("Length of sentence = $sLen\n")
        n *= 10
    }
    while (n <= 10_000_000)
}
