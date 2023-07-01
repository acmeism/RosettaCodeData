// version 1.1.2

typealias Func = (Double) -> Double

fun integrate(a: Double, b: Double, n: Int, f: Func) {
    val h = (b - a) / n
    val sum = DoubleArray(5)
    for (i in 0 until n) {
        val x = a + i * h
        sum[0] += f(x)
        sum[1] += f(x + h / 2.0)
        sum[2] += f(x + h)
        sum[3] += (f(x) + f(x + h)) / 2.0
        sum[4] += (f(x) + 4.0 * f(x + h / 2.0) + f(x + h)) / 6.0
    }
    val methods = listOf("LeftRect ", "MidRect  ", "RightRect", "Trapezium", "Simpson  ")
    for (i in 0..4) println("${methods[i]} = ${"%f".format(sum[i] * h)}")
    println()
}

fun main(args: Array<String>) {
    integrate(0.0, 1.0, 100) { it * it * it }
    integrate(1.0, 100.0, 1_000) { 1.0 / it }
    integrate(0.0, 5000.0, 5_000_000) { it }
    integrate(0.0, 6000.0, 6_000_000) { it }
}
