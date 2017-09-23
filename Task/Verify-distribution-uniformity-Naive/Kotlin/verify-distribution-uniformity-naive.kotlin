// version 1.1.3

import java.util.Random

val r = Random()

fun dice5() = 1 + r.nextInt(5)

fun checkDist(gen: () -> Int, nRepeats: Int, tolerance: Double = 0.5) {
    val occurs = mutableMapOf<Int, Int>()
    for (i in 1..nRepeats) {
        val d = gen()
        if (occurs.containsKey(d))
            occurs[d] = occurs[d]!! + 1
        else
            occurs.put(d, 1)
    }
    val expected = (nRepeats.toDouble()/ occurs.size).toInt()
    val maxError = (expected * tolerance / 100.0).toInt()
    println("Repetitions = $nRepeats, Expected = $expected")
    println("Tolerance = $tolerance%, Max Error = $maxError\n")
    println("Integer   Occurrences   Error  Acceptable")
    val f = "  %d        %5d      %5d     %s"
    var allAcceptable = true
    for ((k,v) in occurs.toSortedMap()) {
        val error = Math.abs(v - expected)
        val acceptable = if (error <= maxError) "Yes" else "No"
        if (acceptable == "No") allAcceptable = false
        println(f.format(k, v, error, acceptable))
    }
    println("\nAcceptable overall: ${if (allAcceptable) "Yes" else "No"}")
}

fun main(args: Array<String>) {
    checkDist(::dice5, 1_000_000)
    println()
    checkDist(::dice5, 100_000)
}
