// version 1.1.2

import java.io.FileOutputStream
import java.nio.channels.FileChannel

fun truncateFile(fileName: String, newSize: Long) {
    var fc: FileChannel? = null
    try {
        fc = FileOutputStream(fileName, true).channel
        if (newSize >= fc.size())
            println("Requested file size isn't less than existing size")
        else
            fc.truncate(newSize)
    }
    catch (ex: Exception) {
        println(ex.message)
    }
    finally {
        fc!!.close()
    }
}

fun main(args: Array<String>) {
    truncateFile("test.txt", 10)
}
