// version 1.0.6

fun main(args: Array<String>) {
    for (i in 0 .. 2) {
        for (j in 0 .. 2) {
            if (i + j == 2) continue
            if (i + j == 3) break
            println(i + j)
        }
    }
    println()
    if (args.isNotEmpty()) throw IllegalArgumentException("No command line arguments should be supplied")
    println("Goodbye!")  // won't be executed
}
