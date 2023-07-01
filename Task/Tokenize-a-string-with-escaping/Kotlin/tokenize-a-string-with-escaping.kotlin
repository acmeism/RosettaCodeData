// version 1.1.3

const val SPE = "\ufffe"  // unused unicode char in Specials block
const val SPF = "\uffff"  // ditto

fun tokenize(str: String, sep: Char, esc: Char): List<String> {
    var s = str.replace("$esc$esc", SPE).replace("$esc$sep", SPF)
    s = if (s.last() == esc) // i.e. 'esc' not escaping anything
        s.dropLast(1).replace("$esc", "") + esc
    else
        s.replace("$esc", "")
    return s.split(sep).map { it.replace(SPE, "$esc").replace(SPF, "$sep") }
}

fun main(args: Array<String>) {
    var str = "one^|uno||three^^^^|four^^^|^cuatro|"
    val sep = '|'
    val esc = '^'
    val items = tokenize(str, sep, esc)
    for (item in items) println(if (item.isEmpty()) "(empty)" else item)
}
