// version 1.0.6

fun main(args: Array<String>) {
    print("  x|")
    for (i in 1..12) print("%4d".format(i))
    println("\n---+${"-".repeat(48)}")
    for (i in 1..12) {
        print("%3d".format(i) +"|${" ".repeat(4 * i - 4)}")
        for (j in i..12) print("%4d".format(i * j))
        println()
    }
}
