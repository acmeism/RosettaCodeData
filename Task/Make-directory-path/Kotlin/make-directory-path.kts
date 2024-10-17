// version 1.0.6

import java.io.File

fun main(args: Array<String>) {
    // using built-in mkdirs() method
    val success = File("./path/to/dir").mkdirs()
    if (success) println("Directory path was created successfully")
    else         println("Failed to create directory path")
}
