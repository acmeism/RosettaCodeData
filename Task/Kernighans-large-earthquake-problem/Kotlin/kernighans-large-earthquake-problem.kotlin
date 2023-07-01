// Version 1.2.40

import java.io.File

fun main(args: Array<String>) {
    val r = Regex("""\s+""")
    println("Those earthquakes with a magnitude > 6.0 are:\n")
    File("data.txt").forEachLine {
        if (it.split(r)[2].toDouble() > 6.0) println(it)
    }
}
