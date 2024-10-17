val romanNumerals = mapOf(
    1000 to "M",
    900 to "CM",
    500 to "D",
    400 to "CD",
    100 to "C",
    90 to "XC",
    50 to "L",
    40 to "XL",
    10 to "X",
    9 to "IX",
    5 to "V",
    4 to "IV",
    1 to "I"
)

fun encode(number: Int): String? {
    if (number > 5000 || number < 1) {
        return null
    }
    var num = number
    var result = ""
    for ((multiple, numeral) in romanNumerals.entries) {
        while (num >= multiple) {
            num -= multiple
            result += numeral
        }
    }
    return result
}

fun main(args: Array<String>) {
    println(encode(1990))
    println(encode(1666))
    println(encode(2008))
}
