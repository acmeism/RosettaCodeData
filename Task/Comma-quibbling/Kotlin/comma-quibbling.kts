// version 1.0.6

fun commaQuibble(s: String): String {
    val t = s.trim('[', ']').replace(" ", "").replace("\"", "")
    val words = t.split(',')
    val sb = StringBuilder("{")
    for (i in 0 until words.size) {
        sb.append(when (i) {
            0                -> ""
            words.lastIndex  -> " and "
            else             -> ", "
        })
        sb.append(words[i])
    }
    return sb.append("}").toString()
}

fun main(args: Array<String>) {
    val inputs = arrayOf(
        """[]""",
        """["ABC"]""",
        """["ABC", "DEF"]""",
        """["ABC", "DEF", "G", "H"]"""
    )
    for (input in inputs) println("${input.padEnd(24)}  ->  ${commaQuibble(input)}")
}
