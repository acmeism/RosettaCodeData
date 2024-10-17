// version 1.1.51

typealias Table = List<List<String>>

/* Note that if ordering is specified, first two parameters are ignored */
fun Table.sort(
    column: Int = 0,
    reverse: Boolean = false,
    ordering: Comparator<List<String>> =
        if (!reverse) compareBy  { it[column] }
        else compareByDescending { it[column] }
) = this.sortedWith(ordering)

fun Table.print(title: String) {
    println(title)
    for (i in 0 until this.size) {
        for (j in 0 until this[0].size) System.out.print("%-3s  ".format(this[i][j]))
        println()
    }
    println()
}

fun main(args: Array<String>) {
    val table = listOf(
        listOf("a", "b", "c"),
        listOf("", "q", "z"),
        listOf("zap", "zip", "Zot")
    )
    table.print("Original:")

    val titles = listOf(
        "Sorted by col 0:", "Sorted by col 1:", "Sorted by col 2:",
        "Reverse sorted by col 0:", "Reverse sorted by col 1:", "Reverse Sorted by col 2"
    )
    val params = listOf(
        0 to false, 1 to false, 2 to false, 0 to true, 1 to true, 2 to true
    )
    for ((i, title) in titles.withIndex()) {
        val table2 = table.sort(params[i].first, params[i].second)
        table2.print(title)
    }
    // using non-default Comparator (case insensitive by col 2, reversed)
    val comp: Comparator<List<String>> = compareByDescending { it[2].toLowerCase() }
    val table3 = table.sort(ordering = comp)
    table3.print("Reverse case insensitive sort by col 2:")
}
