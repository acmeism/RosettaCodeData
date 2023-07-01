// version 1.0.6

/* testing on Windows 10 which needs administrative privileges
   to delete files from the root */

import java.io.File

fun main(args: Array<String>) {
    val paths = arrayOf("input.txt", "docs", "c:\\input.txt", "c:\\docs")
    var f: File
    for (path in paths) {
        f = File(path)
        if (f.delete())
            println("$path successfully deleted")
        else
            println("$path could not be deleted")
    }
}
