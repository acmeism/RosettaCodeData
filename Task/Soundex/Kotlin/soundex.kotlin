// version 1.1.2

fun getCode(c: Char) = when (c) {
    'B', 'F', 'P', 'V' -> "1"
    'C', 'G', 'J', 'K', 'Q', 'S', 'X', 'Z' -> "2"
    'D', 'T' -> "3"
    'L' -> "4"
    'M', 'N' -> "5"
    'R' -> "6"
    'H', 'W' -> "-"
    else -> ""
}

fun soundex(s: String): String {
    if (s == "") return ""
    val sb = StringBuilder().append(s[0].toUpperCase())
    var prev = getCode(sb[0])
    for (i in 1 until s.length) {
        val curr = getCode(s[i].toUpperCase())
        if (curr != "" && curr != "-" && curr != prev) sb.append(curr)
        if (curr != "-") prev = curr
    }
    return sb.toString().padEnd(4, '0').take(4)
}

fun main(args: Array<String>) {
    val pairs = arrayOf(
        "Ashcraft"  to "A261",
        "Ashcroft"  to "A261",
        "Gauss"     to "G200",
        "Ghosh"     to "G200",
        "Hilbert"   to "H416",
        "Heilbronn" to "H416",
        "Lee"       to "L000",
        "Lloyd"     to "L300",
        "Moses"     to "M220",
        "Pfister"   to "P236",
        "Robert"    to "R163",
        "Rupert"    to "R163",
        "Rubin"     to "R150",
        "Tymczak"   to "T522",
        "Soundex"   to "S532",
        "Example"   to "E251"
    )
    for (pair in pairs) {
        println("${pair.first.padEnd(9)} -> ${pair.second} -> ${soundex(pair.first) == pair.second}")
    }
}
