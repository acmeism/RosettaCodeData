fun indexOf(n: Int, s: IntArray): Int {
    for (i_j in s.withIndex()) {
        if (n == i_j.value) {
            return i_j.index
        }
    }
    return -1
}

fun getDigits(n: Int, le: Int, digits: IntArray): Boolean {
    var mn = n
    var mle = le
    while (mn > 0) {
        val r = mn % 10
        if (r == 0 || indexOf(r, digits) >= 0) {
            return false
        }
        mle--
        digits[mle] = r
        mn /= 10
    }
    return true
}

val pows = intArrayOf(1, 10, 100, 1_000, 10_000)

fun removeDigit(digits: IntArray, le: Int, idx: Int): Int {
    var sum = 0
    var pow = pows[le - 2]
    for (i in 0 until le) {
        if (i == idx) {
            continue
        }
        sum += digits[i] * pow
        pow /= 10
    }
    return sum
}

fun main() {
    val lims = listOf(
        Pair(12, 97),
        Pair(123, 986),
        Pair(1234, 9875),
        Pair(12345, 98764)
    )
    val count = IntArray(5)
    var omitted = arrayOf<Array<Int>>()
    for (i in 0 until 5) {
        var array = arrayOf<Int>()
        for (j in 0 until 10) {
            array += 0
        }
        omitted += array
    }
    for (i_lim in lims.withIndex()) {
        val i = i_lim.index
        val lim = i_lim.value

        val nDigits = IntArray(i + 2)
        val dDigits = IntArray(i + 2)
        val blank = IntArray(i + 2) { 0 }
        for (n in lim.first..lim.second) {
            blank.copyInto(nDigits)
            val nOk = getDigits(n, i + 2, nDigits)
            if (!nOk) {
                continue
            }
            for (d in n + 1..lim.second + 1) {
                blank.copyInto(dDigits)
                val dOk = getDigits(d, i + 2, dDigits)
                if (!dOk) {
                    continue
                }
                for (nix_digit in nDigits.withIndex()) {
                    val dix = indexOf(nix_digit.value, dDigits)
                    if (dix >= 0) {
                        val rn = removeDigit(nDigits, i + 2, nix_digit.index)
                        val rd = removeDigit(dDigits, i + 2, dix)
                        if (n.toDouble() / d.toDouble() == rn.toDouble() / rd.toDouble()) {
                            count[i]++
                            omitted[i][nix_digit.value]++
                            if (count[i] <= 12) {
                                println("$n/$d = $rn/$rd by omitting ${nix_digit.value}'s")
                            }
                        }
                    }
                }
            }
        }
        println()
    }

    for (i in 2..5) {
        println("There are ${count[i - 2]} $i-digit fractions of which:")
        for (j in 1..9) {
            if (omitted[i - 2][j] == 0) {
                continue
            }
            println("%6d have %d's omitted".format(omitted[i - 2][j], j))
        }
        println()
    }
}
