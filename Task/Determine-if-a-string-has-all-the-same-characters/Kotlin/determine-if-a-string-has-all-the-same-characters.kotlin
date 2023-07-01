fun analyze(s: String) {
    println("Examining [$s] which has a length of ${s.length}:")
    if (s.length > 1) {
        val b = s[0]
        for ((i, c) in s.withIndex()) {
            if (c != b) {
                println("    Not all characters in the string are the same.")
                println("    '$c' (0x${Integer.toHexString(c.toInt())}) is different at position $i")
                return
            }
        }
    }
    println("    All characters in the string are the same.")
}

fun main() {
    val strs = listOf("", "   ", "2", "333", ".55", "tttTTT", "4444 444k")
    for (str in strs) {
        analyze(str)
    }
}
