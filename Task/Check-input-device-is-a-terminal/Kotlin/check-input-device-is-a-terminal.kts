// Kotlin Native version 0.5

import platform.posix.*

fun main(args: Array<String>) {
    if (isatty(STDIN_FILENO) != 0)
        println("stdin is a terminal")
    else
        println("stdin is not a terminal")
}
