// version 1.1.3

data class Classification(val sequence: List<Long>, val aliquot: String)

const val THRESHOLD = 1L shl 47

fun sumProperDivisors(n: Long): Long {
    if (n < 2L) return 0L
    val sqrt = Math.sqrt(n.toDouble()).toLong()
    var sum = 1L + (2L..sqrt)
        .filter { n % it == 0L }
        .map { it + n / it }
        .sum()
    if (sqrt * sqrt == n) sum -= sqrt
    return sum
}

fun classifySequence(k: Long): Classification {
    require(k > 0)
    var last = k
    val seq = mutableListOf(k)
    while (true) {
        last = sumProperDivisors(last)
        seq.add(last)
        val n = seq.size
        val aliquot = when {
            last == 0L                  -> "Terminating"
            n == 2 && last == k         -> "Perfect"
            n == 3 && last == k         -> "Amicable"
            n >= 4 && last == k         -> "Sociable[${n - 1}]"
            last == seq[n - 2]          -> "Aspiring"
            last in seq.slice(1..n - 3) -> "Cyclic[${n - 1 - seq.indexOf(last)}]"
            n == 16 || last > THRESHOLD -> "Non-Terminating"
            else                        -> ""
        }
        if (aliquot != "") return Classification(seq, aliquot)
    }
}

fun main(args: Array<String>) {
    println("Aliqot classifications - periods for Sociable/Cyclic in square brackets:\n")
    for (k in 1L..10) {
        val (seq, aliquot) = classifySequence(k)
        println("${"%2d".format(k)}: ${aliquot.padEnd(15)} $seq")
    }

    val la = longArrayOf(
        11, 12, 28, 496, 220, 1184, 12496, 1264460, 790, 909, 562, 1064, 1488
    )
    println()

    for (k in la) {
        val (seq, aliquot) = classifySequence(k)
        println("${"%7d".format(k)}: ${aliquot.padEnd(15)} $seq")
    }

    println()

    val k = 15355717786080L
    val (seq, aliquot) = classifySequence(k)
    println("$k: ${aliquot.padEnd(15)} $seq")
}
