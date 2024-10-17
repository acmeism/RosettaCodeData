// version 1.1.2

fun String.strip(extendedChars: Boolean = false): String {
    val sb = StringBuilder()
    for (c in this) {
        val i = c.toInt()
        if (i in 32..126 || (!extendedChars && i >= 128)) sb.append(c)
    }
    return sb.toString()
}

fun main(args: Array<String>) {
    println("Originally:")
    val s = "123\tabc\u0007DEF\u007F+-*/€æŧðłþ"
    println("String = $s  Length = ${s.length}")
    println("\nAfter stripping control characters:")
    val t = s.strip()
    println("String = $t  Length = ${t.length}")
    println("\nAfter stripping control and extended characters:")
    val u = s.strip(true)
    println("String = $u  Length = ${u.length}")
}
