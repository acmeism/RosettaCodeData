// version 1.1.2

const val ESC = "\u001B"  // escape code

fun main(args: Array<String>) {
    print("$ESC[2J")     // clear terminal first
    print("$ESC[10;10H") // move cursor to (10, 10) say
    val aecs = arrayOf(
        "[1D",    // left
        "[1C",    // right
        "[1A",    // up
        "[1B",    // down
        "[9D",    // line start
        "[H",     // top left
        "[24;79H" // bottom right - assuming 80 x 24 terminal
    )
    for (aec in aecs) {
        Thread.sleep(3000) // three second display between cursor movements
        print("$ESC$aec")
    }
    Thread.sleep(3000)
    println()
}
