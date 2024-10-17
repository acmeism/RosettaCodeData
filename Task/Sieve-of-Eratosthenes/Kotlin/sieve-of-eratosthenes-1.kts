import kotlin.math.sqrt

fun sieve(max: Int): List<Int> {
    val xs = (2..max).toMutableList()
    val limit = sqrt(max.toDouble()).toInt()
    for (x in 2..limit) xs -= x * x..max step x
    return xs
}

fun main(args: Array<String>) {
    println(sieve(100))
}
