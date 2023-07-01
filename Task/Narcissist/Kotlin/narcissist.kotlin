// version 1.1.0 (run on Windows 10)

fun main(args: Array<String>) {
    val text = java.io.File("narcissist.kt").readText()
    println("Enter the number of lines to be input followed by those lines:\n")
    val n = readLine()!!.toInt()
    val lines = Array<String>(n) { readLine()!! }
    if (lines.joinToString("\r\n") == text) println("\naccept") else println("\nreject")
}
