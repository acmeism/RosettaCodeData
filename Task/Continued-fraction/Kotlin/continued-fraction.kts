// version 1.1.2

typealias Func = (Int) -> IntArray

fun calc(f: Func, n: Int): Double {
    var temp = 0.0
    for (i in n downTo 1) {
        val p = f(i)
        temp = p[1] / (p[0] + temp)
    }
    return f(0)[0] + temp
}

fun main(args: Array<String>) {
    val pList = listOf<Pair<String, Func>>(
        "sqrt(2)" to { n -> intArrayOf(if (n > 0) 2 else 1, 1) },
        "e      " to { n -> intArrayOf(if (n > 0) n else 2, if (n > 1) n - 1 else 1) },
        "pi     " to { n -> intArrayOf(if (n > 0) 6 else 3, (2 * n - 1) * (2 * n - 1)) }
    )
    for (pair in pList) println("${pair.first} = ${calc(pair.second, 200)}")
}
