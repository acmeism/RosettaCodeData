// version 1.1

fun output(lines: Array<String>) = println(lines.joinToString("\n"))

fun main(args: Array<String>) {
    println("Enter the number of lines to be input followed by those lines:\n")
    val n = readLine()!!.toInt()
    val lines = Array(n) { readLine()!! }
    println("\nThe lines you entered are:\n")
    output(lines)
}
