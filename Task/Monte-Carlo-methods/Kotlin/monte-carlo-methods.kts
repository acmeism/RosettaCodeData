// version 1.1.0

fun mcPi(n: Int): Double {
    var inside = 0
    (1..n).forEach {
        val x = Math.random()
        val y = Math.random()
        if (x * x + y * y <= 1.0) inside++
    }
    return 4.0 * inside / n
}

fun main(args: Array<String>) {
    println("Iterations -> Approx Pi  -> Error%")
    println("----------    ----------    ------")
    var n = 1_000
    while (n <= 100_000_000) {
        val pi = mcPi(n)
        val err = Math.abs(Math.PI - pi) / Math.PI * 100.0
        println(String.format("%9d  -> %10.8f -> %6.4f", n, pi, err))
        n *= 10
    }
}
