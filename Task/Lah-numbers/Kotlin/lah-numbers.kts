import java.math.BigInteger

fun factorial(n: BigInteger): BigInteger {
    if (n == BigInteger.ZERO) return BigInteger.ONE
    if (n == BigInteger.ONE) return BigInteger.ONE
    var prod = BigInteger.ONE
    var num = n
    while (num > BigInteger.ONE) {
        prod *= num
        num--
    }
    return prod
}

fun lah(n: BigInteger, k: BigInteger): BigInteger {
    if (k == BigInteger.ONE) return factorial(n)
    if (k == n) return BigInteger.ONE
    if (k > n) return BigInteger.ZERO
    if (k < BigInteger.ONE || n < BigInteger.ONE) return BigInteger.ZERO
    return (factorial(n) * factorial(n - BigInteger.ONE)) / (factorial(k) * factorial(k - BigInteger.ONE)) / factorial(n - k)
}

fun main() {
    println("Unsigned Lah numbers: L(n, k):")
    print("n/k ")
    for (i in 0..12) {
        print("%10d ".format(i))
    }
    println()
    for (row in 0..12) {
        print("%-3d".format(row))
        for (i in 0..row) {
            val l = lah(BigInteger.valueOf(row.toLong()), BigInteger.valueOf(i.toLong()))
            print("%11d".format(l))
        }
        println()
    }
    println("\nMaximum value from the L(100, *) row:")
    println((0..100).map { lah(BigInteger.valueOf(100.toLong()), BigInteger.valueOf(it.toLong())) }.max())
}
