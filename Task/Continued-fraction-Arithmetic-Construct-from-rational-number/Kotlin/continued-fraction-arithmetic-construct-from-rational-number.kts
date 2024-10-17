// version 1.1.2
// compile with -Xcoroutines=enable flag from command line

import kotlin.coroutines.experimental.buildSequence

fun r2cf(frac: Pair<Int, Int>) =
    buildSequence {
        var num = frac.first
        var den = frac.second
        while (Math.abs(den) != 0) {
            val div = num / den
            val rem = num % den
            num = den
            den = rem
            yield(div)
        }
    }

fun iterate(seq: Sequence<Int>) {
    for (i in seq) print("$i ")
    println()
}

fun main(args: Array<String>) {
    val fracs = arrayOf(1 to 2, 3 to 1, 23 to 8, 13 to 11, 22 to 7, -151 to 77)
    for (frac in fracs) {
        print("${"%4d".format(frac.first)} / ${"%-2d".format(frac.second)} = ")
        iterate(r2cf(frac))
    }
    val root2 = arrayOf(14142 to 10000, 141421 to 100000,
                        1414214 to 1000000, 14142136 to 10000000)
    println("\nSqrt(2) ->")
    for (frac in root2) {
        print("${"%8d".format(frac.first)} / ${"%-8d".format(frac.second)} = ")
        iterate(r2cf(frac))
    }
    val pi = arrayOf(31 to 10, 314 to 100, 3142 to 1000, 31428 to 10000,
                     314285 to 100000, 3142857 to 1000000,
                     31428571 to 10000000, 314285714 to 100000000)
    println("\nPi ->")
    for (frac in pi) {
        print("${"%9d".format(frac.first)} / ${"%-9d".format(frac.second)} = ")
        iterate(r2cf(frac))
    }
}
