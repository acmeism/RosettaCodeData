// version 1.1.2

const val ESC = "\u001B"
const val NORMAL = ESC + "[0"
const val BOLD   = ESC + "[1"
const val BLINK  = ESC + "[5"      // not working on my machine
const val BLACK  = ESC + "[0;40m"  // black background
const val WHITE  = ESC + "[0;37m"  // normal white foreground

fun main(args: Array<String>) {
    print("${ESC}c") // clear terminal first
    print(BLACK)     // set background color to black
    val foreColors = listOf(
        ";31m" to "red",
        ";32m" to "green",
        ";33m" to "yellow",
        ";34m" to "blue",
        ";35m" to "magenta",
        ";36m" to "cyan",
        ";37m" to "white"
    )
    for (attr in listOf(NORMAL, BOLD, BLINK)) {
        for (color in foreColors) println("$attr${color.first}${color.second}")
    }
    println(WHITE)  // set foreground color to normal white
}
