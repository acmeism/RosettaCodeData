// version 1.0

fun checkLuhn(number: String): Boolean {
    var isOdd = true
    var sum = 0

    for (index in number.indices.reversed()) {
        val digit = number[index] - '0'
        sum += if (isOdd) digit else (digit * 2).let { (it / 10) + (it % 10) }
        isOdd = !isOdd
    }

    return (sum % 10) == 0
}

fun main(args: Array<String>) {
    val numbers = arrayOf("49927398716", "49927398717", "1234567812345678", "1234567812345670")
    for (number in numbers)
        println("${number.padEnd(16)} is ${if(checkLuhn(number)) "valid" else "invalid"}")
}
