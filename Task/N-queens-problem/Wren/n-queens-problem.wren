var count = 0
var c = []
var f = []

var nQueens // recursive
nQueens = Fn.new { |row, n|
    for (x in 1..n) {
        var outer = false
        var y = 1
        while (y < row) {
            if ((c[y] == x) || (row - y == (x -c[y]).abs)) {
                outer = true
                break
            }
            y = y + 1
        }
        if (!outer) {
            c[row] = x
            if (row < n) {
                nQueens.call(row + 1, n)
            } else {
                count = count + 1
                if (count == 1) f = c.skip(1).map { |i| i - 1 }.toList
            }
        }
    }
}

for (n in 1..14) {
    count = 0
    c = List.filled(n+1, 0)
    f = []
    nQueens.call(1, n)
    System.print("For a %(n) x %(n) board:")
    System.print("  Solutions = %(count)")
    if (count > 0) System.print("  First is %(f)")
    System.print()
}
