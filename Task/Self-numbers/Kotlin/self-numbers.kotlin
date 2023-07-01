private const val MC = 103 * 1000 * 10000 + 11 * 9 + 1
private val SV = BooleanArray(MC + 1)

private fun sieve() {
    val dS = IntArray(10000)
    run {
        var a = 9
        var i = 9999
        while (a >= 0) {
            for (b in 9 downTo 0) {
                var c = 9
                val s = a + b
                while (c >= 0) {
                    var d = 9
                    val t = s + c
                    while (d >= 0) {
                        dS[i--] = t + d
                        d--
                    }
                    c--
                }
            }
            a--
        }
    }
    var a = 0
    var n = 0
    while (a < 103) {
        var b = 0
        val d = dS[a]
        while (b < 1000) {
            var c = 0
            var s = d + dS[b] + n
            while (c < 10000) {
                SV[dS[c] + s++] = true
                c++
            }
            b++
            n += 10000
        }
        a++
    }
}

fun main() {
    sieve()
    println("The first 50 self numbers are:")
    run {
        var i = 0
        var count = 0
        while (count <= 50) {
            if (!SV[i]) {
                count++
                if (count <= 50) {
                    print("$i ")
                } else {
                    println()
                    println()
                    println("       Index     Self number")
                }
            }
            i++
        }
    }
    var i = 0
    var limit = 1
    var count = 0
    while (i < MC) {
        if (!SV[i]) {
            if (++count == limit) {
                println("%,12d   %,13d".format(count, i))
                limit *= 10
            }
        }
        i++
    }
}
