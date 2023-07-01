// version 1.2.10

import java.io.File
import java.util.Date
import java.text.SimpleDateFormat

fun main(args: Array<String>) {
    val f = File("NOTES.TXT")
    // create file if it doesn't exist already
    f.createNewFile()
    if (args.size == 0) {
        println(f.readText())
    }
    else {
        val df = SimpleDateFormat("yyyy/MM/dd HH:mm:ss")
        val dt = df.format(Date())
        val notes = "$dt\n\t${args.joinToString(" ")}\n"
        f.appendText(notes)
    }
}
