// version 1.0.6

fun main(args: Array<String>) {
    val greek = arrayOf("alpha", "beta", "gamma", "delta")
    for (letter in greek) print("$letter ")
    println()
    // or alternatively
    greek.forEach { print("$it ") }
    println()
}
