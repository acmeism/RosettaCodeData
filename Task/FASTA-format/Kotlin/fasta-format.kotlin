// version 1.1.2

import java.util.Scanner
import java.io.File

fun checkNoSpaces(s: String) = ' ' !in s && '\t' !in s

fun main(args: Array<String>) {
    var first = true
    val sc = Scanner(File("input.fasta"))
    while (sc.hasNextLine()) {
        val line = sc.nextLine()
        if (line[0] == '>') {
            if (!first) println()
            print("${line.substring(1)}: ")
            if (first) first = false
        }
        else if (first) {
            println("Error : File does not begin with '>'")
            break
        }
        else if (checkNoSpaces(line))
            print(line)
        else {
            println("\nError : Sequence contains space(s)")
            break
        }
    }
    sc.close()
}
