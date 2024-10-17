// version 1.0.6

fun main(args: Array<String>) {
    val cl = 'a'          // character literal - can contain escaped character
    val esl = "abc\ndef"  // escaped string literal - can contain escaped character(s)
    val rsl = """
              This is a raw string literal
              which does not treat escaped characters
              (\t, \b, \n, \r, \', \", \\, \$ and \u)
              specially and can contain new lines.

              "Quotes" or doubled ""quotes"" can
              be included without problem but not
              tripled quotes.
              """
    val msl = """
              |Leading whitespace can be removed from a raw
              |string literal by including
              |a margin prefix ('|' is the default)
              |in combination with the trimMargin function.
              """.trimMargin()
    println(cl)
    println(esl)
    println(rsl)
    println(msl)
}
