import "random" for Random
import "./fmt" for Fmt

var rand = Random.new()
var RAND_MAX = 32767

// cell states
var FILL  = 1
var RWALL = 2  // right wall
var BWALL = 4  // bottom wall

var x = 10
var y = 10
var grid = List.filled(x * (y + 2), 0)
var cells = 0
var end = 0
var m = 0
var n = 0

var makeGrid = Fn.new { |p|
    var thresh = (p * RAND_MAX).truncate
    m = x
    n = y
    for (i in 0...grid.count) grid[i] = 0  // clears grid
    for (i in 0...m) grid[i] = BWALL | RWALL
    cells = m
    end = m
    for (i in 0...y) {
        for (j in x - 1..1) {
            var r1 = rand.int(RAND_MAX + 1)
            var r2 = rand.int(RAND_MAX + 1)
            grid[end] = ((r1 < thresh) ? BWALL : 0) |
                        ((r2 < thresh) ? RWALL : 0)
            end = end + 1
        }
        var r3 = rand.int(RAND_MAX + 1)
        grid[end] = RWALL | ((r3 < thresh) ? BWALL : 0)
        end = end + 1
    }
}

var showGrid = Fn.new {
    for (j in 0...m) System.write("+--")
    System.print("+")

    for (i in 0..n) {
        System.write((i == n) ? " " : "|")
        for (j in 0...m) {
            System.write(((grid[i * m + j + cells] & FILL) != 0) ? "[]" : "  ")
            System.write(((grid[i * m + j + cells] & RWALL) != 0) ? "|" : " ")
        }
        System.print()
        if (i == n) return
        for (j in 0...m) {
            System.write(((grid[i * m + j + cells] & BWALL) != 0) ? "+--" : "+  ")
        }
        System.print("+")
    }
}

var fill // recursive
fill = Fn.new { |p|
    if ((grid[p] & FILL) != 0) return false
    grid[p] = grid[p] | FILL
    if (p >= end) return true  // success: reached bottom row
    return (((grid[p + 0] & BWALL) == 0) && fill.call(p + m)) ||
           (((grid[p + 0] & RWALL) == 0) && fill.call(p + 1)) ||
           (((grid[p - 1] & RWALL) == 0) && fill.call(p - 1)) ||
           (((grid[p - m] & BWALL) == 0) && fill.call(p - m))
}

var percolate = Fn.new {
    var i = 0
    while (i < m && !fill.call(cells + i)) i = i + 1
    return i < m
}

makeGrid.call(0.5)
percolate.call()
showGrid.call()

System.print("\nRunning %(x) x %(y) grids 10,000 times for each p:")
for (p in 1..9) {
    var cnt = 0
    var pp = p / 10
    for (i in 0...10000) {
        makeGrid.call(pp)
        if (percolate.call()) cnt = cnt + 1
    }
    Fmt.print("p = $3g: $.4f", pp, cnt / 10000)
}
