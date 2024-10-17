// version 1.2.21

import java.io.File

fun merge2(inputFile1: String, inputFile2: String, outputFile: String) {
    val file1 = File(inputFile1)
    val file2 = File(inputFile2)
    require(file1.exists() && file2.exists()) { "Both input files must exist" }
    val reader1 = file1.bufferedReader()
    val reader2 = file2.bufferedReader()
    val writer  = File(outputFile).printWriter()
    var line1 = reader1.readLine()
    var line2 = reader2.readLine()
    while (line1 != null && line2 != null) {
        if (line1 <= line2) {
            writer.println(line1)
            line1 = reader1.readLine()
        }
        else {
            writer.println(line2)
            line2 = reader2.readLine()
        }
    }
    while (line1 != null) {
        writer.println(line1)
        line1 = reader1.readLine()
    }
    while (line2 != null) {
        writer.println(line2)
        line2 = reader2.readLine()
    }
    reader1.close()
    reader2.close()
    writer.close()
}

fun mergeN(inputFiles: List<String>, outputFile: String) {
    val files = inputFiles.map { File(it) }
    require(files.all { it.exists() }) { "All input files must exist" }
    val readers = files.map { it.bufferedReader() }
    val writer  = File(outputFile).printWriter()
    var lines = readers.map { it.readLine() }.toMutableList()
    while (lines.any { it != null }) {
        val line = lines.filterNotNull().min()
        val index = lines.indexOf(line)
        writer.println(line)
        lines[index] = readers[index].readLine()
    }
    readers.forEach { it.close() }
    writer.close()
}

fun main(args:Array<String>) {
    val files = listOf("merge1.txt", "merge2.txt", "merge3.txt", "merge4.txt")
    merge2(files[0], files[1], "merged2.txt")
    mergeN(files, "mergedN.txt")
    // check it worked
    println(File("merged2.txt").readText())
    println(File("mergedN.txt").readText())
}
