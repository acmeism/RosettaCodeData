import kotlin.Comparator

fun main(args: Array<String>) {
    val comparator = Comparator<Int> { x, y -> "$x$y".compareTo("$y$x") }

    fun findLargestSequence(array: IntArray): String {
        return array.sortedWith(comparator.reversed()).joinToString("") { it.toString() }
    }

    for (array in listOf(
        intArrayOf(1, 34, 3, 98, 9, 76, 45, 4),
        intArrayOf(54, 546, 548, 60),
    )) {
        println("%s -> %s".format(array.contentToString(), findLargestSequence(array)))
    }
}
