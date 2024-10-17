// version 1.2.10

import java.util.Random

val rand = Random()
const val RAND_MAX = 32767

// just generate 0s and 1s without storing them
fun runTest(p: Double, len: Int, runs: Int): Double {
    var cnt = 0
    val thresh = (p * RAND_MAX).toInt()
    for (r in 0 until runs) {
        var x = 0
        var i = len
        while (i-- > 0) {
            val y = if (rand.nextInt(RAND_MAX + 1) < thresh) 1 else 0
            if (x < y) cnt++
            x = y
        }
    }
    return cnt.toDouble() / runs / len
}

fun main(args: Array<String>) {
    println("running 1000 tests each:")
    println(" p\t   n\tK\tp(1-p)\t     diff")
    println("------------------------------------------------")
    val fmt = "%.1f\t%6d\t%.4f\t%.4f\t%+.4f (%+.2f%%)"
    for (ip in 1..9 step 2) {
        val p = ip / 10.0
        val p1p = p * (1.0 - p)
        var n = 100
        while (n <= 100_000) {
            val k = runTest(p, n, 1000)
            println(fmt.format(p, n, k, p1p, k - p1p, (k - p1p) / p1p * 100))
            n *= 10
        }
        println()
    }
}
