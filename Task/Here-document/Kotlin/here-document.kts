// version 1.1.0

fun main(args: Array<String>) {
    val ev = "embed variables"

    val here = """
               This is a raw string literal
               which does not treat escaped characters
               (\t, \b, \n, \r, \', \", \\, \$ and \u)
               specially and can contain new lines,
               indentation and other        whitespace
               within the string.

"Quotes" or doubled ""quotes"" can
be included without problem but not
tripled quotes.

           It's also possible to $ev
           in a raw string literal using string
           interpolation.

  If you need to include a
  literal ${'$'} sign in a raw string literal then
  don't worry you've just done it!
               """

    println(here)
}
