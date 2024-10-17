// version 1.1.2

val best = IntArray(32)

fun trySwaps(deck: IntArray, f: Int, d: Int, n: Int) {
    if (d > best[n]) best[n] = d
    for (i in n - 1 downTo 0) {
        if (deck[i] == -1 || deck[i] == i) break
        if (d + best[i] <= best[n]) return
    }
    val deck2 = deck.copyOf()
    for (i in 1 until n) {
        val k = 1 shl i
        if (deck2[i] == -1) {
            if ((f and k) != 0) continue
        }
        else if (deck2[i] != i) continue
        deck2[0] = i
        for (j in i - 1 downTo 0) deck2[i - j] = deck[j]
        trySwaps(deck2, f or k, d + 1, n)
    }
}

fun topswops(n: Int): Int {
    require(n > 0 && n < best.size)
    best[n] = 0
    val deck0 = IntArray(n + 1)
    for (i in 1 until n) deck0[i] = -1
    trySwaps(deck0, 1, 0, n)
    return best[n]
}

fun main(args: Array<String>) {
    for (i in 1..10) println("${"%2d".format(i)} : ${topswops(i)}")
}
