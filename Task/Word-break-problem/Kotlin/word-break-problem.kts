// version 1.1.3

import java.io.File

val partitions = mutableListOf<List<String>>()

fun partitionString(s: String, ml: MutableList<String>, level: Int) {
    for (i in s.length - 1 downTo 1) {
        val part1 = s.substring(0, i)
        val part2 = s.substring(i)
        ml.add(part1)
        ml.add(part2)
        partitions.add(ml.toList())
        if (part2.length > 1) {
            ml.removeAt(ml.lastIndex)
            partitionString(part2, ml, level + 1)
        }
        while (ml.size > level) ml.removeAt(ml.lastIndex)
    }
}

fun main(args: Array<String>) {
    val words = File("unixdict.txt").readLines()
    val strings = listOf("abcd", "abbc", "abcbcd", "acdbc", "abcdd")
    for (s in strings) {
        partitions.clear()
        partitions.add(listOf(s))
        val ml = mutableListOf<String>()
        partitionString(s, ml, 0)
        val solutions = mutableListOf<List<String>>()
        for (partition in partitions) {
            var allInDict = true
            for (item in partition) {
                if (words.indexOf(item) == -1) {
                    allInDict = false
                    break
                }
            }
            if (allInDict) solutions.add(partition)
        }
        val plural = if (solutions.size == 1) "" else "s"
        println("$s: ${solutions.size} solution$plural")
        for (solution in solutions) {
            println("    ${solution.joinToString(" ")}")
        }
        println()
    }
}
