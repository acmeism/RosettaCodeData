// version 1.1

import java.util.*

fun main(args: Array<String>) {
    println("Keep entering text or the word 'quit' to end the program:")
    val sc = Scanner(System.`in`)
    val words = mutableListOf<String>()
    while (true) {
        val input: String = sc.next()
        if (input.trim().toLowerCase() == "quit") {
            if (words.size > 0) println("\nYou entered the following words:\n${words.joinToString("\n")}")
            return
        }
        words.add(input)
    }
}
