import kotlin.math.abs

fun isEsthetic(n: Long, b: Long): Boolean {
    if (n == 0L) {
        return false
    }
    var i = n % b
    var n2 = n / b
    while (n2 > 0) {
        val j = n2 % b
        if (abs(i - j) != 1L) {
            return false
        }
        n2 /= b
        i = j
    }
    return true
}

fun listEsths(n: Long, n2: Long, m: Long, m2: Long, perLine: Int, all: Boolean) {
    val esths = mutableListOf<Long>()
    fun dfs(n: Long, m: Long, i: Long) {
        if (i in n..m) {
            esths.add(i)
        }
        if (i == 0L || i > m) {
            return
        }
        val d = i % 10
        val i1 = i * 10 + d - 1
        val i2 = i1 + 2
        when (d) {
            0L -> {
                dfs(n, m, i2)
            }
            9L -> {
                dfs(n, m, i1)
            }
            else -> {
                dfs(n, m, i1)
                dfs(n, m, i2)
            }
        }
    }

    for (i in 0L until 10L) {
        dfs(n2, m2, i)
    }

    val le = esths.size
    println("Base 10: $le esthetic numbers between $n and $m:")
    if (all) {
        for (c_esth in esths.withIndex()) {
            print("${c_esth.value} ")
            if ((c_esth.index + 1) % perLine == 0) {
                println()
            }
        }
        println()
    } else {
        for (i in 0 until perLine) {
            print("${esths[i]} ")
        }
        println()
        println("............")
        for (i in le - perLine until le) {
            print("${esths[i]} ")
        }
        println()
    }
    println()
}

fun main() {
    for (b in 2..16) {
        println("Base $b: ${4 * b}th to ${6 * b}th esthetic numbers:")
        var n = 1L
        var c = 0L
        while (c < 6 * b) {
            if (isEsthetic(n, b.toLong())) {
                c++
                if (c >= 4 * b) {
                    print("${n.toString(b)} ")
                }
            }
            n++
        }
        println()
    }
    println()

    // the following all use the obvious range limitations for the numbers in question
    listEsths(1000, 1010, 9999, 9898, 16, true);
    listEsths(1e8.toLong(), 101_010_101, 13 * 1e7.toLong(), 123_456_789, 9, true);
    listEsths(1e11.toLong(), 101_010_101_010, 13 * 1e10.toLong(), 123_456_789_898, 7, false);
    listEsths(1e14.toLong(), 101_010_101_010_101, 13 * 1e13.toLong(), 123_456_789_898_989, 5, false);
    listEsths(1e17.toLong(), 101_010_101_010_101_010, 13 * 1e16.toLong(), 123_456_789_898_989_898, 4, false);
}
