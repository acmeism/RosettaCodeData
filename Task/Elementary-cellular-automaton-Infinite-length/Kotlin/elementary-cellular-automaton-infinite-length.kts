// version 1.1.51

fun evolve(l: Int, rule: Int) {
    println(" Rule #$rule:")
    var cells = StringBuilder("*")
    for (x in 0 until l) {
        addNoCells(cells)
        val width = 40 + (cells.length shr 1)
        println(cells.padStart(width))
        cells = step(cells, rule)
    }
}

fun step(cells: StringBuilder, rule: Int): StringBuilder {
    val newCells = StringBuilder()
    for (i in 0 until cells.length - 2) {
        var bin = 0
        var b = 2
        for (n in i until i + 3) {
            bin += (if (cells[n] == '*') 1 else 0) shl b
            b = b shr 1
        }
        val a = if ((rule and (1 shl bin)) != 0) '*' else '.'
        newCells.append(a)
    }
    return newCells
}

fun addNoCells(s: StringBuilder) {
    val l = if (s[0] == '*') '.' else '*'
    val r = if (s[s.length - 1] == '*') '.' else '*'
    repeat(2) {
       s.insert(0, l)
       s.append(r)
    }
}

fun main(args: Array<String>) {
    evolve(35, 90)
    println()
}
