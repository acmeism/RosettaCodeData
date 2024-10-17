typealias Matrix = MutableList<MutableList<Int>>

fun dList(n: Int, sp: Int): Matrix {
    val start = sp - 1 // use 0 basing

    val a = generateSequence(0) { it + 1 }.take(n).toMutableList()
    a[start] = a[0].also { a[0] = a[start] }
    a.subList(1, a.size).sort()

    val first = a[1]
    // recursive closure permutes a[1:]
    val r = mutableListOf<MutableList<Int>>()
    fun recurse(last: Int) {
        if (last == first) {
            // bottom of recursion. you get here once for each permutation.
            // test if permutation is deranged
            for (jv in a.subList(1, a.size).withIndex()) {
                if (jv.index + 1 == jv.value) {
                    return  // no, ignore it
                }
            }
            // yes, save a copy with 1 based indexing
            val b = a.map { it + 1 }
            r.add(b.toMutableList())
            return
        }
        for (i in last.downTo(1)) {
            a[i] = a[last].also { a[last] = a[i] }
            recurse(last - 1)
            a[i] = a[last].also { a[last] = a[i] }
        }
    }
    recurse(n - 1)
    return r
}

fun reducedLatinSquares(n: Int, echo: Boolean): Long {
    if (n <= 0) {
        if (echo) {
            println("[]\n")
        }
        return 0
    } else if (n == 1) {
        if (echo) {
            println("[1]\n")
        }
        return 1
    }

    val rlatin = MutableList(n) { MutableList(n) { it } }
    // first row
    for (j in 0 until n) {
        rlatin[0][j] = j + 1
    }

    var count = 0L
    fun recurse(i: Int) {
        val rows = dList(n, i)

        outer@
        for (r in 0 until rows.size) {
            rlatin[i - 1] = rows[r].toMutableList()
            for (k in 0 until i - 1) {
                for (j in 1 until n) {
                    if (rlatin[k][j] == rlatin[i - 1][j]) {
                        if (r < rows.size - 1) {
                            continue@outer
                        }
                        if (i > 2) {
                            return
                        }
                    }
                }
            }
            if (i < n) {
                recurse(i + 1)
            } else {
                count++
                if (echo) {
                    printSquare(rlatin)
                }
            }
        }
    }

    // remaining rows
    recurse(2)
    return count
}

fun printSquare(latin: Matrix) {
    for (row in latin) {
        println(row)
    }
    println()
}

fun factorial(n: Long): Long {
    if (n == 0L) {
        return 1
    }
    var prod = 1L
    for (i in 2..n) {
        prod *= i
    }
    return prod
}

fun main() {
    println("The four reduced latin squares of order 4 are:\n")
    reducedLatinSquares(4, true)

    println("The size of the set of reduced latin squares for the following orders")
    println("and hence the total number of latin squares of these orders are:\n")
    for (n in 1 until 7) {
        val size = reducedLatinSquares(n, false)
        var f = factorial(n - 1.toLong())
        f *= f * n * size
        println("Order $n: Size %-4d x $n! x ${n - 1}! => Total $f".format(size))
    }
}
