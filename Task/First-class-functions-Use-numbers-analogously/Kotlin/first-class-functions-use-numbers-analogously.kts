// version 1.1.2

fun multiplier(n1: Double, n2: Double) = { m: Double -> n1 * n2 * m}

fun main(args: Array<String>) {
    val x  = 2.0
    val xi = 0.5
    val y  = 4.0
    val yi = 0.25
    val z  = x + y
    val zi = 1.0 / ( x + y)
    val a  = doubleArrayOf(x, y, z)
    val ai = doubleArrayOf(xi, yi, zi)
    val m  = 0.5
    for (i in 0 until a.size) {
        println("${multiplier(a[i], ai[i])(m)} = multiplier(${a[i]}, ${ai[i]})($m)")
    }
}
