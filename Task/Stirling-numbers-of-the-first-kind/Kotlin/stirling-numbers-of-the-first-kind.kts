import java.math.BigInteger

fun main() {
    println("Unsigned Stirling numbers of the first kind:")
    val max = 12
    print("n/k")
    for (n in 0..max) {
        print("%10d".format(n))
    }
    println()
    for (n in 0..max) {
        print("%-3d".format(n))
        for (k in 0..n) {
            print("%10s".format(sterling1(n, k)))
        }
        println()
    }
    println("The maximum value of S1(100, k) = ")
    var previous = BigInteger.ZERO
    for (k in 1..100) {
        val current = sterling1(100, k)
        previous = if (current!! > previous) {
            current
        } else {
            println("$previous\n(${previous.toString().length} digits, k = ${k - 1})")
            break
        }
    }
}

private val COMPUTED: MutableMap<String, BigInteger?> = HashMap()
private fun sterling1(n: Int, k: Int): BigInteger? {
    val key = "$n,$k"
    if (COMPUTED.containsKey(key)) {
        return COMPUTED[key]
    }

    if (n == 0 && k == 0) {
        return BigInteger.valueOf(1)
    }
    if (n > 0 && k == 0) {
        return BigInteger.ZERO
    }
    if (k > n) {
        return BigInteger.ZERO
    }

    val result = sterling1(n - 1, k - 1)!!.add(BigInteger.valueOf(n - 1.toLong()).multiply(sterling1(n - 1, k)))
    COMPUTED[key] = result
    return result
}
