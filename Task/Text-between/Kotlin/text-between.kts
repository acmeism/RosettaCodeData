// version 1.2.10

fun String.textBetween(start: String, end: String): String {
    require(!start.isEmpty() && !end.isEmpty())
    if (this.isEmpty()) return this
    val s = if (start == "start") 0 else this.indexOf(start)
    if (s == -1) return ""
    val si = if (start == "start") 0 else s + start.length
    val e = if (end == "end") this.length else this.indexOf(end, si)
    if (e == -1) return this.substring(si)
    return this.substring(si, e)
}

fun main(args: Array<String>) {
    val texts = listOf(
        "Hello Rosetta Code world",
        "Hello Rosetta Code world",
        "Hello Rosetta Code world",
        "</div><div style=\"chinese\">你好嗎</div>",
        "<text>Hello <span>Rosetta Code</span> world</text><table style=\"myTable\">",
        "<table style=\"myTable\"><tr><td>hello world</td></tr></table>",
        "The quick brown fox jumps over the lazy other fox",
        "One fish two fish red fish blue fish",
        "FooBarBazFooBuxQuux"
    )
    val startEnds = listOf(
        "Hello " to " world",
        "start" to " world",
        "Hello " to "end",
        "<div style=\"chinese\">" to "</div>",
        "<text>" to "<table>",
        "<table>" to "</table>",
        "quick " to " fox",
        "fish " to " red",
        "Foo" to "Foo"
    )
    for ((i, text) in texts.withIndex()) {
        println("Text: \"$text\"")
        val (s, e) = startEnds[i]
        println("Start delimiter: \"$s\"")
        println("End delimiter: \"$e\"")
        val b = text.textBetween(s, e)
        println("Output: \"$b\"\n")
    }
}
