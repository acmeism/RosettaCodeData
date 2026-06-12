// version 1.0.6

fun lcp(vararg sa: String): String {
    if (sa.isEmpty()) return ""
    if (sa.size == 1) return sa[0]
    val minLength = sa.map { it.length }.min()!!
    var oldPrefix = ""
    var newPrefix: String
    for (i in 1 .. minLength) {
        newPrefix = sa[0].substring(0, i)
        for (j in 1 until sa.size)
            if (!sa[j].startsWith(newPrefix)) return oldPrefix
        oldPrefix = newPrefix
    }
    return oldPrefix
}

fun main(args: Array<String>) {
    println("The longest common prefixes of the following collections of strings are:\n")
    println("""["interspecies","interstellar","interstate"] = "${lcp("interspecies", "interstellar", "interstate")}"""")
    println("""["throne","throne"]                          = "${lcp("throne", "throne")}"""")
    println("""["throne","dungeon"]                         = "${lcp("throne", "dungeon")}"""")
    println("""["throne","","throne"]                       = "${lcp("throne", "", "throne")}"""")
    println("""["cheese"]                                   = "${lcp("cheese")}"""")
    println("""[""]                                         = "${lcp("")}"""")
    println("""[]                                           = "${lcp()}"""")
    println("""["prefix","suffix"]                          = "${lcp("prefix", "suffix")}"""")
    println("""["foo","foobar"]                             = "${lcp("foo", "foobar")}"""")
}
