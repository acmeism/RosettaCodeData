// version 1.1.2

val names = mapOf<String, Long>(
    "one" to 1,
    "two" to 2,
    "three" to 3,
    "four" to 4,
    "five" to 5,
    "six" to 6,
    "seven" to 7,
    "eight" to 8,
    "nine" to 9,
    "ten" to 10,
    "eleven" to 11,
    "twelve" to 12,
    "thirteen" to 13,
    "fourteen" to 14,
    "fifteen" to 15,
    "sixteen" to 16,
    "seventeen" to 17,
    "eighteen" to 18,
    "nineteen" to 19,
    "twenty" to 20,
    "thirty" to 30,
    "forty" to 40,
    "fifty" to 50,
    "sixty" to 60,
    "seventy" to 70,
    "eighty" to 80,
    "ninety" to 90,
    "hundred" to 100,
    "thousand" to 1_000,
    "million" to 1_000_000,
    "billion" to 1_000_000_000,
    "trillion" to 1_000_000_000_000L,
    "quadrillion" to 1_000_000_000_000_000L,
    "quintillion" to 1_000_000_000_000_000_000L
)

val zeros = listOf("zero", "nought", "nil", "none", "nothing")

fun nameToNum(name: String): Long {
    var text = name.trim().toLowerCase()
    val isNegative = text.startsWith("minus ")
    if (isNegative) text = text.drop(6)
    if (text.startsWith("a ")) text = "one" + text.drop(1)
    val words = text.split(",", "-", " and ", " ").filter { it != "" }

    val size = words.size
    if (size == 1 && words[0] in zeros) return 0L

    var multiplier = 1L
    var lastNum = 0L
    var sum = 0L
    for (i in size - 1 downTo 0) {
        val num: Long? = names[words[i]]
        if (num == null)
            throw IllegalArgumentException("'${words[i]}' is not a valid number")
        else if (num == lastNum)
            throw IllegalArgumentException("'$name' is not a well formed numeric string")
        else if (num >= 1000) {
            if (lastNum >= 100)
                throw IllegalArgumentException("'$name' is not a well formed numeric string")
            multiplier = num
            if (i == 0) sum += multiplier
        } else if (num >= 100) {
            multiplier *= 100
            if (i == 0) sum += multiplier
        } else if (num >= 20) {
            if (lastNum in 10..90)
                throw IllegalArgumentException("'$name' is not a well formed numeric string")
            sum += num * multiplier
        } else {
            if (lastNum in 1..90)
                throw IllegalArgumentException("'$name' is not a well formed numeric string")
            sum += num * multiplier
        }
        lastNum = num
    }

    if (isNegative && sum == -sum)
        return Long.MIN_VALUE
    else if (sum < 0L)
        throw IllegalArgumentException("'$name' is outside the range of a Long integer")

    return if (isNegative) -sum else sum
}

fun main(args: Array<String>) {
    val names = arrayOf(
        "none",
        "one",
        "twenty-five",
        "minus one hundred and seventeen",
        "hundred and fifty-six",
        "minus two thousand two",
        "nine thousand, seven hundred, one",
        "minus six hundred and twenty six thousand, eight hundred and fourteen",
        "four million, seven hundred thousand, three hundred and eighty-six",
        "fifty-one billion, two hundred and fifty-two million, seventeen thousand, one hundred eighty-four",
        "two hundred and one billion, twenty-one million, two thousand and one",
        "minus three hundred trillion, nine million, four hundred and one thousand and thirty-one",
        "seventeen quadrillion, one hundred thirty-seven",
        "a quintillion, eight trillion and five",
        "minus nine quintillion, two hundred and twenty-three quadrillion, three hundred and seventy-two trillion, thirty-six billion, eight hundred and fifty-four million, seven hundred and seventy-five thousand, eight hundred and eight"
    )
    for (name in names) println("${"%20d".format(nameToNum(name))} = $name")
}
