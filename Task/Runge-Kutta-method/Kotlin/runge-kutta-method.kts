// version 1.1.2

typealias Y  = (Double) -> Double
typealias Yd = (Double, Double) -> Double

fun rungeKutta4(t0: Double, tz: Double, dt: Double, y: Y, yd: Yd) {
    var tn = t0
    var yn = y(tn)
    val z = ((tz  - t0) / dt).toInt()
    for (i in 0..z) {
        if (i % 10 == 0) {
            val exact = y(tn)
            val error = yn - exact
            println("%4.1f  %10f  %10f  %9f".format(tn, yn, exact, error))
        }
        if (i == z) break
        val dy1 = dt * yd(tn, yn)
        val dy2 = dt * yd(tn + 0.5 * dt, yn + 0.5 * dy1)
        val dy3 = dt * yd(tn + 0.5 * dt, yn + 0.5 * dy2)
        val dy4 = dt * yd(tn + dt, yn + dy3)
        yn += (dy1 + 2.0 * dy2 + 2.0 * dy3 + dy4) / 6.0
        tn += dt
    }
}

fun main(args: Array<String>) {
    println("  T        RK4        Exact      Error")
    println("----  ----------  ----------  ---------")
    val y = fun(t: Double): Double {
        val x = t * t + 4.0
        return x * x / 16.0
    }
    val yd = fun(t: Double, yt: Double) = t * Math.sqrt(yt)
    rungeKutta4(0.0, 10.0, 0.1, y, yd)
}
