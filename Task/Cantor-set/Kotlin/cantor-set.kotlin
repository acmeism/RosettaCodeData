// Version 1.2.31

const val WIDTH = 81
const val HEIGHT = 5

val lines = List(HEIGHT) { CharArray(WIDTH) { '*' } }

fun cantor(start: Int, len: Int, index: Int) {
    val seg = len / 3
    if (seg == 0) return
    for (i in index until HEIGHT) {
        for (j in start + seg until start + seg * 2) lines[i][j] = ' '
    }
    cantor(start, seg, index + 1)
    cantor(start + seg * 2, seg, index + 1)
}

fun main(args: Array<String>) {
    cantor(0, WIDTH, 1)
    lines.forEach { println(it) }
}
