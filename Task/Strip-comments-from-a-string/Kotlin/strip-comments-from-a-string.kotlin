// version 1.0.6

val r = Regex("""(/\*.*\*/|//.*$)""")

fun stripComments(s: String) = s.replace(r, "").trim()

fun main(args: Array<String>) {
    val strings = arrayOf(
        "apples, pears // and bananas",
        "   apples, pears /* and bananas */",
        "/* oranges */ apples // pears and bananas  ",
        " \toranges /*apples/*, pears*/*/and bananas"
    )
    for (string in strings) println(stripComments(string))
}
