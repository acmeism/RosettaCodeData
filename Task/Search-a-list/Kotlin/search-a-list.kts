// version 1.0.6 (search_list.kt)

fun main(args: Array<String>) {
    val haystack = listOf("Zig", "Zag", "Wally", "Ronald", "Bush", "Krusty", "Charlie", "Bush", "Boz", "Zag")
    println(haystack)
    var needle = "Zag"
    var index  = haystack.indexOf(needle)
    val index2 = haystack.lastIndexOf(needle)
    println("\n'$needle' first occurs at index $index of the list")
    println("'$needle' last  occurs at index $index2 of the list\n")
    needle = "Donald"
    index  = haystack.indexOf(needle)
    if (index == -1) throw Exception("$needle does not occur in the list")
}
