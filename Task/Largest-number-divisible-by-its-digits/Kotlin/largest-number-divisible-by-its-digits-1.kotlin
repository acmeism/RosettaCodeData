// version 1.1.4-3

fun Int.divByAll(digits: List<Char>) = digits.all { this % (it - '0') == 0 }

fun main(args: Array<String>) {
    val magic = 9 * 8 * 7
    val high = 9876432 / magic * magic
    for (i in high downTo magic step magic) {
        if (i % 10 == 0) continue            // can't end in '0'
        val s = i.toString()
        if ('0' in s || '5' in s) continue   // can't contain '0' or '5'
        val sd = s.toCharArray().distinct()
        if (sd.size != s.length) continue    // digits must be unique
        if (i.divByAll(sd)) {
            println("Largest decimal number is $i")
            return
        }
    }
}
