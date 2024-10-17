// version 1.2.0

import java.io.File

fun main(args: Array<String>) {
    val files = arrayOf("file1.txt", "file2.txt")
    for (file in files) {
        val f = File(file)
        var text = f.readText()
        println(text)
        text = text.replace("Goodbye London!", "Hello New York!")
        f.writeText(text)
        println(f.readText())
    }
}
