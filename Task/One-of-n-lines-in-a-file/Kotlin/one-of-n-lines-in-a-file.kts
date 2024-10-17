// version 1.1.51

import java.util.Random

val r = Random()

fun oneOfN(n: Int): Int {
    var choice = 1
    for (i in 2..n) {
        if (r.nextDouble() < 1.0 / i) choice = i
    }
    return choice
}

fun main(args: Array<String>) {
    val n = 10
    val freqs = IntArray(n)
    val reps = 1_000_000
    repeat(reps) {
        val num = oneOfN(n)
        freqs[num - 1]++
    }
    for (i in 1..n) println("Line ${"%-2d".format(i)} = ${freqs[i - 1]}")
}
