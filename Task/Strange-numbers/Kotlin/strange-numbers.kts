import kotlin.math.abs

fun digits(n: Int): List<Int> {
    var nn = n
    val result = mutableListOf<Int>()
    while (nn > 0) {
        val rem = nn % 10
        result.add(0, rem)
        nn /= 10
    }
    return result
}

fun isStrange(n: Int): Boolean {
    val test = { a: Int, b: Int ->
        val abs = abs(a - b)
        abs == 2 || abs == 3 || abs == 5 || abs == 7
    }
    val xs = digits(n)
    for (i in 1 until xs.size) {
        if (!test(xs[i - 1], xs[i])) {
            return false
        }
    }
    return true
}

fun main() {
    val xs = (100 until 500)
        .filter(::isStrange)
        .toList()
    println("Strange numbers in range [100..500]")
    println("(Total: ${xs.size})")
    println()
    for (i in xs.indices) {
        val x = xs[i]
        print(x)
        if ((i + 1) % 10 == 0) {
            println()
        } else {
            print(' ')
        }
    }
    println()
}
