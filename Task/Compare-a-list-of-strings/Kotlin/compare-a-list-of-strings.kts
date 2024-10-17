// version 1.0.6

fun areEqual(strings: Array<String>): Boolean {
    if (strings.size < 2) return true
    return (1 until strings.size).all { strings[it] == strings[it - 1] }
}

fun areAscending(strings: Array<String>): Boolean {
    if (strings.size < 2) return true
    return (1 until strings.size).all { strings[it] > strings[it - 1] }
}

// The strings are given in the command line arguments

fun main(args: Array<String>) {
    println("The strings are : ${args.joinToString()}")
    if (areEqual(args)) println("They are all equal")
    else if (areAscending(args)) println("They are in strictly ascending order")
    else println("They are neither equal nor in ascending order")
}
