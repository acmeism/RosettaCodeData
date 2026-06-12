import "./math" for Nums
import "./fmt" for Fmt

var printMinCells = Fn.new { |n|
    System.print("Minimum number of cells after, before, above and below %(n) x %(n) square:")
    var p = (n < 21) ? 1 : 2
    for (r in 0...n) {
        var cells = List.filled(n, 0)
        for (c in 0...n) cells[c] = Nums.min([n-r-1, r, c, n-c-1])
        Fmt.print("$*d", p, cells)
    }
}

for (n in [23, 10, 9, 2, 1]) {
    printMinCells.call(n)
    System.print()
}
