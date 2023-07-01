// version 1.1.2

typealias Deriv = (Double) -> Double  // only one parameter needed here

const val FMT = " %7.3f"

fun euler(f: Deriv, y: Double, step: Int, end: Int) {
    var yy = y
    print(" Step %2d: ".format(step))
    for (t in 0..end step step) {
        if (t % 10 == 0) print(FMT.format(yy))
        yy += step * f(yy)
    }
    println()
}

fun analytic() {
    print("    Time: ")
    for (t in 0..100 step 10) print(" %7d".format(t))
    print("\nAnalytic: ")
    for (t in 0..100 step 10)
        print(FMT.format(20.0 + 80.0 * Math.exp(-0.07 * t)))
    println()
}

fun cooling(temp: Double) = -0.07 * (temp - 20.0)

fun main(args: Array<String>) {
    analytic()
    for (i in listOf(2, 5, 10))
        euler(::cooling, 100.0, i, 100)
}
