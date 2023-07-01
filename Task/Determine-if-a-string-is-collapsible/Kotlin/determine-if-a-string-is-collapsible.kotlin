fun collapse(s: String): String {
    val cs = StringBuilder()
    var last: Char = 0.toChar()
    for (c in s) {
        if (c != last) {
            cs.append(c)
            last = c
        }
    }
    return cs.toString()
}

fun main() {
    val strings = arrayOf(
        "",
        "\"If I were two-faced, would I be wearing this one?\" --- Abraham Lincoln ",
        "..1111111111111111111111111111111111111111111111111111111111111117777888",
        "I never give 'em hell, I just tell the truth, and they think it's hell. ",
        "                                                   ---  Harry S Truman  ",
        "The better the 4-wheel drive, the further you'll be from help when ya get stuck!",
        "headmistressship",
        "aardvark"
    )
    for (s in strings) {
        val c = collapse(s)
        println("original : length = ${s.length}, string = «««$s»»»")
        println("collapsed : length = ${c.length}, string = «««$c»»»")
        println()
    }
}
