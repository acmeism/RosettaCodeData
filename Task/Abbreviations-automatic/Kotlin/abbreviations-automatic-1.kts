// version 1.1.4-3

import java.io.File

val r = Regex("[ ]+")

fun main(args: Array<String>) {
    val lines = File("days_of_week.txt").readLines()
    for ((i, line) in lines.withIndex()) {
        if (line.trim().isEmpty()) {
            println()
            continue
        }
        val days = line.trim().split(r)
        if (days.size != 7) throw RuntimeException("There aren't 7 days in line ${i + 1}")
        if (days.distinct().size < 7) { // implies some days have the same name
            println(" ∞  $line")
            continue
        }
        var len = 1
        while (true) {
            if (days.map { it.take(len) }.distinct().size ==  7) {
                println("${"%2d".format(len)}  $line")
                break
            }
            len++
        }
    }
}
