// version 1.1.51

import java.io.File

fun saveWithBackup(fileName: String, vararg data: String) {
    val orig = File(fileName)
    // canonicalPath follows symlinks to their ends
    val backup = File(orig.canonicalPath + ".backup")
    orig.renameTo(backup)
    val pw = orig.printWriter()
    for (i in data.indices) {
        pw.print(data[i])
        if (i < data.lastIndex) pw.println()
    }
    pw.close()
}

fun main(args: Array<String>) {
    saveWithBackup("original.txt", "fourth", "fifth", "sixth")
}
