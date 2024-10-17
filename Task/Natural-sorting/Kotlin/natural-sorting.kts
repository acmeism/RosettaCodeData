// version 1.1.4-3

val r2 = Regex("""[ ]{2,}""")
val r3 = Regex("""\s""")  // \s represents any whitespace character
val r5 = Regex("""\d+""")

/** Only covers ISO-8859-1 accented characters plus (for consistency) Ÿ */
val ucAccented = arrayOf("ÀÁÂÃÄÅ", "Ç", "ÈÉÊË", "ÌÍÎÏ", "Ñ", "ÒÓÔÕÖØ", "ÙÚÛÜ", "ÝŸ")
val lcAccented = arrayOf("àáâãäå", "ç", "èéêë", "ìíîï", "ñ", "òóôõöø", "ùúûü", "ýÿ")
val ucNormal = "ACEINOUY"
val lcNormal = "aceinouy"

/** Only the commoner ligatures */
val ucLigatures = "ÆĲŒ"
val lcLigatures = "æĳœ"
val ucSeparated = arrayOf("AE", "IJ", "OE")
val lcSeparated = arrayOf("ae", "ij", "oe")

/** Miscellaneous replacements */
val miscLetters = "ßſʒ"
val miscReplacements = arrayOf("ss", "s", "s")

/** Displays strings including whitespace as if the latter were literal characters */
fun String.toDisplayString(): String {
    val whitespace  = arrayOf("\t", "\n", "\u000b", "\u000c", "\r")
    val whitespace2 = arrayOf("\\t", "\\n", "\\u000b", "\\u000c", "\\r")
    var s = this
    for (i in 0..4) s = s.replace(whitespace[i], whitespace2[i])
    return s
}

/** Ignoring leading space(s) */
fun selector1(s: String) = s.trimStart(' ')

/** Ignoring multiple adjacent spaces i.e. condensing to a single space */
fun selector2(s: String) = s.replace(r2, " ")

/** Equivalent whitespace characters (equivalent to a space say) */
fun selector3(s: String) = s.replace(r3, " ")

/** Case independent sort */
fun selector4(s: String) = s.toLowerCase()

/** Numeric fields as numerics (deals with up to 20 digits) */
fun selector5(s: String) = r5.replace(s) { it.value.padStart(20, '0') }

/** Title sort */
fun selector6(s: String): String {
    if (s.startsWith("the ", true)) return s.drop(4)
    if (s.startsWith("an ", true)) return s.drop(3)
    if (s.startsWith("a ", true)) return s.drop(2)
    return s
}

/** Equivalent accented characters (and case) */
fun selector7(s: String): String {
    val sb = StringBuilder()
    outer@ for (c in s) {
        for ((i, ucs) in ucAccented.withIndex()) {
            if (c in ucs) {
                sb.append(ucNormal[i])
                continue@outer
            }
        }
        for ((i, lcs) in lcAccented.withIndex()) {
            if (c in lcs) {
                sb.append(lcNormal[i])
                continue@outer
            }
        }
        sb.append(c)
    }
    return sb.toString().toLowerCase()
}

/** Separated ligatures */
fun selector8(s: String): String {
    var ss = s
    for ((i, c) in ucLigatures.withIndex()) ss = ss.replace(c.toString(), ucSeparated[i])
    for ((i, c) in lcLigatures.withIndex()) ss = ss.replace(c.toString(), lcSeparated[i])
    return ss
}

/** Character replacements */
fun selector9(s: String): String {
    var ss = s
    for ((i, c) in miscLetters.withIndex()) ss = ss.replace(c.toString(), miscReplacements[i])
    return ss
}

fun main(args: Array<String>) {
    println("The 9 string lists, sorted 'naturally':\n")
    val s1 = arrayOf(
        "ignore leading spaces: 2-2",
        " ignore leading spaces: 2-1",
        "  ignore leading spaces: 2+0",
        "   ignore leading spaces: 2+1"
    )
    s1.sortBy(::selector1)
    println(s1.map { "'$it'" }.joinToString("\n"))

    val s2 = arrayOf(
        "ignore m.a.s spaces: 2-2",
        "ignore m.a.s  spaces: 2-1",
        "ignore m.a.s   spaces: 2+0",
        "ignore m.a.s    spaces: 2+1"
    )
    println()
    s2.sortBy(::selector2)
    println(s2.map { "'$it'" }.joinToString("\n"))

    val s3 = arrayOf(
        "Equiv. spaces: 3-3",
        "Equiv.\rspaces: 3-2",
        "Equiv.\u000cspaces: 3-1",
        "Equiv.\u000bspaces: 3+0",
        "Equiv.\nspaces: 3+1",
        "Equiv.\tspaces: 3+2"
    )
    println()
    s3.sortBy(::selector3)
    println(s3.map { "'$it'".toDisplayString() }.joinToString("\n"))

    val s4 = arrayOf(
        "cASE INDEPENENT: 3-2",
        "caSE INDEPENENT: 3-1",
        "casE INDEPENENT: 3+0",
        "case INDEPENENT: 3+1"
    )
    println()
    s4.sortBy(::selector4)
    println(s4.map { "'$it'" }.joinToString("\n"))

    val s5 = arrayOf(
        "foo100bar99baz0.txt",
        "foo100bar10baz0.txt",
        "foo1000bar99baz10.txt",
        "foo1000bar99baz9.txt"
    )
    println()
    s5.sortBy(::selector5)
    println(s5.map { "'$it'" }.joinToString("\n"))

    val s6 = arrayOf(
        "The Wind in the Willows",
        "The 40th step more",
        "The 39 steps",
        "Wanda"
    )
    println()
    s6.sortBy(::selector6)
    println(s6.map { "'$it'" }.joinToString("\n"))

    val s7 = arrayOf(
        "Equiv. ý accents: 2-2",
        "Equiv. Ý accents: 2-1",
        "Equiv. y accents: 2+0",
        "Equiv. Y accents: 2+1"
    )
    println()
    s7.sortBy(::selector7)
    println(s7.map { "'$it'" }.joinToString("\n"))

    val s8 = arrayOf(
        "Ĳ ligatured ij",
        "no ligature"
    )
    println()
    s8.sortBy(::selector8)
    println(s8.map { "'$it'" }.joinToString("\n"))

    val s9 = arrayOf(
        "Start with an ʒ: 2-2",
        "Start with an ſ: 2-1",
        "Start with an ß: 2+0",
        "Start with an s: 2+1"
    )
    println()
    s9.sortBy(::selector9)
    println(s9.map { "'$it'" }.joinToString("\n"))
}
