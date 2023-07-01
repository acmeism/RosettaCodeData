// version 1.1.4-3

import java.math.BigInteger

const val MAX_N = 250
const val BRANCHES = 4

val rooted   = Array(MAX_N + 1) { if (it < 2) BigInteger.ONE else BigInteger.ZERO }
val unrooted = Array(MAX_N + 1) { if (it < 2) BigInteger.ONE else BigInteger.ZERO }
val c = Array(BRANCHES) { BigInteger.ZERO }

fun tree(br: Int, n: Int, l: Int, s: Int, cnt: BigInteger) {
    var sum = s
    for (b in (br + 1)..BRANCHES) {
        sum += n
        if (sum > MAX_N || (l * 2 >= sum && b >= BRANCHES)) return

        var tmp = rooted[n]
        if (b == br + 1) {
            c[br] = tmp * cnt
        }
        else {
            val diff = (b - br).toLong()
            c[br] *= tmp + BigInteger.valueOf(diff - 1L)
            c[br] /= BigInteger.valueOf(diff)
        }

        if (l * 2 < sum) unrooted[sum] += c[br]
        if (b < BRANCHES) rooted[sum] += c[br]
        for (m in n - 1 downTo 1) tree(b, m, l, sum, c[br])
    }
}

fun bicenter(s: Int) {
    if ((s and 1) == 0) {
        var tmp = rooted[s / 2]
        tmp *= tmp + BigInteger.ONE
        unrooted[s] += tmp.shiftRight(1)
    }
}

fun main(args: Array<String>) {
    for (n in 1..MAX_N) {
        tree(0, n, n, 1, BigInteger.ONE)
        bicenter(n)
        println("$n: ${unrooted[n]}")
    }
}
