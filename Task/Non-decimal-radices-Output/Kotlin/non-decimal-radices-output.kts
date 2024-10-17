// version 1.1.2

fun main(args: Array<String>) {
    val bases = intArrayOf(2, 8, 10, 16, 19, 36)
    for (base in bases) print("%6s".format(base))
    println()
    println("-".repeat(6 * bases.size))
    for (i in 0..35) {
        for (base in bases) print("%6s".format(i.toString(base)))
        println()
    }
}
