fun sumsRemainDistinct(candidate: Int, seq: Iterable<Int>, sums: MutableSet<Int>): Boolean {
    val candidateSums = mutableListOf<Int>()

    for (s in seq) {
        when ((candidate + s) !in sums) {
            true -> candidateSums.add(candidate + s)
            false -> return false
        }
    }
    with(sums) {
        addAll(candidateSums)
        add(candidate + candidate)
    }
    return true
}

fun mianChowla(n: Int): List<Int> {
    val bufferSeq = linkedSetOf<Int>()
    val bufferSums = linkedSetOf<Int>()

    val sequence = generateSequence(1) { it + 1 } // [1,2,3,..]
        .filter { sumsRemainDistinct(it, bufferSeq, bufferSums) }
        .onEach { bufferSeq.add(it) }

    return sequence.take(n).toList()
}

fun main() {
    mianChowla(100).also {
        println("Mian-Chowla[1..30] = ${it.take(30)}")
        println("Mian-Chowla[91..100] = ${it.drop(90)}")
    }
}
