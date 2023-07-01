// version 1.1.2

const val ORDER = 4
const val SIZE  = 1 shl ORDER

fun main(args: Array<String>) {
    for (y in SIZE - 1 downTo 0) {
        for (i in 0 until y) print(" ")
        for (x in 0 until SIZE - y) print(if ((x and y) != 0) "  " else "* ")
        println()
    }
}
