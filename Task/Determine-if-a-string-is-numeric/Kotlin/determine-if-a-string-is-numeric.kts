// version 1.1

fun isNumeric(input: String): Boolean =
    try {
        input.toDouble()
        true
    } catch(e: NumberFormatException) {
        false
    }

fun main(args: Array<String>) {
    val inputs = arrayOf("152", "-3.1415926", "Foo123", "-0", "456bar", "1.0E10")
    for (input in inputs) println("$input is ${if (isNumeric(input)) "numeric" else "not numeric"}")
}
