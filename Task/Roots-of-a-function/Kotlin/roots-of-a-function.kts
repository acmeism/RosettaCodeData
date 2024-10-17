// version 1.1.2

typealias DoubleToDouble = (Double) -> Double

fun f(x: Double) = x * x * x - 3.0 * x * x + 2.0 * x

fun secant(x1: Double, x2: Double, f: DoubleToDouble): Double {
    val e = 1.0e-12
    val limit = 50
    var xa = x1
    var xb = x2
    var fa = f(xa)
    var  i = 0
    while (i++ < limit) {
        var fb = f(xb)
        val d = (xb - xa) / (fb - fa) * fb
        if (Math.abs(d) < e) break
        xa = xb
        fa = fb
        xb -= d
    }
    if (i == limit) {
        println("Function is not converging near (${"%7.4f".format(xa)}, ${"%7.4f".format(xb)}).")
        return -99.0
    }
    return xb
}

fun main(args: Array<String>) {
    val step = 1.0e-2
    val e = 1.0e-12
    var x = -1.032
    var s = f(x) > 0.0
    while (x < 3.0) {
        val value = f(x)
        if (Math.abs(value) < e) {
            println("Root found at x = ${"%12.9f".format(x)}")
            s = f(x + 0.0001) > 0.0
        }
        else if ((value > 0.0) != s) {
            val xx = secant(x - step, x, ::f)
            if (xx != -99.0)
                println("Root found at x = ${"%12.9f".format(xx)}")
            else
                println("Root found near x = ${"%7.4f".format(x)}")
            s = f(x + 0.0001) > 0.0
        }
        x += step
    }
}
