// version 1.0.6

class CombsWithReps<T>(val m: Int, val n: Int, val items: List<T>, val countOnly: Boolean = false) {
    private val combination = IntArray(m)
    private var count = 0

    init {
        generate(0)
        if (!countOnly) println()
        println("There are $count combinations of $n things taken $m at a time, with repetitions")
    }

    private fun generate(k: Int) {
        if (k >= m) {
            if (!countOnly) {
                for (i in 0 until m) print("${items[combination[i]]}\t")
                println()
            }
            count++
        }
        else {
            for (j in 0 until n)
                if (k == 0 || j >= combination[k - 1]) {
                    combination[k] = j
                    generate(k + 1)
                }
        }
    }
}

fun main(args: Array<String>) {
    val doughnuts = listOf("iced", "jam", "plain")
    CombsWithReps(2, 3, doughnuts)
    println()
    val generic10 = "0123456789".chunked(1)
    CombsWithReps(3, 10, generic10, true)
}
