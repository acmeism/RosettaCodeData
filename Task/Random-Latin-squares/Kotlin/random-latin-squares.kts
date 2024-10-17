typealias matrix = MutableList<MutableList<Int>>

fun printSquare(latin: matrix) {
    for (row in latin) {
        println(row)
    }
    println()
}

fun latinSquare(n: Int) {
    if (n <= 0) {
        println("[]")
        return
    }

    val latin = MutableList(n) { MutableList(n) { it } }
    // first row
    latin[0].shuffle()

    // middle row(s)
    for (i in 1 until n - 1) {
        var shuffled = false
        shuffling@
        while (!shuffled) {
            latin[i].shuffle()
            for (k in 0 until i) {
                for (j in 0 until n) {
                    if (latin[k][j] == latin[i][j]) {
                        continue@shuffling
                    }
                }
            }
            shuffled = true
        }
    }

    // last row
    for (j in 0 until n) {
        val used = MutableList(n) { false }
        for (i in 0 until n - 1) {
            used[latin[i][j]] = true
        }
        for (k in 0 until n) {
            if (!used[k]) {
                latin[n - 1][j] = k
                break
            }
        }
    }

    printSquare(latin)
}

fun main() {
    latinSquare(5)
    latinSquare(5)
    latinSquare(10) // for good measure
}
