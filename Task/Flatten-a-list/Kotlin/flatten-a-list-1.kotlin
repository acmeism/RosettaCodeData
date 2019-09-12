// version 1.0.6

@Suppress("UNCHECKED_CAST")

fun flattenList(nestList: List<Any>, flatList: MutableList<Int>) {
    for (e in nestList)
        if (e is Int)
            flatList.add(e)
        else
            // using unchecked cast here as can't check for instance of 'erased' generic type
            flattenList(e as List<Any>, flatList)
}

fun main(args: Array<String>) {
    val nestList : List<Any> = listOf(
        listOf(1),
        2,
        listOf(listOf(3, 4), 5),
        listOf(listOf(listOf<Int>())),
        listOf(listOf(listOf(6))),
        7,
        8,
        listOf<Int>()
    )
    println("Nested    : " + nestList)
    val flatList = mutableListOf<Int>()
    flattenList(nestList, flatList)
    println("Flattened : " + flatList)
}
