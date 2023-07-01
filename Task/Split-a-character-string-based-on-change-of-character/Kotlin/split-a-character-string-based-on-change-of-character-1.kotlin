// version 1.0.6

fun splitOnChange(s: String): String {
    if (s.length < 2) return s
    var t = s.take(1)
    for (i in 1 until s.length)
        if (t.last() == s[i]) t += s[i]
        else t += ", " + s[i]
    return t
}

fun main(args: Array<String>) {
    val s = """gHHH5YY++///\"""
    println(splitOnChange(s))
}
