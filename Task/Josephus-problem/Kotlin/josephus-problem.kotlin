// version 1.1.3

fun josephus(n: Int, k: Int, m: Int): Pair<List<Int>, List<Int>> {
    require(k > 0 && m > 0 && n > k && n > m)
    val killed = mutableListOf<Int>()
    val survived = MutableList(n) { it }
    var start = k - 1
    outer@ while (true) {
        val end = survived.size - 1
        var i = start
        var deleted = 0
        while (i <= end) {
            killed.add(survived.removeAt(i - deleted))
            if (survived.size == m) break@outer
            deleted++
            i += k
        }
        start = i - end - 1
    }
    return Pair(survived, killed)
}

fun main(args: Array<String>) {
    val triples = listOf(Triple(5, 2, 1), Triple(41, 3, 1), Triple(41, 3, 3))
    for (triple in triples) {
        val(n, k, m) = triple
        println("Prisoners = $n, Step = $m, Survivors = $m")
        val (survived, killed)  = josephus(n, k, m)
        println("Survived   : $survived")
        println("Kill order : $killed")
        println()
    }
}
