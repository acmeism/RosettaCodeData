fun multifactorial(n: Long, d: Int) : Long {
    val r = n % d
    return (1..n).filter { it % d == r } .reduce { i, p -> i * p }
}

fun main(args: Array<String>) {
    val m = 5
    val r = 1..10L
    for (d in 1..m) {
        print("%${m}s:".format( "!".repeat(d)))
        r.forEach { print(" " + multifactorial(it, d)) }
        println()
    }
}
