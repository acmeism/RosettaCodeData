// version 1.1.2

fun inCarpet(x: Int, y: Int): Boolean {
    var xx = x
    var yy = y
    while (xx != 0 && yy != 0) {
        if (xx % 3 == 1 && yy % 3 == 1) return false
        xx /= 3
        yy /= 3
    }
    return true
}

fun carpet(n: Int) {
    val power = Math.pow(3.0, n.toDouble()).toInt()
    for(i in 0 until power) {
        for(j in 0 until power) print(if (inCarpet(i, j)) "*" else " ")
        println()
    }
}

fun main(args: Array<String>) = carpet(3)
