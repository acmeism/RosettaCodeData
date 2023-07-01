// version 1.1.0

const val digits = "0123456789abcdefghijklmnopqrstuvwxyz"

fun sumDigits(ns: String, base: Int): Int {
    val n = ns.toLowerCase().trim()
    if (base !in 2..36) throw IllegalArgumentException("Base must be between 2 and 36")
    if (n.isEmpty())    throw IllegalArgumentException("Number string can't be blank or empty")
    var sum = 0
    for (digit in n) {
        val index = digits.indexOf(digit)
        if (index == -1 || index >= base) throw IllegalArgumentException("Number string contains an invalid digit")
        sum += index
    }
    return sum
}

fun main(args: Array<String>) {
    val numbers = mapOf("1" to 10, "1234" to 10, "fe" to 16, "f0e" to 16, "1010" to 2, "777" to 8, "16xyz" to 36)
    println("The sum of digits is:")
    for ((number, base) in numbers) println("$number\tbase $base\t-> ${sumDigits(number, base)}")
}
