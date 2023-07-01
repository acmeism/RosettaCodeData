// version 1.1.51

const val N = 64

fun pow2(x: Int) = 1L shl x

fun evolve(state: Long, rule: Int) {
    var state2 = state
    for (p in 0..9) {
        var b = 0
        for (q in 7 downTo 0) {
            val st = state2
            b = (b.toLong() or ((st and 1L) shl q)).toInt()
            state2 = 0L
            for (i in 0 until N) {
                val t = ((st ushr (i - 1)) or (st shl (N + 1 - i)) and 7L).toInt()
                if ((rule.toLong() and pow2(t)) != 0L) state2 = state2 or pow2(i)
            }
        }
        print(" $b")
    }
    println()
}

fun main(args: Array<String>) {
    evolve(1, 30)
}
