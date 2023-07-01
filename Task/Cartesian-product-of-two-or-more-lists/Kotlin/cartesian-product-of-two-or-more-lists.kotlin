// version 1.1.2

fun flattenList(nestList: List<Any>): List<Any> {
    val flatList = mutableListOf<Any>()

    fun flatten(list: List<Any>) {
        for (e in list) {
            if (e !is List<*>)
                flatList.add(e)
            else
                @Suppress("UNCHECKED_CAST")
                flatten(e as List<Any>)
        }
    }

    flatten(nestList)
    return flatList
}

operator fun List<Any>.times(other: List<Any>): List<List<Any>> {
    val prod = mutableListOf<List<Any>>()
    for (e in this) {
        for (f in other) {
            prod.add(listOf(e, f))
        }
    }
    return prod
}

fun nAryCartesianProduct(lists: List<List<Any>>): List<List<Any>> {
    require(lists.size >= 2)
    return lists.drop(2).fold(lists[0] * lists[1]) { cp, ls -> cp * ls }.map { flattenList(it) }
}

fun printNAryProduct(lists: List<List<Any>>) {
    println("${lists.joinToString(" x ")} = ")
    println("[")
    println(nAryCartesianProduct(lists).joinToString("\n    ", "    "))
    println("]\n")
}

fun main(args: Array<String>) {
   println("[1, 2] x [3, 4] = ${listOf(1, 2) * listOf(3, 4)}")
   println("[3, 4] x [1, 2] = ${listOf(3, 4) * listOf(1, 2)}")
   println("[1, 2] x []     = ${listOf(1, 2) * listOf()}")
   println("[]     x [1, 2] = ${listOf<Any>() * listOf(1, 2)}")
   println("[1, a] x [2, b] = ${listOf(1, 'a') * listOf(2, 'b')}")
   println()
   printNAryProduct(listOf(listOf(1776, 1789), listOf(7, 12), listOf(4, 14, 23), listOf(0, 1)))
   printNAryProduct(listOf(listOf(1, 2, 3), listOf(30), listOf(500, 100)))
   printNAryProduct(listOf(listOf(1, 2, 3), listOf<Int>(), listOf(500, 100)))
   printNAryProduct(listOf(listOf(1, 2, 3), listOf(30), listOf('a', 'b')))
}
