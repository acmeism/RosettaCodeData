// version 1.1.2

fun halve(n: Int) = n / 2

fun double(n: Int) = n * 2

fun isEven(n: Int) = n % 2 == 0

fun ethiopianMultiply(x: Int, y: Int): Int {
    var xx = x
    var yy = y
    var sum = 0
    while (xx >= 1) {
       if (!isEven(xx)) sum += yy
       xx = halve(xx)
       yy = double(yy)
    }
    return sum
}

fun main(args: Array<String>) {
    println("17 x 34 = ${ethiopianMultiply(17, 34)}")
    println("99 x 99 = ${ethiopianMultiply(99, 99)}")
}
