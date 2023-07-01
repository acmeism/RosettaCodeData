import java.math.BigInteger

fun main() {
    println("Stirling numbers of the second kind:")
    val max = 12
    print("n/k")
    for (n in 0..max) {
        print("%10d".format(n))
    }
    println()
    for (n in 0..max) {
        print("%-3d".format(n))
        for (k in 0..n) {
            print("%10s".format(sterling2(n, k)))
        }
        println()
    }
    println("The maximum value of S2(100, k) = ")
    var previous = BigInteger.ZERO
    for (k in 1..100) {
        val current = sterling2(100, k)
        previous = if (current > previous) {
            current
        } else {
            println("%s%n(%d digits, k = %d)".format(previous, previous.toString().length, k - 1))
            break
        }
    }
}

private val COMPUTED: MutableMap<String, BigInteger> = HashMap()
private fun sterling2(n: Int, k: Int): BigInteger {
    val key = "$n,$k"
    if (COMPUTED.containsKey(key)) {
        return COMPUTED[key]!!
    }
    if (n == 0 && k == 0) {
        return BigInteger.valueOf(1)
    }
    if (n > 0 && k == 0 || n == 0 && k > 0) {
        return BigInteger.ZERO
    }
    if (n == k) {
        return BigInteger.valueOf(1)
    }
    if (k > n) {
        return BigInteger.ZERO
    }

    val result = BigInteger.valueOf(k.toLong()) * sterling2(n - 1, k) + sterling2(n - 1, k - 1)
    COMPUTED[key] = result
    return result
}
