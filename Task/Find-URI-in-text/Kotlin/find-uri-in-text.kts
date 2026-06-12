// version 1.2.21

val pattern =
    "(?U)" +                              // Enable matching of non-ascii characters
    "[a-z][-a-z0-9+.]*:" +	          // Scheme...
    "(?=[/\\w])" +                        // ... but not just the scheme
    "(?://[-\\w.@:]+)?" +                 // Host
    "[-\\w.~/%!\$&'()*+,;=]*" +           // Path
    "(?:\\?[-\\w.~%!\$&'()*+,;=/?]*)?" +  // Query
    "(?:\\#[-\\w.~%!\$&'()*+,;=/?]*)?"    // Fragment

fun main(args: Array<String>) {
    val text = """
        |this URI contains an illegal character, parentheses and a misplaced full stop:
        |http://en.wikipedia.org/wiki/Erich_Kästner_(camera_designer). (which is handled by http://mediawiki.org/).
        |and another one just to confuse the parser: http://en.wikipedia.org/wiki/-)
        |")" is handled the wrong way by the mediawiki parser.
        |ftp://domain.name/path(balanced_brackets)/foo.html
        |ftp://domain.name/path(balanced_brackets)/ending.in.dot.
        |ftp://domain.name/path(unbalanced_brackets/ending.in.dot.
        |leading junk ftp://domain.name/path/embedded?punct/uation.
        |leading junk ftp://domain.name/dangling_close_paren)
        |if you have other interesting URIs for testing, please add them here:
        |http://www.example.org/foo.html#includes_fragment
        |http://www.example.org/foo.html#enthält_Unicode-Fragment
    """.trimMargin()
    val patterns = listOf(pattern.drop(4), pattern)
    val descs = listOf("URIs:-", "IRIs:-")
    for (i in 0..1) {
        println(descs[i])
        val regex = Regex(patterns[i])
        val matches = regex.findAll(text)
        matches.forEach { println(it.value) }
        println()
    }
}
