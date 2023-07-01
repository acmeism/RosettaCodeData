// version 1.1.2

fun linearCombo(c: IntArray): String {
    val sb = StringBuilder()
    for ((i, n) in c.withIndex()) {
        if (n == 0) continue
        val op = when {
            n < 0 && sb.isEmpty() -> "-"
            n < 0                 -> " - "
            n > 0 && sb.isEmpty() -> ""
            else                  -> " + "
        }
        val av = Math.abs(n)
        val coeff = if (av == 1) "" else "$av*"
        sb.append("$op${coeff}e(${i + 1})")
    }
    return if(sb.isEmpty()) "0" else sb.toString()
}

fun main(args: Array<String>) {
    val combos = arrayOf(
        intArrayOf(1, 2, 3),
        intArrayOf(0, 1, 2, 3),
        intArrayOf(1, 0, 3, 4),
        intArrayOf(1, 2, 0),
        intArrayOf(0, 0, 0),
        intArrayOf(0),
        intArrayOf(1, 1, 1),
        intArrayOf(-1, -1, -1),
        intArrayOf(-1, -2, 0, -3),
        intArrayOf(-1)
    )
    for (c in combos) {
        println("${c.contentToString().padEnd(15)}  ->  ${linearCombo(c)}")
    }
}
