// version 1.0.6

import java.io.File

fun main(args: Array<String>) {
    val paths = arrayOf("input.txt", "c:\\input.txt")
    for (path in paths)
        println("Length of $path is ${File(path).length()} bytes")
}
