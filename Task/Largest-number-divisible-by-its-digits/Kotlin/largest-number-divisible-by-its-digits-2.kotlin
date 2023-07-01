// version 1.1.4-3

fun Long.divByAll(digits: List<Char>) =
    digits.all { this % (if (it <= '9') it - '0' else it - 'W')  == 0L }

fun main(args: Array<String>) {
    val magic = 15L * 14 * 13 * 12 * 11
    val high = 0xfedcba987654321L / magic * magic
    for (i in high downTo magic step magic) {
        if (i % 16 == 0L) continue           // can't end in '0'
        val s = i.toString(16)               // always generates lower case a-f
        if ('0' in s) continue               // can't contain '0'
        val sd = s.toCharArray().distinct()
        if (sd.size != s.length) continue    // digits must be unique
        if (i.divByAll(sd)) {
            println("Largest hex number is ${i.toString(16)}")
            return
        }
    }
}
