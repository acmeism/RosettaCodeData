// version 1.1.2

object BraceExpansion {
    fun expand(s: String) = expandR("", s, "")

    private val r = Regex("""([\\]{2}|[\\][,}{])""")

    private fun expandR(pre: String, s: String, suf: String) {
        val noEscape = s.replace(r, "  ")
        var sb = StringBuilder("")
        var i1 = noEscape.indexOf('{')
        var i2 = 0

        outer@ while (i1 != -1) {
            sb = StringBuilder(s)
            var depth = 1
            i2 = i1 + 1
            while (i2 < s.length && depth > 0) {
                val c = noEscape[i2]

                if (c == '{') depth++
                else if (c == '}') depth--

                if (c == ',' && depth == 1) sb[i2] = '\u0000'
                else if (c == '}' && depth == 0 && sb.indexOf("\u0000") != -1) break@outer
                i2++
            }
            i1 = noEscape.indexOf('{', i1 + 1)
        }
        if (i1 == -1) {
            if (suf.isNotEmpty()) expandR(pre + s, suf, "")
            else println("$pre$s$suf")
        } else {
            for (m in sb.substring(i1 + 1, i2).split('\u0000')) {
                expandR(pre + s.substring(0, i1), m, s.substring(i2 + 1) + suf)
            }
        }
    }
}

fun main(args: Array<String>) {
    val strings = arrayOf(
        """~/{Downloads,Pictures}/*.{jpg,gif,png}""",
        """It{{em,alic}iz,erat}e{d,}, please.""",
        """{,{,gotta have{ ,\, again\, }}more }cowbell!""",
        """{}} some }{,{\\{ edge, edge} \,}{ cases, {here} \\\\\}"""
    )
    for (s in strings) {
        println()
        BraceExpansion.expand(s)
    }
}
