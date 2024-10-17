// version 1.0.6

fun sumDigits(n: Long): Int = when {
        n < 0L -> throw IllegalArgumentException("Negative numbers not allowed")
        else   -> {
            var sum = 0
            var nn  = n
            while (nn > 0L) {
                sum += (nn % 10).toInt()
                nn /= 10
            }
            sum
        }
    }

fun digitalRoot(n: Long): Pair<Int, Int> = when {
        n < 0L  -> throw IllegalArgumentException("Negative numbers not allowed")
        n < 10L -> Pair(n.toInt(), 0)
        else    -> {
            var dr = n
            var ap = 0
            while (dr > 9L) {
                dr = sumDigits(dr).toLong()
                ap++
            }
            Pair(dr.toInt(), ap)
        }
    }

fun main(args: Array<String>) {
    val a = longArrayOf(1, 14, 267, 8128, 627615, 39390, 588225, 393900588225)
    for (n in a) {
        val(dr, ap) = digitalRoot(n)
        println("${n.toString().padEnd(12)} has additive persistence $ap and digital root of $dr")
    }
}
