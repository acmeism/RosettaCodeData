// version 1.1.0

import java.io.File
import java.util.*

fun longer(a: String, b: String): Boolean =
    try {
        a.substring(b.length)
        false
    }
    catch (e: StringIndexOutOfBoundsException) {
        true
    }

fun main(args: Array<String>) {
    var lines = ""
    var longest = ""
    val sc = Scanner(File("lines.txt"))
    while(sc.hasNext()) {
        val line = sc.nextLine()
        if (longer(longest, line)) {
            longest = line
            lines = longest
        }
        else if (!longer(line, longest))
            lines = lines.plus("\n").plus(line) // using 'plus' to avoid using '+'
    }
    sc.close()
    println(lines);
    println()

    // alternatively (but cheating as library functions will use comparisons and lists under the hood)
    println(File("lines.txt").readLines().groupBy { it.length }.maxBy { it.key }!!.value.joinToString("\n"))
}
