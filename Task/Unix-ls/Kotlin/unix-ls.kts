// Version 1.2.41

import java.io.File

fun ls(directory: String) {
    val d = File(directory)
    if (!d.isDirectory) {
        println("$directory is not a directory")
        return
    }
    d.listFiles().map { it.name }
                 .sortedBy { it.toLowerCase() }  // case insensitive
                 .forEach { println(it) }
}

fun main(args: Array<String>) {
    ls(".")  // list files in current directory, say
}
