// Version 1.2.70

import kotlin.math.abs

infix fun Int.pow(e: Int): Int {
    if (e == 0) return 1
    var prod = this
    for (i in 2..e) {
        prod *= this
    }
    return prod
}

fun main(args: Array<String>) {
    var prod = 1
    var sum = 0
    val x = 5
    val y = -5
    val z = -2
    val one = 1
    val three = 3
    val seven = 7
    val p = 11 pow x
    fun process(j: Int) {
        sum += abs(j)
        if (abs(prod) < (1 shl 27) && j != 0) prod *= j
    }

    for (j in -three..(3 pow 3) step three) process(j)
    for (j in -seven..seven step x) process(j)
    for (j in 555..550-y) process(j)
    for (j in 22 downTo -28 step three) process(j)
    for (j in 1927..1939) process(j)
    for (j in x downTo y step -z) process(j)
    for (j in p..p + one) process(j)
    System.out.printf("sum  = % ,d\n", sum)
    System.out.printf("prod = % ,d\n", prod)
}
