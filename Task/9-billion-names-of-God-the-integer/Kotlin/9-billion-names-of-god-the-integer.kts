import java.lang.Math.min
import java.math.BigInteger
import java.util.ArrayList
import java.util.Arrays.asList

fun namesOfGod(n: Int): List<BigInteger> {
    val cache = ArrayList<List<BigInteger>>()
    cache.add(asList(BigInteger.ONE))

    (cache.size..n).forEach { l ->
        val r = ArrayList<BigInteger>()
        r.add(BigInteger.ZERO)

        (1..l).forEach { x ->
            r.add(r[r.size - 1] + cache[l - x][min(x, l - x)])
        }
        cache.add(r)
    }
    return cache[n]
}

fun row(n: Int) = namesOfGod(n).let { r -> (0 until n).map { r[it + 1] - r[it] } }

fun main(args: Array<String>) {
    println("Rows:")
    (1..25).forEach {
        System.out.printf("%2d: %s%n", it, row(it))
    }

    println("\nSums:")
    intArrayOf(23, 123, 1234, 1234).forEach {
        val c = namesOfGod(it)
        System.out.printf("%s %s%n", it, c[c.size - 1])
    }
}
