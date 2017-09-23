// version 1.0.6

fun nthRoot(x: Double, n: Int): Double {
    if (n < 2) throw IllegalArgumentException("n must be more than 1")
    if (x <= 0.0) throw IllegalArgumentException("x must be positive")
    val np = n - 1
    fun iter(g: Double) = (np * g + x / Math.pow(g, np.toDouble())) / n
    var g1 = x
    var g2 = iter(g1)
    while (g1 != g2) {
        g1 = iter(g1)
        g2 = iter(iter(g2))
    }
    return g1
}

fun main(args: Array<String>) {
   val numbers = arrayOf(1728.0 to 3, 1024.0 to 10, 2.0 to 2)
   for (number in numbers)
       println("${number.first} ^ 1/${number.second}\t = ${nthRoot(number.first, number.second)}")
}
