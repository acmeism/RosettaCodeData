// version 1.1.3

var count = 0
var c = IntArray(0)
var f = ""

fun nQueens(row: Int, n: Int) {
    outer@ for (x in 1..n) {
        for (y in 1..row - 1) {
            if (c[y] == x) continue@outer
            if (row - y == Math.abs(x - c[y])) continue@outer
        }
        c[row] = x
        if (row < n) nQueens(row + 1, n)
        else if (++count == 1) f = c.drop(1).map { it - 1 }.toString()
    }
}

fun main(args: Array<String>) {
   for (n in 1..14) {
       count = 0
       c = IntArray(n + 1)
       f = ""
       nQueens(1, n)
       println("For a $n x $n board:")
       println("  Solutions = $count")
       if (count > 0) println("  First is $f")
       println()
   }
}
