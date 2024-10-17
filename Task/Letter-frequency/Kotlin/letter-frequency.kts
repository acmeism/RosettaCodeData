// version 1.1.2

import java.io.File

fun main(args: Array<String>) {
    val text = File("input.txt").readText().toLowerCase()
    val letterMap = text.filter { it in 'a'..'z' }.groupBy { it }.toSortedMap()
    for (letter in letterMap) println("${letter.key} = ${letter.value.size}")
    val sum = letterMap.values.sumBy { it.size }
    println("\nTotal letters = $sum")
}
