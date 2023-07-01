// version 1.1

fun divideByZero(x: Int, y:Int): Boolean =
    try {
        x / y
        false
    } catch(e: ArithmeticException) {
        true
    }

fun main(args: Array<String>) {
    val x = 1
    val y = 0
    if (divideByZero(x, y)) {
        println("Attempted to divide by zero")
    } else {
        @Suppress("DIVISION_BY_ZERO")
        println("$x / $y = ${x / y}")
    }
}
