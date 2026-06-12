// version 1.1.51

import java.io.File

fun process(line: String): String {
   with (line) {
       val a = substring(0, 5)
       val n = (substring(14, 15) + substring(10, 14)).toInt()
       return String.format("%s%5dXXXXX", a, n)
   }
}

fun main(args: Array<String>) {
    val out = File("selective_output.txt")
    val pw = out.printWriter()
    File("selective_input.txt").forEachLine { pw.println(process(it)) }
    pw.close()
    // check it worked
    println(out.readText())
}
