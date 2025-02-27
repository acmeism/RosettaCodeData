fun Q(n: Int): List<Int> {
    val mem = mutableMapOf<Int, Int>().also {
        it[1] = 1
        it[2] = 1
    }
    q(n, mem)
    return mem.values.toList()
}

private fun q(n: Int, mem: MutableMap<Int, Int>): Int {
    if (!mem.containsKey(n)) {
        mem[n] =
            q(n - q(n - 1, mem), mem) + q(n - q(n - 2, mem), mem)
    }
    return mem[n]!!
}

fun main() {
    val n = 1000
    Q(n).also { qList ->
        println("Q[1..10] = ${qList.take(10)}")
        println("Q($n)  = ${qList[1000 - 1]}") // 502
    }
}
