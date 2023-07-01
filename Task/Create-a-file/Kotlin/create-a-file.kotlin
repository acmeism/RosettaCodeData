/* testing on Windows 10 which needs administrative privileges
   to create files in the root */

import java.io.File

fun main(args: Array<String>) {
    val filePaths = arrayOf("output.txt", "c:\\output.txt")
    val dirPaths  = arrayOf("docs", "c:\\docs")
    var f: File
    for (path in filePaths) {
        f = File(path)
        if (f.createNewFile())
            println("$path successfully created")
        else
            println("$path already exists")
    }
    for (path in dirPaths) {
        f = File(path)
        if (f.mkdir())
            println("$path successfully created")
        else
            println("$path already exists")
    }
}
