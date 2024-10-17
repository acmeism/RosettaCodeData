// version 1.2.10

/* if string is empty, returns zero */
fun String.toDoubleOrZero() = this.toDoubleOrNull() ?: 0.0

fun multiply(s: String): String {
    val b = s.split('*').map { it.toDoubleOrZero() }
    return (b[0] * b[1]).toString()
}

fun divide(s: String): String {
    val b = s.split('/').map { it.toDoubleOrZero() }
    return (b[0] / b[1]).toString()
}

fun add(s: String): String {
    var t = s.replace(Regex("""^\+"""), "").replace(Regex("""\++"""), "+")
    val b = t.split('+').map { it.toDoubleOrZero() }
    return (b[0] + b[1]).toString()
}

fun subtract(s: String): String {
    var t = s.replace(Regex("""(\+-|-\+)"""), "-")
    if ("--" in t) return add(t.replace("--", "+"))
    val b = t.split('-').map { it.toDoubleOrZero() }
    return (if (b.size == 3) -b[1] - b[2] else b[0] - b[1]).toString()
}

fun evalExp(s: String): String {
    var t = s.replace(Regex("""[()]"""), "")
    val reMD = Regex("""\d+\.?\d*\s*[*/]\s*[+-]?\d+\.?\d*""")
    val reM  = Regex( """\*""")
    val reAS = Regex("""-?\d+\.?\d*\s*[+-]\s*[+-]?\d+\.?\d*""")
    val reA  = Regex("""\d\+""")

    while (true) {
        val match = reMD.find(t)
        if (match == null) break
        val exp = match.value
        val match2 = reM.find(exp)
        t = if (match2 != null)
                t.replace(exp, multiply(exp))
            else
                t.replace(exp, divide(exp))
    }

    while (true) {
        val match = reAS.find(t)
        if (match == null) break
        val exp = match.value
        val match2 = reA.find(exp)
        t = if (match2 != null)
                t.replace(exp, add(exp))
            else
                t.replace(exp, subtract(exp))
    }

    return t
}

fun evalArithmeticExp(s: String): Double {
    var t = s.replace(Regex("""\s"""), "").replace("""^\+""", "")
    val rePara = Regex("""\([^()]*\)""")
    while(true) {
        val match = rePara.find(t)
        if (match == null) break
        val exp = match.value
        t = t.replace(exp, evalExp(exp))
    }
    return evalExp(t).toDoubleOrZero()
}

fun main(arsg: Array<String>) {
    listOf(
        "2+3",
        "2+3/4",
        "2*3-4",
        "2*(3+4)+5/6",
        "2 * (3 + (4 * 5 + (6 * 7) * 8) - 9) * 10",
        "2*-3--4+-0.25",
         "-4 - 3",
         "((((2))))+ 3 * 5",
         "1 + 2 * (3 + (4 * 5 + 6 * 7 * 8) - 9) / 10",
         "1 + 2*(3 - 2*(3 - 2)*((2 - 4)*5 - 22/(7 + 2*(3 - 1)) - 1)) + 1"
    ).forEach { println("$it = ${evalArithmeticExp(it)}") }
}
