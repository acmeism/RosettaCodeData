// Version 1.3.21

typealias Range = Triple<Int, Int, Boolean>

fun main() {
    val rgs = listOf<Range>(
        Range(2, 1000, true),
        Range(1000, 4000, true),
        Range(2, 10_000, false),
        Range(2, 100_000, false),
        Range(2, 1_000_000, false),
        Range(2, 10_000_000, false),
        Range(2, 100_000_000, false),
        Range(2, 1_000_000_000, false)
    )
    for (rg in rgs) {
        val (start, end, prnt) = rg
        if (start == 2) {
            println("eban numbers up to and including $end:")
        } else {
            println("eban numbers between $start and $end (inclusive):")
        }
        var count = 0
        for (i in start..end step 2) {
            val b = i / 1_000_000_000
            var r = i % 1_000_000_000
            var m = r / 1_000_000
            r = i % 1_000_000
            var t = r / 1_000
            r %= 1_000
            if (m >= 30 && m <= 66) m %= 10
            if (t >= 30 && t <= 66) t %= 10
            if (r >= 30 && r <= 66) r %= 10
            if (b == 0 || b == 2 || b == 4 || b == 6) {
                if (m == 0 || m == 2 || m == 4 || m == 6) {
                    if (t == 0 || t == 2 || t == 4 || t == 6) {
                        if (r == 0 || r == 2 || r == 4 || r == 6) {
                            if (prnt) print("$i ")
                            count++
                        }
                    }
                }
            }
        }
        if (prnt) println()
        println("count = $count\n")
    }
}
