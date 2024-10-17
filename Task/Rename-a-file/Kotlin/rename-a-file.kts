// version 1.0.6

/* testing on Windows 10 which needs administrative privileges
   to rename files in the root */

import java.io.File

fun main(args: Array<String>) {
    val oldPaths = arrayOf("input.txt", "docs", "c:\\input.txt", "c:\\docs")
    val newPaths = arrayOf("output.txt", "mydocs", "c:\\output.txt", "c:\\mydocs")
    var oldFile: File
    var newFile: File
    for (i in 0 until oldPaths.size) {
        oldFile = File(oldPaths[i])
        newFile = File(newPaths[i])
        if (oldFile.renameTo(newFile))
            println("${oldPaths[i]} successfully renamed to ${newPaths[i]}")
        else
            println("${oldPaths[i]} could not be renamed")
    }
}
