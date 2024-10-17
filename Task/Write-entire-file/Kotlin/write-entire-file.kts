// version 1.1.2

import java.io.File

fun main(args: Array<String>) {
    val text = "empty vessels make most noise"
    File("output.txt").writeText(text)
}
