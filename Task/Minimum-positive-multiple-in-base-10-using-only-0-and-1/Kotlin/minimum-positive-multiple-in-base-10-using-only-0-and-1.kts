import java.math.BigInteger

fun main() {
    for (n in testCases) {
        val result = getA004290(n)
        println("A004290($n) = $result = $n * ${result / n.toBigInteger()}")
    }
}

private val testCases: List<Int>
    get() {
        val testCases: MutableList<Int> = ArrayList()
        for (i in 1..10) {
            testCases.add(i)
        }
        for (i in 95..105) {
            testCases.add(i)
        }
        for (i in intArrayOf(297, 576, 594, 891, 909, 999, 1998, 2079, 2251, 2277, 2439, 2997, 4878)) {
            testCases.add(i)
        }
        return testCases
    }

private fun getA004290(n: Int): BigInteger {
    if (n == 1) {
        return BigInteger.ONE
    }
    val arr = Array(n) { IntArray(n) }
    for (i in 2 until n) {
        arr[0][i] = 0
    }
    arr[0][0] = 1
    arr[0][1] = 1
    var m = 0
    val ten = BigInteger.TEN
    val nBi = n.toBigInteger()
    while (true) {
        m++
        if (arr[m - 1][mod(-ten.pow(m), nBi).toInt()] == 1) {
            break
        }
        arr[m][0] = 1
        for (k in 1 until n) {
            arr[m][k] = arr[m - 1][k].coerceAtLeast(arr[m - 1][mod(k.toBigInteger() - ten.pow(m), nBi).toInt()])
        }
    }
    var r = ten.pow(m)
    var k = mod(-r, nBi)
    for (j in m - 1 downTo 1) {
        if (arr[j - 1][k.toInt()] == 0) {
            r += ten.pow(j)
            k = mod(k - ten.pow(j), nBi)
        }
    }
    if (k.compareTo(BigInteger.ONE) == 0) {
        r += BigInteger.ONE
    }
    return r
}

private fun mod(m: BigInteger, n: BigInteger): BigInteger {
    var result = m.mod(n)
    if (result < BigInteger.ZERO) {
        result += n
    }
    return result
}
