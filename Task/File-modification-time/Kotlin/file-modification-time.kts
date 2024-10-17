// version 1.0.6

import java.io.File

fun main(args: Array<String>) {
    val filePath = "input.txt" // or whatever
    val file = File(filePath)
    with (file) {
        println("%tc".format(lastModified()))
        // update to current time, say
        setLastModified(System.currentTimeMillis())
        println("%tc".format(lastModified()))
    }
}
