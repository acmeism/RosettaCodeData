// version 1.0.5-2

fun agm(a: Double, g: Double): Double {
    var aa = a             // mutable 'a'
    var gg = g             // mutable 'g'
    var ta: Double         // temporary variable to hold next iteration of 'aa'
    val epsilon = 1.0e-16  // tolerance for checking if limit has been reached

    while (true) {
        ta = (aa + gg) / 2.0
        if (Math.abs(aa - ta) <= epsilon) return ta
        gg = Math.sqrt(aa * gg)
        aa = ta
    }
}

fun main(args: Array<String>) {
    println(agm(1.0, 1.0 / Math.sqrt(2.0)))
}
