// version 1.1.0 (entropy_narc.kt)

fun log2(d: Double) = Math.log(d) / Math.log(2.0)

fun shannon(s: String): Double {
    val counters = mutableMapOf<Char, Int>()
    for (c in s) {
        if (counters.containsKey(c)) counters[c] = counters[c]!! + 1
        else counters.put(c, 1)
    }
    val nn = s.length.toDouble()
    var sum = 0.0
    for (key in counters.keys) {
       val term = counters[key]!! / nn
       sum += term * log2(term)
    }
    return -sum
}

fun main(args: Array<String>) {
   val prog = java.io.File("entropy_narc.kt").readText()
   println("This program's entropy is ${"%18.16f".format(shannon(prog))}")
}
