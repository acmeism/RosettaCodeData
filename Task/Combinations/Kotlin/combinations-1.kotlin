class Combinations(val m: Int, val n: Int) {
    private val combination = IntArray(m)

    init {
        generate(0)
    }

    private fun generate(k: Int) {
        if (k >= m) {
            for (i in 0 until m) print("${combination[i]} ")
            println()
        }
        else {
            for (j in 0 until n)
                if (k == 0 || j > combination[k - 1]) {
                    combination[k] = j
                    generate(k + 1)
                }
        }
    }
}

fun main(args: Array<String>) {
    Combinations(3, 5)
}
