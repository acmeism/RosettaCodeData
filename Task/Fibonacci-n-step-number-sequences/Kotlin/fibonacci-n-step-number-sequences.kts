// version 1.1.2

fun fibN(initial: IntArray, numTerms: Int) : IntArray {
    val n = initial.size
    require(n >= 2 && numTerms >= 0)
    val fibs = initial.copyOf(numTerms)
    if (numTerms <= n) return fibs
    for (i in n until numTerms) {
        var sum = 0
        for (j in i - n until i) sum += fibs[j]
        fibs[i] = sum
    }
    return fibs
}

fun main(args: Array<String>) {
    val names = arrayOf("fibonacci",  "tribonacci", "tetranacci", "pentanacci", "hexanacci",
                        "heptanacci", "octonacci",  "nonanacci",  "decanacci")
    val initial = intArrayOf(1, 1, 2, 4, 8, 16, 32, 64, 128, 256)
    println(" n  name        values")
    var values = fibN(intArrayOf(2, 1), 15).joinToString(", ")
    println("%2d  %-10s  %s".format(2, "lucas", values))
    for (i in 0..8) {
        values = fibN(initial.sliceArray(0 until i + 2), 15).joinToString(", ")
        println("%2d  %-10s  %s".format(i + 2, names[i], values))
    }
}
