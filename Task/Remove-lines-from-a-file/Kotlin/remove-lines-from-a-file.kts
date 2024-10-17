// version 1.1.2

import java.io.File

fun removeLines(fileName: String, startLine: Int, numLines: Int) {
    require(!fileName.isEmpty() && startLine >= 1 && numLines >= 1)
    val f = File(fileName)
    if (!f.exists()) {
        println("$fileName does not exist")
        return
    }
    var lines = f.readLines()
    val size = lines.size
    if (startLine > size) {
        println("The starting line is beyond the length of the file")
        return
    }
    var n = numLines
    if (startLine + numLines - 1 > size) {
        println("Attempting to remove some lines which are beyond the end of the file")
        n = size - startLine + 1
    }
    lines = lines.take(startLine - 1) + lines.drop(startLine + n - 1)
    val text = lines.joinToString(System.lineSeparator())
    f.writeText(text)
}

fun printFile(fileName: String, message: String) {
    require(!fileName.isEmpty())
    val f = File(fileName)
    if (!f.exists()) {
        println("$fileName does not exist")
        return
    }
    println("\nContents of $fileName $message:\n")
    f.forEachLine { println(it) }
}

fun main(args: Array<String>) {
    printFile("input.txt", "before removal")
    removeLines("input.txt", 2, 3)
    printFile("input.txt", "after removal of 3 lines starting from the second")
}
