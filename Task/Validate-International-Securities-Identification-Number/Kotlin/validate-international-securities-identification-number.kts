// version 1.1

object Isin {
    val r = Regex("^[A-Z]{2}[A-Z0-9]{9}[0-9]$")

    fun isValid(s: String): Boolean {
        // check format
        if (!s.matches(r)) return false
        // validate checksum
        val sb = StringBuilder()
        for (c in s) {
            when (c) {
                in '0'..'9' -> sb.append(c)
                in 'A'..'Z' -> sb.append((c.toInt() - 55).toString().padStart(2, '0'))
            }
        }
        return luhn(sb.toString())
    }

    private fun luhn(s: String): Boolean {
        fun sumDigits(n: Int) = n / 10 + n % 10
        val t = s.reversed()
        val s1 = t.filterIndexed { i, _ -> i % 2 == 0 }.sumBy { it - '0' }
        val s2 = t.filterIndexed { i, _ -> i % 2 == 1 }.map { sumDigits((it - '0') * 2) }.sum()
        return (s1 + s2) % 10 == 0
    }
}

fun main(args: Array<String>) {
    val isins = arrayOf(
        "US0378331005", "US0373831005", "U50378331005", "US03378331005",
        "AU0000XVGZA3", "AU0000VXGZA3", "FR0000988040"
    )
    for (isin in isins) {
        println("$isin\t -> ${if (Isin.isValid(isin)) "valid" else "not valid"}")
    }
}
