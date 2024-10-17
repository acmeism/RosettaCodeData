// version 1.1.2

fun throwDie(nSides: Int, nDice: Int, s: Int, counts: IntArray) {
    if (nDice == 0) {
        counts[s]++
        return
    }
    for (i in 1..nSides) throwDie(nSides, nDice - 1, s + i, counts)
}

fun beatingProbability(nSides1: Int, nDice1: Int, nSides2: Int, nDice2: Int): Double {
    val len1 = (nSides1 + 1) * nDice1
    val c1 = IntArray(len1)  // all elements zero by default
    throwDie(nSides1, nDice1, 0, c1)

    val len2 = (nSides2 + 1) * nDice2
    val c2 = IntArray(len2)
    throwDie(nSides2, nDice2, 0, c2)

    val p12 = Math.pow(nSides1.toDouble(), nDice1.toDouble()) *
              Math.pow(nSides2.toDouble(), nDice2.toDouble())

    var tot = 0.0
    for (i in 0 until len1) {
        for (j in 0 until minOf(i, len2)) {
            tot += c1[i] * c2[j] / p12
        }
    }
    return tot
}

fun main(args: Array<String>) {
    println(beatingProbability(4, 9, 6, 6))
    println(beatingProbability(10, 5, 7, 6))
}
