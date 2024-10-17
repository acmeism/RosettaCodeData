// version 1.0.6

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
    val samples = arrayOf(
        "1223334444",
        "1223334444555555555",
        "122333",
        "1227774444",
        "aaBBcccDDDD",
        "1234567890abcdefghijklmnopqrstuvwxyz",
        "Rosetta Code"
    )
    println("            String                             Entropy")
    println("------------------------------------      ------------------")
    for (sample in samples) println("${sample.padEnd(36)}  ->  ${"%18.16f".format(shannon(sample))}")
}
