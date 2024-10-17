import java.lang.Math.*

class Legendre(val N: Int) {
    fun evaluate(n: Int, x: Double) = (n downTo 1).fold(c[n][n]) { s, i -> s * x + c[n][i - 1] }

    fun diff(n: Int, x: Double) = n * (x * evaluate(n, x) - evaluate(n - 1, x)) / (x * x - 1)

    fun integrate(f: (Double) -> Double, a: Double, b: Double): Double {
        val c1 = (b - a) / 2
        val c2 = (b + a) / 2
        return c1 * (0 until N).fold(0.0) { s, i -> s + weights[i] * f(c1 * roots[i] + c2) }
    }

    private val roots = DoubleArray(N)
    private val weights = DoubleArray(N)
    private val c = Array(N + 1) { DoubleArray(N + 1) }    // coefficients

    init {
        // coefficients:
        c[0][0] = 1.0
        c[1][1] = 1.0
        for (n in 2..N) {
            c[n][0] = (1 - n) * c[n - 2][0] / n
            for (i in 1..n)
                c[n][i] = ((2 * n - 1) * c[n - 1][i - 1] - (n - 1) * c[n - 2][i]) / n
        }

        // roots:
        var x: Double
        var x1: Double
        for (i in 1..N) {
            x = cos(PI * (i - 0.25) / (N + 0.5))
            do {
                x1 = x
                x -= evaluate(N, x) / diff(N, x)
            } while (x != x1)

            x1 = diff(N, x)
            roots[i - 1] = x
            weights[i - 1] = 2 / ((1 - x * x) * x1 * x1)
        }

        print("Roots:")
        roots.forEach { print(" %f".format(it)) }
        println()
        print("Weights:")
        weights.forEach { print(" %f".format(it)) }
        println()
    }
}

fun main(args: Array<String>) {
    val legendre = Legendre(5)
    println("integrating Exp(x) over [-3, 3]:")
    println("\t%10.8f".format(legendre.integrate(Math::exp, -3.0, 3.0)))
    println("compared to actual:")
    println("\t%10.8f".format(exp(3.0) - exp(-3.0)))
}
