// version 1.1.2

class FourSquares(
    private val lo: Int,
    private val hi: Int,
    private val unique: Boolean,
    private val show: Boolean
) {
    private var a = 0
    private var b = 0
    private var c = 0
    private var d = 0
    private var e = 0
    private var f = 0
    private var g = 0
    private var s = 0

    init {
        println()
        if (show) {
            println("a b c d e f g")
            println("-------------")
        }
        acd()
        println("\n$s ${if (unique) "unique" else "non-unique"} solutions in $lo to $hi")
    }

    private fun acd() {
        c = lo
        while (c <= hi) {
            d = lo
            while (d <= hi) {
                if (!unique || c != d) {
                    a = c + d
                    if ((a in lo..hi) && (!unique || (c != 0 && d!= 0))) ge()
                }
                d++
            }
            c++
        }
    }

    private fun bf() {
        f = lo
        while (f <= hi) {
            if (!unique || (f != a && f != c && f != d && f != e && f!= g)) {
                b = e + f - c
                if ((b in lo..hi) && (!unique || (b != a && b != c && b != d && b != e && b != f && b!= g))) {
                    s++
                    if (show) println("$a $b $c $d $e $f $g")
                }
            }
            f++
        }
    }

    private fun ge() {
        e = lo
        while (e <= hi) {
            if (!unique || (e != a && e != c && e != d)) {
                g = d + e
                if ((g in lo..hi) && (!unique || (g != a && g != c && g != d && g != e))) bf()
            }
            e++
        }
    }
}

fun main(args: Array<String>) {
    FourSquares(1, 7, true, true)
    FourSquares(3, 9, true, true)
    FourSquares(0, 9, false, false)
}
