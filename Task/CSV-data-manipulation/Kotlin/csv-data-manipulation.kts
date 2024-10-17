// version 1.1.3

import java.io.File

fun main(args: Array<String>) {
    val lines = File("example.csv").readLines().toMutableList()
    lines[0] += ",SUM"
    for (i in 1 until lines.size) {
        lines[i] += "," + lines[i].split(',').sumBy { it.toInt() }
    }
    val text = lines.joinToString("\n")
    File("example2.csv").writeText(text)  // write to new file
    println(text)  // print to console
}
