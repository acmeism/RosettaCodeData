// Version 1.2.60

const val STX = "\u0002"
const val ETX = "\u0003"

fun bwt(s: String): String {
    if (s.contains(STX) || s.contains(ETX)) {
        throw RuntimeException("String can't contain STX or ETX")
    }
    val ss = STX + s + ETX
    val table = Array<String>(ss.length) { ss.substring(it) + ss.substring(0, it) }
    table.sort()
    return String(table.map { it[it.lastIndex] }.toCharArray())
}

fun ibwt(r: String): String {
    val len = r.length
    val table = Array<String>(len) { "" }
    repeat(len) {
        for (i in 0 until len) {
            table[i] = r[i].toString() + table[i]
        }
        table.sort()
    }
    for (row in table) {
        if (row.endsWith(ETX)) {
            return row.substring(1, len - 1)
        }
    }
    return ""
}

fun makePrintable(s: String): String {
    // substitute ^ for STX and | for ETX to print results
    return s.replace(STX, "^").replace(ETX, "|")
}

fun main(args: Array<String>) {
    val tests = listOf(
        "banana",
        "appellee",
        "dogwood",
        "TO BE OR NOT TO BE OR WANT TO BE OR NOT?",
        "SIX.MIXED.PIXIES.SIFT.SIXTY.PIXIE.DUST.BOXES",
        "\u0002ABC\u0003"
    )
    for (test in tests) {
        println(makePrintable(test))
        print(" --> ")
        var t = ""
        try {
            t = bwt(test)
            println(makePrintable(t))
        }
        catch (ex: RuntimeException) {
            println("ERROR: " + ex.message)
        }
        val r = ibwt(t)
        println(" --> $r\n")
    }
}
