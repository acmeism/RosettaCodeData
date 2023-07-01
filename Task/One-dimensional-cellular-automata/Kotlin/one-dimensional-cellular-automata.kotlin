// version 1.1.4-3

val trans = "___#_##_"

fun v(cell: StringBuilder, i: Int) = if (cell[i] != '_') 1 else 0

fun evolve(cell: StringBuilder, backup: StringBuilder): Boolean {
    val len = cell.length - 2
    var diff = 0
    for (i in 1 until len) {
        /* use left, self, right as binary number bits for table index */
        backup[i] = trans[v(cell, i - 1) * 4 + v(cell, i) * 2 + v(cell, i + 1)]
        diff += if (backup[i] != cell[i]) 1 else 0
    }
    cell.setLength(0)
    cell.append(backup)
    return diff != 0
}

fun main(args: Array<String>) {
    val c = StringBuilder("_###_##_#_#_#_#__#__")
    val b = StringBuilder("____________________")
    do {
       println(c.substring(1))
    }
    while (evolve(c,b))
}
