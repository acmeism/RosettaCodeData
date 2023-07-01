// version 1.1.2

const val MAXSUM = 99

fun getPrimes(max: Int): List<Int> {
    if (max < 2) return emptyList<Int>()
    val lprimes = mutableListOf(2)
    outer@ for (x in 3..max step 2) {
        for (p in lprimes) if (x % p == 0) continue@outer
        lprimes.add(x)
    }
    return lprimes
}

fun main(args: Array<String>) {
    val descendants = Array(MAXSUM + 1) { mutableListOf<Long>() }
    val ancestors   = Array(MAXSUM + 1) { mutableListOf<Int>() }
    val primes = getPrimes(MAXSUM)

    for (p in primes) {
        descendants[p].add(p.toLong())
        for (s in 1 until descendants.size - p) {
            val temp = descendants[s + p] + descendants[s].map { p * it }
            descendants[s + p] = temp.toMutableList()
        }
    }

    for (p in primes + 4) descendants[p].removeAt(descendants[p].lastIndex)
    var total = 0

    for (s in 1..MAXSUM) {
        descendants[s].sort()
        total += descendants[s].size
        for (d in descendants[s].takeWhile { it <= MAXSUM.toLong() }) {
            ancestors[d.toInt()] = (ancestors[s] + s).toMutableList()
        }
        if (s in 21..45 || s in 47..73 || s in 75 until MAXSUM) continue
        print("${"%2d".format(s)}: ${ancestors[s].size} Ancestor(s): ")
        print(ancestors[s].toString().padEnd(18))
        print("${"%5d".format(descendants[s].size)} Descendant(s): ")
        println("${descendants[s].joinToString(", ", "[", "]", 10)}")
    }

    println("\nTotal descendants $total")
}
