// Version 1.2.40

import kotlin.math.abs

const val EPSILON = 1.0e-15

fun main(args: Array<String>) {
    var fact = 1L
    var e = 2.0
    var n = 2
    do {
        val e0 = e
        fact *= n++
        e += 1.0 / fact
    }
    while (abs(e - e0) >= EPSILON)
    println("e = %.15f".format(e))
}
